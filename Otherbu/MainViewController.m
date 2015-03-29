//
//  MainViewController.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "MainViewController.h"
#import "WebViewController.h"
#import "SectionHeaderView.h"
#import "MainScrollView.h"
#import "NavigationBar.h"
#import "InnerTableView.h"
#import "MainTableCellView.h"
#import "BookmarkData.h"
#import "CategoryData.h"
#import "ColorData.h"
#import "PageData.h"
#import "PageTabView.h"
#import "MBProgressHUD.h"

@interface MainViewController ()

@property(nonatomic) float        viewWidth;
@property(nonatomic) float        viewHeight;
@property(nonatomic) PageData     *currentPage;
@property(nonatomic) PageTabView  *currentPageTabView;
@property(nonatomic) BookmarkData *selectBookmark;

@end

@implementation MainViewController

//--------------------------------------------------------------//
#pragma mark -- Controller Method --
//--------------------------------------------------------------//

- (void)viewDidLoad {
    [super viewDidLoad];

    [self refreshBookmarks:self];

    // setup init value
    float marginOfHeight = _navigationBar.frame.size.height + _tabScrollView.frame.size.height + _tabFrameView.frame.size.height;
    _viewWidth = self.view.frame.size.width;
    _viewHeight = self.view.frame.size.height - marginOfHeight;

    // setup BackgroundImage
    [self _setupBackgroundImage];

    // setup NavigationBar
    [_navigationBar setup];
    _navigationBar.topItem.leftBarButtonItem.target = self;
    _navigationBar.topItem.leftBarButtonItem.action = @selector(_openSettingView:);

    // setup ScrollView
    CGSize cgSize = CGSizeMake(_viewWidth * kNumberOfPages, _viewHeight);
    [_scrollView setupWithCGSize:cgSize delegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    // 画面が表示され終ったらWebPageの読み込み
    [super viewDidAppear:animated];
}

- (void)_setupBackgroundImage {
    // UIViewContollerに背景画像を設定する
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0.0);
    [[UIImage imageNamed:kDefaultImageName] drawInRect:self.view.bounds];
    UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CALayer *layer = [CALayer layer];
    layer.contents = (id)backgroundImage.CGImage;
    layer.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + _navigationBar.frame.size.height,
                             self.view.frame.size.width, self.view.frame.size.height);
    layer.zPosition = -1.0;
    [self.view.layer addSublayer:layer];
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
        NSArray *categoryList = [_currentPage getCategoryListByTag:tableView.tag];
        return categoryList.count;
    } else {
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // 指定されたセクションのセクション名を返す
    if (_currentPage) {
        CategoryData *categoryData = [_currentPage getCategoryListByTag:tableView.tag][section];
        return categoryData.name;
    } else {
        return @"";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 指定されたセクションの項目数を返す
    if (_currentPage) {
        CategoryData *categoryData = [_currentPage getCategoryListByTag:tableView.tag][section];
        NSArray *bookmarkList = [categoryData getBookmarkList];
        return categoryData.isOpenSection ? bookmarkList.count : 0;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 指定された箇所のセルを作成する
    NSString *cellIdentifier = @"Cell";
    MainTableCellView *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [MainTableCellView initWithCellIdentifier:cellIdentifier];
    }

    if (_currentPage) {
        cell = [cell setupWithPageData:_currentPage tableView:tableView indexPath:indexPath];
    }
    return cell;
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
        CategoryData *categoryData = [_currentPage getCategoryListByTag:tableView.tag][section];
        CGRect frame = CGRectMake(0, 0, _viewWidth, kHeightOfSectionHeader);
        SectionHeaderView *containerView =
            [[SectionHeaderView alloc] initWithCategory:categoryData frame:frame section:section delegate:self tagNumber:tableView.tag];
        return containerView;
    } else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // セルタップ時に実行される処理
    CategoryData *categoryData = [_currentPage getCategoryListByTag:tableView.tag][indexPath.section];
    _selectBookmark = [categoryData getBookmarkList][indexPath.row];

    // toViewController
    [self performSegueWithIdentifier:kToWebViewBySegue sender:self];
}

//--------------------------------------------------------------//
#pragma mark -- SectionHeaderViewDelegate --
//--------------------------------------------------------------//

- (void)didSectionHeaderSingleTap:(NSInteger)section tagNumber:(NSInteger)tagNumber {
    // セクションヘッダーのシングルタップ時の実行処理
    CategoryData *categoryData = [_currentPage getCategoryListByTag:tagNumber][section];
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

- (void)didPageTabSingleTap:(PageData *)selectPage pageTabView:(PageTabView *)tappedPageTabView {
    // PageTabのシングルタップ時の実行処理

    // pageを入れ替え、tableのリロード
    _currentPage = selectPage;
    [_scrollView reloadTableData];

    // switch PageTabView
    [tappedPageTabView switchTabStatus];
    [_currentPageTabView switchTabStatus];
    _currentPageTabView = tappedPageTabView;

    // move sclollbar
    [self _moveTabScroll:tappedPageTabView];

    // set TabFrameView
    _tabFrameView.backgroundColor = [[selectPage color] getFooterColorOfGradient];
}

- (void)_moveTabScroll:(PageTabView *)tappedPageTabView {
    // タップされたタブViewを適切な場所へ移動させる
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

//--------------------------------------------------------------//
#pragma mark -- segue --
//--------------------------------------------------------------//

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // WebViewへページ遷移
    if ([[segue identifier] isEqualToString:kToWebViewBySegue]) {
        WebViewController *webViewController = (WebViewController*)[segue destinationViewController];
        [webViewController setBookmark:_selectBookmark];
    }
}

//--------------------------------------------------------------//
#pragma mark -- Taupped Action --
//--------------------------------------------------------------//

- (void)_openSettingView:(UIButton *)sender {
    [self performSegueWithIdentifier:kToSettingBySegue sender:self];
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

        NSNumber *number = [[NSNumber alloc] initWithInt:16];  // とりあえず、仮でPageId:16をセット
        _currentPage = [[DataManager sharedManager] getPage:number];

        [_scrollView reloadTableData];
        [self _createPageTabViews];
        // [self.refreshControl endRefreshing];
    }];
}

- (void)_createPageTabViews {
    // PageTabViewを生成する
    DataManager *dataManager = [DataManager sharedManager];

    // set PageTabView
    float offsetX = 0;
    for (PageData *pageData in [dataManager.pageDict objectEnumerator]) {
        CGSize textSize = [PageTabView getTextSizeOfPageViewWithString:pageData.name];
        CGRect rect = CGRectMake(offsetX, kOffsetYOfPageTab, textSize.width, textSize.height);
        PageTabView *pageTabView = [PageTabView initWithFrame:rect];
        [pageTabView setUpWithPage:pageData delegate:self];
        if ((int)pageData.dataId == (int)_currentPage.dataId) {
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

@end
