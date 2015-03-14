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
#import "Constants.h"

@implementation MainViewController {
    NSNumber *_pageId;
    float _viewWidth;
    float _viewHeight;
    UIScrollView *_tabScrollView;
    UIView *_tabFrameView;
    CGPoint _tabScrollViewCenter;
    CGPoint _tabFrameViewCenter;
    CGPoint _scrollViewCenter;
    CGFloat _beginScrollOffsetY;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self refreshBookmarks:self];

    // setup view init
    _viewWidth = self.view.frame.size.width;
    _viewHeight = self.view.frame.size.height - _navigationBar.frame.size.height;
    _pageId = [[NSNumber alloc] initWithInt:16];  // とりあえず、仮でPageId:16をセット

    // setup BackgroundImage
    [self setupBackgroundImage];

    // setup NavigationBar
    [_navigationBar setup];

    // setup ScrollView
    CGSize cgSize = CGSizeMake(_viewWidth * kNumberOfPages, _viewHeight);
    [_scrollView setupWithCGSize:cgSize viewController:self];
     _scrollViewCenter = [_scrollView center];

    // set TabScrollView
    CGRect cgRect = CGRectMake(0, _viewHeight - 44, _viewWidth, 40);
    _tabScrollView = [[UIScrollView alloc] initWithFrame:cgRect];
    _tabScrollView.backgroundColor = [UIColor clearColor];
    _tabScrollViewCenter = [_tabScrollView center];
    _tabScrollView.pagingEnabled = NO;
    _tabScrollView.showsHorizontalScrollIndicator = NO;  // 横スクロールバーを非表示にする
    _tabScrollView.showsVerticalScrollIndicator = NO;    // 縦スクロールバーを非表示にする
    _tabScrollView.scrollsToTop = NO;     // ステータスバータップでトップにスクロールする機能をOFFにする

    [_scrollView addSubview:_tabScrollView];

    // set TabFrameView
    CGRect rect = CGRectMake(0, _viewHeight - 4, _viewWidth, 4);
    _tabFrameView = [[UIView alloc] initWithFrame:(CGRect)rect];
    _tabFrameView.backgroundColor = [UIColor blueColor];
    _tabFrameViewCenter = [_tabFrameView center];
    [_scrollView addSubview:_tabFrameView];
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

- (void)refreshBookmarks:(id)sender {
    // [self.refreshControl beginRefreshing];

    DataManager *dataManager = [DataManager sharedManager];

    [dataManager reloadDataWithBlock:^(NSError *error) {
        if (error) {
            NSLog(@"error = %@", error);
        }

        for (int i = 1; i < LastAngle; ++i) {
            UITableView *tableView = (UITableView *)[_scrollView viewWithTag:i];
            [tableView reloadData];
        }

        // ラベル例文
        int idx = 1;
        float x = 0;
        for (PageData *pageData in [dataManager.pageDict objectEnumerator]) {
            UILabel *label = [[UILabel alloc] init];
            CGSize textSize = [pageData.name
                                sizeWithFont:[UIFont fontWithName:kDefaultFont size:16]
                                constrainedToSize:CGSizeMake(200, 2000)
                                lineBreakMode:UILineBreakModeWordWrap];
            NSLog(@"textSize width %f", textSize.width);
            NSLog(@"textSize height %f", textSize.height);
            label.frame = CGRectMake(x, 0, textSize.width + 100, 40);
            label.backgroundColor = [UIColor yellowColor];
            label.textColor = [UIColor blueColor];
            label.font = [UIFont fontWithName:kDefaultFont size:16];
            label.numberOfLines = 1;
            label.textAlignment = UITextAlignmentCenter;
            label.text = pageData.name;
            // [self addSubview:label];
            [_tabScrollView addSubview:label];
            idx += 10;
            x += label.bounds.size.width + 1;
        }
        NSLog(@"width %f", x);
        CGSize cgSize = CGSizeMake(x, 40);
        CGRect cgRect = CGRectMake(0, _viewHeight - 44, _viewWidth, 40);
        _tabScrollView.frame = cgRect;
        _tabScrollView.contentSize = cgSize;

        // [_tabScrollView addSubview:_tabScrollView];
        // [self.refreshControl endRefreshing];
    }];
}

- (float)adjustWidth:(NSString *)show_word fontSize:(float)fSize labelWidth:(float)lWidth labelHeight:(float)lHeight {
    UIFont *font = [UIFont systemFontOfSize:fSize];
    CGSize size = CGSizeMake(lWidth, lHeight);

    CGRect totalRect = [show_word boundingRectWithSize:size
                                               options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine)
                                            attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName]
                                               context:nil];
    float fitSizeWidth = totalRect.size.width;

    return fitSizeWidth;
}

#pragma mark - UIScrollViewDelegate

//スクロールビューをドラッグし始めた際に一度実行される
// - (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//     // NSLog(@"---- %f", [scrollView contentOffset].y);
//     if (scrollView == _scrollView) {
//         NSLog(@"----hhhhhhhhh------%f-", _scrollView.beginScrollOffsetY);
//     NSLog(@"--llllllll--");
//     _beginScrollOffsetY = scrollView.frame.origin.y;
//     } else {
//     NSLog(@"--ccccccccc--");
//     }
//     NSLog(@"----------%f-", scrollView.frame.origin.y);
// }

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _scrollView) {
        float tabViewMax = _tabScrollView.frame.origin.y + _tabScrollView.frame.size.height;
        NSLog(@"------------------------");
        NSLog(@"%f", _tabScrollView.frame.origin.y);
        NSLog(@"%f", _scrollView.beginScrollOffsetY);
        NSLog(@"%f", tabViewMax);

        CGPoint currentPoint = [scrollView contentOffset];
        if (_tabScrollView.frame.origin.y <  _scrollView.beginScrollOffsetY && _scrollView.beginScrollOffsetY < tabViewMax) {
            NSLog(@"ewwwwwwwwwwwwwwwwwwwwwww");
            [scrollView setContentOffset:CGPointMake(0, 0)];
            [_tabScrollView setContentOffset:CGPointMake(currentPoint.x, 0.0)];
             // _scrollView.center = CGPointMake(_tabScrollViewCenter.x + currentPoint.x, _tabScrollViewCenter.y);
            // _tabScrollView.center = CGPointMake(_tabScrollViewCenter.x + currentPoint.x, _tabScrollViewCenter.y);
        } else {
            NSLog(@"qqqqqqqqqqqqqq");
            [scrollView setContentOffset:CGPointMake(currentPoint.x, 0.0)];
            [_tabScrollView setContentOffset:CGPointMake(0, 0)];
            _tabScrollView.center = CGPointMake(_tabScrollViewCenter.x + currentPoint.x, _tabScrollViewCenter.y);
            _tabFrameView.center = CGPointMake(_tabFrameViewCenter.x + currentPoint.x, _tabFrameViewCenter.y);
        }

        // UIScrollViewのページ切替時イベント:UIPageControlの現在ページを切り替える処理
        _pageControl.currentPage = _scrollView.contentOffset.x / _viewWidth;
    }
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
        cell = [cell setupWithPageData:page tableView:tableView indexPath:indexPath];
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
    PageData *page = [[DataManager sharedManager] getPage:_pageId];
    if (page) {
        CategoryData *categoryData = [page getCategoryListByTag:tableView.tag][section];
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

@end
