//
//  ViewController.m
//  Otherbu
//
//  Created by fujimisakari on 2015/02/17.
//  Copyright (c) 2015年 fujimisakari. All rights reserved.
//

#import "ViewController.h"
#import "SectionHeaderView.h"
#import "InnerTableView.h"
#import "TableCellView.h"
#import "DataManager.h"
#import "BookmarkData.h"
#import "CategoryData.h"
#import "ColorData.h"
#import "PageData.h"

@interface ViewController ()

@end

@implementation ViewController {
    NSNumber *_pageId;
    NSInteger _viewWidth;
    NSInteger _viewHeight;
}

static const NSInteger NumberOfPages = 3;

- (void)viewDidLoad {
    [super viewDidLoad];

    // ステータスバーを文字を白にする
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    _pageId = [[NSNumber alloc] initWithInt:16];  // とりあえず、仮でPageId:16をセット

    [self refreshBookmarks:self];

    // setup view init
    _viewWidth = self.view.frame.size.width;
    _viewHeight = self.view.frame.size.height - _scrollView.frame.origin.y;

    // setup PageControl
    _pageControl.numberOfPages = NumberOfPages;  // ページ数を設定
    _pageControl.currentPage = 0;                // 現在のページを設定

    // setup NavigationBar
    _navigationBar.topItem.title = @"Otherbu";  // タイトル設定
    // カラーフォント設定
    NSDictionary *attributes =
        @{NSFontAttributeName : [UIFont fontWithName:@"Futura-Medium" size:18], NSForegroundColorAttributeName : [UIColor whiteColor], };
    [_navigationBar setTitleTextAttributes:attributes];
    // 位置設定
    CGFloat verticalOffset = -7;
    [_navigationBar setTitleVerticalPositionAdjustment:verticalOffset forBarMetrics:UIBarMetricsDefault];

    // setup ScrollView
    _scrollView.delegate = self;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    // 横にページスクロールできるようにコンテンツの大きさを横長に設定
    _scrollView.contentSize = CGSizeMake(_viewWidth * NumberOfPages, _viewHeight);
    _scrollView.pagingEnabled = YES;                  // ページごとのスクロールにする
    _scrollView.showsHorizontalScrollIndicator = NO;  // 横スクロールバーを非表示にする
    _scrollView.showsVerticalScrollIndicator = NO;    // 縦スクロールバーを非表示にする
    _scrollView.scrollsToTop = NO;  // ステータスバータップでトップにスクロールする機能をOFFにする

    // setup BackgroundImage
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0.0);
    [[UIImage imageNamed:@"wood-wallpeper.jpg"] drawInRect:self.view.bounds];
    UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CALayer *layer = [CALayer layer];
    layer.contents = (id)backgroundImage.CGImage;
    layer.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + _navigationBar.frame.size.height,
                             self.view.frame.size.width, self.view.frame.size.height);
    layer.zPosition = -1.0;
    [self.view.layer addSublayer:layer];

    // setup innerTableView
    for (int i = 1; i < LastAngle; ++i) {
        CGRect rect = CGRectMake(_viewWidth * (i - 1), _scrollView.bounds.origin.y, _viewWidth, _viewHeight);
        InnerTableView *innerTableView = [InnerTableView initWithTag:i frame:rect];
        [innerTableView setUpWithViewController:self];
        [_scrollView addSubview:innerTableView];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    // テーブルビューの最後の位置を保持
    // _lastScrollOffset = [_myTableView contentOffset];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // テーブルビューのセルが選択されていた場合に選択を解除する
    // NSIndexPath *selection = [_myTableView indexPathForSelectedRow];
    // if (selection) {
    //     [_myTableView deselectRowAtIndexPath:selection animated:YES];
    // }
    // [_myTableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    // // テーブルビューを最後に保存した位置までスクロールする
    // [_myTableView setContentOffset:_lastScrollOffset];

    // // テーブルビューが更新された時にスクロールバーが点滅するよう指定
    // [_myTableView flashScrollIndicators];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _scrollView) {
        CGPoint currentPoint = [scrollView contentOffset];
        [scrollView setContentOffset:CGPointMake(currentPoint.x, 0.0)];

         // UIScrollViewのページ切替時イベント:UIPageControlの現在ページを切り替える処理
         _pageControl.currentPage = _scrollView.contentOffset.x / _viewWidth;
    }
}

- (void)refreshBookmarks:(id)sender {
    // [self.refreshControl beginRefreshing];

    [[DataManager sharedManager] reloadDataWithBlock:^(NSError *error) {
        if (error) {
            NSLog(@"error = %@", error);
        }

        for (int i = 1; i < LastAngle; ++i) {
            UITableView *tableView = (UITableView *)[_scrollView viewWithTag:i];
            [tableView reloadData];
        }
        // [self.refreshControl endRefreshing];
    }];
}

#pragma mark - Table View
/**
 * テーブル全体のセクションの数を返す
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    PageData *page = [[DataManager sharedManager] getPage:_pageId];
    if (page) {
        NSArray *categoryList = [page getCategoryListByTag:tableView.tag];
        return categoryList.count;
    } else {
        return 0;
    }
}

/**
 * 指定されたセクションのセクション名を返す
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    PageData *page = [[DataManager sharedManager] getPage:_pageId];
    if (page) {
        CategoryData *categoryData = [page getCategoryListByTag:tableView.tag][section];
        return categoryData.name;
    } else {
        return @"";
    }
}

/**
 * 指定されたセクションの項目数を返す
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    PageData *page = [[DataManager sharedManager] getPage:_pageId];
    if (page) {
        CategoryData *categoryData = [page getCategoryListByTag:tableView.tag][section];
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

    PageData *page = [[DataManager sharedManager] getPage:_pageId];
    if (page) {
        cell = [cell setUpWithPageData:page tableView:tableView indexPath:indexPath];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

/**
 セクションヘッダーの高さを返す
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}

/**
 セクションヘッダーのコンテンツを設定する
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PageData *page = [[DataManager sharedManager] getPage:_pageId];
    if (page) {
        CategoryData *categoryData = [page getCategoryListByTag:tableView.tag][section];
        CGRect frame = CGRectMake(0, 0, tableView.frame.size.width, 40); // todo 40はなんとかする
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
    // 今回は何もしない
}

#pragma mark - CustomSectionHeaderViewDelegate

/**
 シングルタップ時に実行される処理

 @param section セクションのインデックス
 @param tag TableViewのタグ名
 */
- (void)didSectionHeaderSingleTap:(NSInteger)section tag:(NSInteger)tag {
    PageData *page = [[DataManager sharedManager] getPage:_pageId];
    CategoryData *categoryData = [page getCategoryListByTag:tag][section];
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

#pragma mark - Private Methods
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

@end
