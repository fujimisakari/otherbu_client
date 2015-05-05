//
//  MainViewController.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "MainViewController.h"
#import "WebViewController.h"
#import "SwapViewController.h"
#import "ModalViewController.h"
#import "ModalBKViewController.h"
#import "MainAlertController.h"
#import "ModalInterface.h"
#import "MainSectionHeaderView.h"
#import "MainScrollView.h"
#import "NavigationBar.h"
#import "InnerTableView.h"
#import "MainTableCellView.h"
#import "BookmarkData.h"
#import "CategoryData.h"
#import "ColorData.h"
#import "PageData.h"
#import "UserData.h"
#import "SearchData.h"
#import "PageTabView.h"
#import "MBProgressHUD.h"

@interface MainViewController () {
    id<DataInterface>   _editItem;
    float               _viewWidth;
    float               _viewHeight;
    PageData            *_currentPage;
    PageTabView         *_currentPageTabView;
    BookmarkData        *_selectBookmark;
    NSMutableDictionary *_categoryListOfAngle;
    MainAlertController *_alertController;
}

@end

@implementation MainViewController

//--------------------------------------------------------------//
#pragma mark -- Controller Method --
//--------------------------------------------------------------//

- (void)viewDidLoad {
    [super viewDidLoad];

    // [self refreshBookmarks:self];

    UserData *user = [[DataManager sharedManager] getUser];
    _currentPage = [user page];

    // 初期値設定
    float marginOfHeight = _navigationBar.frame.size.height + _tabScrollView.frame.size.height + _tabFrameView.frame.size.height;
    _viewWidth = self.view.frame.size.width;
    _viewHeight = self.view.frame.size.height - marginOfHeight;

    // ScrollView設定
    CGSize cgSize = CGSizeMake(_viewWidth * kNumberOfPages, _viewHeight);
    [_scrollView setupWithCGSize:cgSize delegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // NavigationBar設定
    [self _setupNavigationBar];

    // 背景画像設定
    CGRect rect = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + _navigationBar.frame.size.height,
                             self.view.frame.size.width, self.view.frame.size.height);
    [Helper setupBackgroundImage:rect TargetView:self.view];

    // tableを最新に更新
    if (_currentPage) {
        _categoryListOfAngle = [_currentPage getCategoryListOfAngle];
        [_scrollView reloadTableData];
    }

    // pageTabViewを配置
    [self _createPageTabViews];
    [self _moveTabScroll:_currentPageTabView];

    // 項目追加用のActionSheetを準備
    [self _setupActionSheet];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self _removePageTabViews];

    [_navigationBar deleteButtonInMainScene];
}

- (void)_setupNavigationBar {
    [_navigationBar setup];
    [_navigationBar setButtonInMainScene];
    UIBarButtonItem *addButton = _navigationBar.topItem.leftBarButtonItems[0];
    addButton.target = self;
    addButton.action = @selector(_actionListAlertView:);
    UIBarButtonItem *searchButton = _navigationBar.topItem.leftBarButtonItems[1];
    searchButton.target = self;
    searchButton.action = @selector(_openWebView:);
    UIBarButtonItem *settingButton = _navigationBar.topItem.rightBarButtonItems[0];
    settingButton.target = self;
    settingButton.action = @selector(_openSettingView:);
    UIBarButtonItem *swapButton = _navigationBar.topItem.rightBarButtonItems[1];
    swapButton.target = self;
    swapButton.action = @selector(_openSwapView:);
}

- (void)_setupActionSheet {
    NSMutableDictionary *actionDict = [[NSMutableDictionary alloc] init];
    actionDict[@"page"] = ^(UIAlertAction * action) {
        _editItem = [PageData alloc];
        [self performSegueWithIdentifier:kToModalViewBySegue sender:self];
    };
    actionDict[@"category"] = ^(UIAlertAction * action) {
        _editItem = [CategoryData alloc];
        [self performSegueWithIdentifier:kToModalViewBySegue sender:self];
    };
    actionDict[@"bookmark"] = ^(UIAlertAction * action) {
        _editItem = [BookmarkData alloc];
        [self performSegueWithIdentifier:kToModalBKViewBySegue sender:self];
    };

    _alertController = [MainAlertController alertControllerWithTitle:@""
                                                             message:@"追加する項目を選んでください"
                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    [_alertController setActionDict:actionDict];
    [_alertController setup];
}

//--------------------------------------------------------------//
#pragma mark -- UIScrollViewDelegate --
//--------------------------------------------------------------//

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // スクロール時の処理
    if (scrollView == _scrollView) {
        // 横スクロールのみ可能にする
        CGPoint currentPoint = [scrollView contentOffset];
        [scrollView setContentOffset:CGPointMake(currentPoint.x, 0.0)];

        // UIScrollViewのページ切替時にUIPageControlの現在ページを切り替える
        _pageControl.currentPage = _scrollView.contentOffset.x / _viewWidth;
    }
}

//--------------------------------------------------------------//
#pragma mark -- UITableViewDataSource --
//--------------------------------------------------------------//

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // テーブル全体のセクションの数を返す
    if (_currentPage) {
        NSArray *categoryList = [self _getCategoryListByTag:tableView.tag];
        return categoryList.count;
    } else {
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // 指定されたセクションのセクション名を返す
    if (_currentPage) {
        CategoryData *categoryData = [self _getCategoryListByTag:tableView.tag][section];
        return categoryData.name;
    } else {
        return @"";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 指定されたセクションの項目数を返す
    if (_currentPage) {
        CategoryData *categoryData = [self _getCategoryListByTag:tableView.tag][section];
        NSArray *bookmarkList = [categoryData getBookmarkList];
        return categoryData.isOpenSection ? bookmarkList.count : 0;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 指定された箇所のセルを作成する
    MainTableCellView *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        cell = [[MainTableCellView alloc] initWithCellIdentifier:kCellIdentifier ContentSizeWidth:tableView.contentSize.width];
    }
    cell.delegate = self;

    if (_currentPage) {
        CategoryData *categoryData = [self _getCategoryListByTag:tableView.tag][indexPath.section];
        cell.category = categoryData;
        cell.bookmark = [categoryData getBookmarkList][indexPath.row];
        cell = [cell setupWithPageData:_currentPage indexPath:indexPath];
    }
    return cell;
}

//--------------------------------------------------------------//
#pragma mark -- MainTableCellViewDelegate --
//--------------------------------------------------------------//

- (void)didLongPressBookmark:(BookmarkData *)selectBookmark {
    // PageTabの長押し時の実行処理
    _editItem = selectBookmark;
    [self performSegueWithIdentifier:kToModalBKViewBySegue sender:self];
}

//--------------------------------------------------------------//
#pragma mark -- UITableViewDelegate --
//--------------------------------------------------------------//

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    // セクションヘッダーの高さを返す
    return kHeightOfSectionHeader;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    // セクションヘッダーのコンテンツを設定する
    if (_currentPage) {
        CategoryData *categoryData = [self _getCategoryListByTag:tableView.tag][section];
        CGRect frame = CGRectMake(0, 0, _viewWidth, kHeightOfSectionHeader);
        MainSectionHeaderView *containerView =
            [[MainSectionHeaderView alloc] initWithCategory:categoryData frame:frame section:section delegate:self tagNumber:tableView.tag];
        return containerView;
    } else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // セルタップ時に実行される処理
    CategoryData *categoryData = [self _getCategoryListByTag:tableView.tag][indexPath.section];
    _selectBookmark = [categoryData getBookmarkList][indexPath.row];

    // toViewController
    [self performSegueWithIdentifier:kToWebViewBySegue sender:self];
}

//--------------------------------------------------------------//
#pragma mark -- SectionHeaderViewDelegate --
//--------------------------------------------------------------//

- (void)didSectionHeaderSingleTap:(NSInteger)section tagNumber:(NSInteger)tagNumber {
    // セクションヘッダーのシングルタップ時の実行処理
    CategoryData *categoryData = [self _getCategoryListByTag:tagNumber][section];
    UITableView *tableView = (UITableView *)[_scrollView viewWithTag:tagNumber];

    [tableView beginUpdates];

    NSMutableArray *indexPaths;
    if (categoryData.isOpenSection) {
        categoryData.isOpenSection = NO;
        indexPaths = [self _getIndexPathsOfSectionContents:section categoryData:categoryData];
        [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    } else {
        categoryData.isOpenSection = YES;
        indexPaths = [self _getIndexPathsOfSectionContents:section categoryData:categoryData];
        [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    }

    [tableView endUpdates];
}

- (void)didLongPressCategory:(CategoryData *)category {
    // セクションタブの長押し時の実行処理
    _editItem = category;
    [self performSegueWithIdentifier:kToModalViewBySegue sender:self];
}

- (NSMutableArray *)_getIndexPathsOfSectionContents:(NSInteger)section categoryData:(CategoryData *)categoryData {
    // セクションのコンテンツ情報をindexPath形式で取得
    NSArray *bookmarkList = [categoryData getBookmarkList];
    NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithCapacity:bookmarkList.count];
    for (int i = 0; i < bookmarkList.count; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }
    return indexPaths;
}

//--------------------------------------------------------------//
#pragma mark -- PageTabViewDelegate --
//--------------------------------------------------------------//

- (void)didSingleTapPageTab:(PageData *)selectPage pageTabView:(PageTabView *)tappedPageTabView {
    // PageTabのシングルタップ時の実行処理

    // 選択中のPageTabをタップした場合は動作させない
    if ([_currentPage.dataId isEqualToString:selectPage.dataId]) {
            return;
    }

    UserData *user = [[DataManager sharedManager] getUser];
    [user updatePage:selectPage.dataId];
    [[DataManager sharedManager] save:SAVE_USER];

    // pageを入れ替え、tableのリロード
    _currentPage = selectPage;
    _categoryListOfAngle = [_currentPage getCategoryListOfAngle];
    [_scrollView reloadTableDataByAnimation];

    // switch PageTabView
    [tappedPageTabView switchTabStatus];
    [_currentPageTabView switchTabStatus];
    _currentPageTabView = tappedPageTabView;

    // move sclollbar
    [_scrollView scrollToTop];
    [self _moveTabScroll:tappedPageTabView];

    // set TabFrameView
    _tabFrameView.backgroundColor = [[selectPage color] getFooterColorOfGradient];
}

- (void)didLongPressPageTab:(PageData *)selectPage pageTabView:(PageTabView *)tappedPageTabView {
    // PageTabの長押し時の実行処理

    // ALLのPageTabを長押しした場合は動作させない
    if ([selectPage.dataId isEqualToString:@"AllCategory"]) {
            return;
    }

    _editItem = selectPage;
    [self performSegueWithIdentifier:kToModalViewBySegue sender:self];
}

- (void)_moveTabScroll:(PageTabView *)tappedPageTabView {
    // タップされたタブViewを適切な場所へ移動させる
    if (_viewWidth > _tabScrollView.contentSize.width) {
        // 全タブの幅が画面以上に満たない場合は左寄せ
        CGPoint point = CGPointMake(0.0, 0.0);
        [_tabScrollView setContentOffset:point animated:YES];
    } else {
        // タップされたタブViewを移動させる
        float halfPageWidth = _viewWidth / 2;
        if (tappedPageTabView.center.x > halfPageWidth) {
            float subWidth;
            float restContentWidth = _tabScrollView.contentSize.width - tappedPageTabView.center.x;
            if (restContentWidth > halfPageWidth) {
                // 画面半分以上を満たしてるtabの場合は中央寄せ
                subWidth = halfPageWidth;
            } else {
                // 画面半分以上を満たしてるけど中央寄せした場合、contentSize以上になる場合は微調整
                subWidth = halfPageWidth + (halfPageWidth - restContentWidth);
            }
            CGPoint point = CGPointMake(tappedPageTabView.center.x - subWidth, 0.0);
            [_tabScrollView setContentOffset:point animated:YES];
        } else {
            // 画面半分以上に満たないtabの場合は左寄せ
            CGPoint point = CGPointMake(0.0, 0.0);
            [_tabScrollView setContentOffset:point animated:YES];
        }
    }
}

//--------------------------------------------------------------//
#pragma mark -- ModalViewDelegate --
//--------------------------------------------------------------//

- (void)returnActionOfModal:(NSInteger)menuId {
    // モーダル編集画面で更新した場合の処理

    //
    if ([_currentPage.dataId isEqualToString:kDefaultPageDataId]) {
        _currentPage = [[DataManager sharedManager] getPage:_currentPage.dataId];
        _categoryListOfAngle = [_currentPage getCategoryListOfAngle];
    }

    switch (menuId) {
        case MENU_PAGE :
            [self _removePageTabViews];
            [self _createPageTabViews];
            [self _moveTabScroll:_currentPageTabView];
            break;
        case MENU_BOOKMARK :
            [_scrollView reloadTableData];
            break;
        case MENU_CATEGORY :
            [_scrollView reloadTableData];
            break;
    }
}

//--------------------------------------------------------------//
#pragma mark -- segue --
//--------------------------------------------------------------//

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // WebViewへページ遷移
    if ([[segue identifier] isEqualToString:kToWebViewBySegue]) {
        WebViewController *webViewController = (WebViewController *)[segue destinationViewController];
        webViewController.bookmark = _selectBookmark;
    } else if ([[segue identifier] isEqualToString:kToSwapViewBySegue]) {
        SwapViewController *swapViewController = (SwapViewController *)[segue destinationViewController];
        swapViewController.page = _currentPage;
    } else if ([[segue identifier] isEqualToString:kToModalViewBySegue]) {
        ModalViewController *modalViewController = (ModalViewController *)[segue destinationViewController];
        modalViewController.delegate = self;
        modalViewController.editItem = _editItem;
    } else if ([[segue identifier] isEqualToString:kToModalBKViewBySegue]) {
        ModalBKViewController *modalBKViewController = (ModalBKViewController *)[segue destinationViewController];
        modalBKViewController.delegate = self;
        modalBKViewController.editItem = _editItem;
    }
}

- (void)_openSettingView:(UIButton *)sender {
    [self performSegueWithIdentifier:kToSettingBySegue sender:self];
}

- (void)_openWebView:(UIButton *)sender {
    SearchData *search = [[[DataManager sharedManager] getUser] search];
    BookmarkData *bookmark = [[BookmarkData alloc] init];
    bookmark.url = search.url;
    _selectBookmark = bookmark;
    [self performSegueWithIdentifier:kToWebViewBySegue sender:self];
}

- (void)_openSwapView:(UIButton *)sender {
    [self performSegueWithIdentifier:kToSwapViewBySegue sender:self];
}

- (void)_actionListAlertView:(UIButton *)sender {
    [self presentViewController:_alertController animated:YES completion:nil];
}

//--------------------------------------------------------------//
#pragma mark -- Update Data By Connect Network --
//--------------------------------------------------------------//

- (void)refreshBookmarks:(id)sender {
    // todo コントローラではない場所におく
    // サーバからデータ取得
    // [self.refreshControl beginRefreshing];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[DataManager sharedManager] reloadDataWithBlock:^(NSError *error) {
        if (error) {
            NSLog(@"error = %@", error);
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        UserData *user = [[DataManager sharedManager] getUser];
        _currentPage = [user page];
        _categoryListOfAngle = [_currentPage getCategoryListOfAngle];

        [_scrollView reloadTableDataByAnimation];
        [self _createPageTabViews];
        [self _moveTabScroll:_currentPageTabView];
        // [self.refreshControl endRefreshing];
    }];
}

- (void)_createPageTabViews {
    // set PageTabView
    float offsetX = 0;
    for (PageData *pageData in [[DataManager sharedManager] getPageListForMainScene]) {
        CGSize textSize = [PageTabView getTextSizeOfPageViewWithString:pageData.name];
        CGRect rect = CGRectMake(offsetX, kOffsetYOfPageTab, textSize.width, textSize.height);
        PageTabView *pageTabView = [[PageTabView alloc] initWithFrame:rect];
        [pageTabView setUpWithPage:pageData delegate:self];
        if ([pageData.dataId isEqualToString:_currentPage.dataId]) {
            _currentPageTabView = pageTabView;
            [pageTabView switchTabStatus];
        }
        [_tabScrollView addSubview:pageTabView];
        offsetX += pageTabView.bounds.size.width + 1;
    }
    CGSize cgSize = CGSizeMake(offsetX, kHeightOfPageTab);
    _tabScrollView.contentSize = cgSize;

    // set TabFrameView
    _tabFrameView.backgroundColor = [[_currentPage color] getFooterColorOfGradient];
}

- (void)_removePageTabViews {
    for (UIView *view in [_tabScrollView subviews]) {
        [view removeFromSuperview];
    }
}

- (int)_getCurrentAngleId {
    return (int)_pageControl.currentPage + 1;
}

- (NSMutableArray *)_getCategoryListByTag:(NSInteger)tag {
    // tag(angle)からカテゴリ一覧を取得
    NSNumber *angleNumber = [[NSNumber alloc] initWithInt:(int)tag];
    NSMutableArray *categoryList = _categoryListOfAngle[angleNumber];
    return categoryList;
}

@end
