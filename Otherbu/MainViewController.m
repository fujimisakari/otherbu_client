//
//  MainViewController.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "MainViewController.h"
#import "SectionHeaderView.h"
#import "ScrollView.h"
#import "NavigationBar.h"
#import "InnerTableView.h"
#import "TableCellView.h"
#import "DataManager.h"
#import "BookmarkData.h"
#import "CategoryData.h"
#import "ColorData.h"
#import "PageData.h"
#import "PageTabView.h"
#import "Constants.h"

@implementation MainViewController {
    float _viewWidth;
    float _viewHeight;
    PageData *_currentPage;
    PageTabView *_currentPageTabView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self refreshBookmarks:self];

    // setup view init
    float marginOfHeight = _navigationBar.frame.size.height + _tabScrollView.frame.size.height + _tabFrameView.frame.size.height;
    _viewWidth = self.view.frame.size.width;
    _viewHeight = self.view.frame.size.height - marginOfHeight;

    // setup BackgroundImage
    [self setupBackgroundImage];

    // setup NavigationBar
    [_navigationBar setup];

    // setup ScrollView
    CGSize cgSize = CGSizeMake(_viewWidth * kNumberOfPages, _viewHeight);
    [_scrollView setupWithCGSize:cgSize viewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)refreshBookmarks:(id)sender {
    // サーバからデータ取得
    // [self.refreshControl beginRefreshing];

    [[DataManager sharedManager] reloadDataWithBlock:^(NSError *error) {
        if (error) {
            NSLog(@"error = %@", error);
        }

        NSNumber *number = [[NSNumber alloc] initWithInt:16];  // とりあえず、仮でPageId:16をセット
        _currentPage = [[DataManager sharedManager] getPage:number];

        [self reloadTableData];
        [self createPageTabViews];
        // [self.refreshControl endRefreshing];
    }];
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
    TableCellView *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [TableCellView initWithCellIdentifier:cellIdentifier];
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
            [[SectionHeaderView alloc] initWithCategory:categoryData frame:frame section:section tag:tableView.tag];
        containerView.delegate = self;
        return containerView;
    } else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // セルタップ時に実行される処理
    // まだ何もしない
}

//--------------------------------------------------------------//
#pragma mark -- SectionHeaderViewDelegate --
//--------------------------------------------------------------//

- (void)didSectionHeaderSingleTap:(NSInteger)section tag:(NSInteger)tag {
    // セクションヘッダーのシングルタップ時の実行処理
    CategoryData *categoryData = [_currentPage getCategoryListByTag:tag][section];
    UITableView *tableView = (UITableView *)[_scrollView viewWithTag:tag];

    [tableView beginUpdates];

    if (categoryData.isOpenSection) {
        categoryData.isOpenSection = NO;
        [self closeSectionContents:section TableView:tableView CategoryData:categoryData];
    } else {
        categoryData.isOpenSection = YES;
        [self openSectionContents:section TableView:tableView CategoryData:categoryData];
    }

    [tableView endUpdates];
}

//--------------------------------------------------------------//
#pragma mark -- PageTabViewDelegate --
//--------------------------------------------------------------//

- (void)didPageTabSingleTap:(PageData *)selectPage pageTabView:(PageTabView *)tappedPageTabView {
    // PageTabのシングルタップ時の実行処理

    // pageを入れ替え、tableのリロード
    _currentPage = selectPage;
    [self reloadTableData];

    // switch PageTabView
    [tappedPageTabView switchTabStatus];
    [_currentPageTabView switchTabStatus];
    _currentPageTabView = tappedPageTabView;

    // set TabFrameView
    _tabFrameView.backgroundColor = [[selectPage color] getColorWithNumber:3];
}

//--------------------------------------------------------------//
#pragma mark -- Private Method --
//--------------------------------------------------------------//

-(void)reloadTableData {
    // Tableデータの再読み込み
    for (int i = 1; i < LastAngle; ++i) {
        UITableView *tableView = (UITableView *)[_scrollView viewWithTag:i];
        [tableView reloadData];
    }
}

- (void)openSectionContents:(NSInteger)section TableView:(UITableView *)tableView CategoryData:(CategoryData *)categoryData {
    // 指定セクション配下のコンテンツを開く
    NSArray *bookmarkList = [categoryData getBookmarkList];
    NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithCapacity:bookmarkList.count];
    for (int i = 0; i < bookmarkList.count; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }
    [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

- (void)closeSectionContents:(NSInteger)section TableView:(UITableView *)tableView CategoryData:(CategoryData *)categoryData {
    // 指定セクション配下のコンテンツを閉じる
    NSArray *bookmarkList = [categoryData getBookmarkList];
    NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithCapacity:bookmarkList.count];
    for (int i = 0; i < bookmarkList.count; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

- (void)setupBackgroundImage {
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

- (void)createPageTabViews {
    // PageTabViewを生成する
    DataManager *dataManager = [DataManager sharedManager];

    // set PageTabView
    float x = 0;
    for (PageData *pageData in [dataManager.pageDict objectEnumerator]) {
        CGSize textSize = [pageData.name sizeWithFont:[UIFont fontWithName:kDefaultFont size:kFontSizeOfPageTab]
                                    constrainedToSize:CGSizeMake(200, 2000)
                                        lineBreakMode:NSLineBreakByWordWrapping];

        CGRect rect = CGRectMake(x, 0, textSize.width + kAdaptWidthOfPageTab, kHeightOfPageTab);
        PageTabView *pageTabView = [[PageTabView alloc] initWithFrame:(CGRect)rect];
        [pageTabView setUpWithPage:pageData];
        pageTabView.delegate = self;
        if ((int)pageData.dataId == (int)_currentPage.dataId) {
            _currentPageTabView = pageTabView;
            [pageTabView switchTabStatus];
        }
        [_tabScrollView addSubview:pageTabView];
        x += pageTabView.bounds.size.width + 1;
    }
    CGSize cgSize = CGSizeMake(x, kHeightOfPageTab);
    _tabScrollView.contentSize = cgSize;

    // set TabFrameView
    _tabFrameView.backgroundColor = [[_currentPage color] getColorWithNumber:3];
}

@end
