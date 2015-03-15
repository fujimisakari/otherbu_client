//
//  MainViewController.m
//  Otherbu
//
//  Created by fujimisakari on 2015/02/17.
//  Copyright (c) 2015年 fujimisakari. All rights reserved.
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
    _viewWidth = self.view.frame.size.width;
    _viewHeight = self.view.frame.size.height - _navigationBar.frame.size.height - 44;

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
    // Dispose of any resources that can be recreated.
}

- (void)refreshBookmarks:(id)sender {
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _scrollView) {
        CGPoint currentPoint = [scrollView contentOffset];
        [scrollView setContentOffset:CGPointMake(currentPoint.x, 0.0)];

        // UIScrollViewのページ切替時イベント:UIPageControlの現在ページを切り替える処理
        _pageControl.currentPage = _scrollView.contentOffset.x / _viewWidth;
    }
}

#pragma mark - Table View
/**
 * テーブル全体のセクションの数を返す
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_currentPage) {
        NSArray *categoryList = [_currentPage getCategoryListByTag:tableView.tag];
        return categoryList.count;
    } else {
        return 0;
    }
}

/**
 * 指定されたセクションのセクション名を返す
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (_currentPage) {
        CategoryData *categoryData = [_currentPage getCategoryListByTag:tableView.tag][section];
        return categoryData.name;
    } else {
        return @"";
    }
}

/**
 * 指定されたセクションの項目数を返す
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_currentPage) {
        CategoryData *categoryData = [_currentPage getCategoryListByTag:tableView.tag][section];
        NSArray *bookmarkList = [categoryData getBookmarkList];
        return categoryData.isOpenSection ? bookmarkList.count : 0;
    } else {
        return 0;
    }
}

/**
 * 指定された箇所のセルを作成する
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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

#pragma mark - UITableViewDelegate

/**
 セクションヘッダーの高さを返す
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kHeightOfSectionHeader;
}

/**
 セクションヘッダーのコンテンツを設定する
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
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

/**
 セルタップ時に実行される処理
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // まだ何もしない
}

#pragma mark - SectionHeaderViewDelegate

/**
 シングルタップ時に実行される処理

 @param section セクションのインデックス
 @param tag TableViewのタグ名
 */
- (void)didSectionHeaderSingleTap:(NSInteger)section tag:(NSInteger)tag {
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

#pragma mark - PageTabViewDelegate

- (void)didPageTabSingleTap:(PageData *)selectPage pageTabView:(PageTabView *)tappedPageTabView {
    _currentPage = selectPage;

    [self reloadTableData];

    // switch PageTabView
    [tappedPageTabView switchTabStatus];
    [_currentPageTabView switchTabStatus];
    _currentPageTabView = tappedPageTabView;

    // set TabFrameView
    _tabFrameView.backgroundColor = [[selectPage color] getColorWithNumber:3];
}

#pragma mark - Private Methods

/**
 Tableデータの再読み込み
 */
-(void)reloadTableData {
    for (int i = 1; i < LastAngle; ++i) {
        UITableView *tableView = (UITableView *)[_scrollView viewWithTag:i];
        [tableView reloadData];
    }
}

/**
 指定セクション配下のコンテンツを開く

 @param section セクションのインデックス
 @param tableView TableViewオジェクト
 @param categoryData CategoryDataオジェクト
 */
- (void)openSectionContents:(NSInteger)section TableView:(UITableView *)tableView CategoryData:(CategoryData *)categoryData {
    NSArray *bookmarkList = [categoryData getBookmarkList];
    NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithCapacity:bookmarkList.count];
    for (int i = 0; i < bookmarkList.count; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }
    [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

/**
 指定セクション配下のコンテンツを閉じる

 @param section セクションのインデックス
 @param tableView TableViewオジェクト
 @param categoryData CategoryDataオジェクト
 */
- (void)closeSectionContents:(NSInteger)section TableView:(UITableView *)tableView CategoryData:(CategoryData *)categoryData {
    NSArray *bookmarkList = [categoryData getBookmarkList];
    NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithCapacity:bookmarkList.count];
    for (int i = 0; i < bookmarkList.count; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

/**
 背景を設定する
 */
- (void)setupBackgroundImage {
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

/**
 ページタブViewを生成する
 */
- (void)createPageTabViews {
    DataManager *dataManager = [DataManager sharedManager];

    // set PageTabView
    float x = 0;
    for (PageData *pageData in [dataManager.pageDict objectEnumerator]) {
        CGSize textSize = [pageData.name sizeWithFont:[UIFont fontWithName:kDefaultFont size:16]
                                    constrainedToSize:CGSizeMake(200, 2000)
                                        lineBreakMode:NSLineBreakByWordWrapping];

        CGRect rect = CGRectMake(x, 0, textSize.width + 30, 40);
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
    CGSize cgSize = CGSizeMake(x, 40);
    _tabScrollView.contentSize = cgSize;

    // set TabFrameView
    _tabFrameView.backgroundColor = [[_currentPage color] getColorWithNumber:3];
}

@end
