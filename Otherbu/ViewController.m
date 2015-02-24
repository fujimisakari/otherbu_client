//
//  ViewController.m
//  Otherbu
//
//  Created by fujimisakari on 2015/02/17.
//  Copyright (c) 2015年 fujimisakari. All rights reserved.
//

#import "ViewController.h"
#import "InnerTableView.h"
#import "DataManager.h"
#import "OtherbuAPIClient.h"
#import "PageData.h"
#import "CustomSectionHeaderView.h"

@interface ViewController ()

@end

@implementation ViewController {
    NSNumber *pageId;
}

static const NSInteger kNumberOfPages = 3;
static const NSInteger kViewWidth = 375;
static const NSInteger kViewHeight = 460;

- (void)viewDidLoad {
    [super viewDidLoad];

    pageId = [[NSNumber alloc] initWithInt:16];

    [self refreshBookmarks:self];

    // setup PageControl
    _pageControl.backgroundColor = [UIColor blackColor];  // 背景色を設定
    _pageControl.numberOfPages = kNumberOfPages;          // ページ数を設定
    _pageControl.currentPage = 0;                         // 現在のページを設定

    // setup ScrollView
    _scrollView.delegate = self;
    _scrollView.frame = self.view.bounds;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    // 横にページスクロールできるようにコンテンツの大きさを横長に設定
    _scrollView.contentSize = CGSizeMake(kViewWidth * kNumberOfPages, kViewHeight);
    _scrollView.pagingEnabled = YES;                  // ページごとのスクロールにする
    _scrollView.showsHorizontalScrollIndicator = NO;  // 横スクロールバーを非表示にする
    _scrollView.showsVerticalScrollIndicator = NO;    // 縦スクロールバーを非表示にする
    _scrollView.scrollsToTop = NO;  // ステータスバータップでトップにスクロールする機能をOFFにする

    // setup innerTableView
    for (int i = 1; i < LastAngle; ++i) {
        InnerTableView *innerTableView = [InnerTableView initInnerTableViewWithNumber:i];
        innerTableView.frame = CGRectMake(kViewWidth * (i - 1), 0, kViewWidth, kViewHeight);
        innerTableView.tag = i;
        innerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        innerTableView.delegate = self;
        innerTableView.dataSource = self;
        [_scrollView addSubview:innerTableView];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // UIScrollViewのページ切替時イベント:UIPageControlの現在ページを切り替える処理
    _pageControl.currentPage = _scrollView.contentOffset.x / kViewWidth;
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
    PageData *page = [[DataManager sharedManager] getPage:pageId];
    if (page) {
        NSMutableDictionary *categoryListOfAngle = [page getCategoryListOfAngle];
        NSNumber *angleNumber = [[NSNumber alloc] initWithInt:(int)tableView.tag];
        NSArray *categoryList = categoryListOfAngle[angleNumber];
        return categoryList.count;
    } else {
        return 0;
    }
}

/**
 * 指定されたセクションのセクション名を返す
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    PageData *page = [[DataManager sharedManager] getPage:pageId];
    if (page) {
        NSMutableDictionary *categoryListOfAngle = [page getCategoryListOfAngle];
        NSNumber *angleNumber = [[NSNumber alloc] initWithInt:(int)tableView.tag];
        CategoryData *categoryData = categoryListOfAngle[angleNumber][section];
        return categoryData.name;
    } else {
        return @"";
    }
}

/**
 * 指定されたセクションの項目数を返す
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    PageData *page = [[DataManager sharedManager] getPage:pageId];
    if (page) {
        NSMutableDictionary *categoryListOfAngle = [page getCategoryListOfAngle];
        NSNumber *angleNumber = [[NSNumber alloc] initWithInt:(int)tableView.tag];
        CategoryData *categoryData = categoryListOfAngle[angleNumber][section];
        NSArray *bookmarkList = [categoryData getBookmarkList];
        // return bookmarkList.count;

        // セクションが閉じている場合は0を返す
        return categoryData.tagOpen ? bookmarkList.count : 0;
    } else {
        return 0;
    }
}

/**
 * 指定された箇所のセルを作成する
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    PageData *page = [[DataManager sharedManager] getPage:pageId];
    if (page) {
        NSMutableDictionary *categoryListOfAngle = [page getCategoryListOfAngle];
        NSNumber *angleNumber = [[NSNumber alloc] initWithInt:(int)tableView.tag];
        CategoryData *categoryData = categoryListOfAngle[angleNumber][indexPath.section];
        NSArray *bookmarkList = [categoryData getBookmarkList];
        BookmarkData *bookmark = bookmarkList[indexPath.row];
        cell.textLabel.text = bookmark.name;
        cell.detailTextLabel.text = bookmark.url;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

/**
 セクションヘッダーの高さを返す
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    // if (self.isHideSection) {
    //     return 0.0f;
    // }
    return 40.0f;
}

/**
 セクションヘッダーのコンテンツを設定する
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // if (self.isHideSection) {
    //     return nil;
    // }
    PageData *page = [[DataManager sharedManager] getPage:pageId];
    if (page) {
        NSMutableDictionary *categoryListOfAngle = [page getCategoryListOfAngle];
        NSNumber *angleNumber = [[NSNumber alloc] initWithInt:(int)tableView.tag];
        CategoryData *categoryData = categoryListOfAngle[angleNumber][section];

        CustomSectionHeaderView *containerView = [[CustomSectionHeaderView alloc] initWithCategory:categoryData section:section angle:angleNumber tag:tableView.tag];
;
        containerView.delegate = self;
        return containerView;
    } else {
        return nil;
    }
}

/**
 セルタップ時に実行される処理
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 今回は何もしない
}

#pragma mark - CustomSectionHeaderViewDelegate

/**
 シングルタップ時に実行される処理
 
 @param sectionIndex セクションのインデックス
 @param isOpen セクションの開閉状態
 */
- (void)didSectionHeaderSingleTap:(NSInteger)section angle:(NSNumber *)angleNumber tag:(NSInteger)tag {
    PageData *page = [[DataManager sharedManager] getPage:pageId];
    NSMutableDictionary *categoryListOfAngle = [page getCategoryListOfAngle];
    CategoryData *categoryData = categoryListOfAngle[angleNumber][section];
    // if (categoryData.tagOpen) {
    //     categoryData.tagOpen = 0;
    // } else {
    //     categoryData.tagOpen = 1;
    // }

    UITableView *tableView = (UITableView *)[_scrollView viewWithTag:tag];

    [tableView beginUpdates];

    if (categoryData.tagOpen) {
        [self openSectionContents:section TableView:tableView CategoryData:categoryData];
    } else {
        [self closeSectionContents:section TableView:tableView CategoryData:categoryData];
    }

    [tableView endUpdates];
}

#pragma mark - Private Methods
/**
 指定セクション配下のコンテンツを開く

 @param sectionIndex セクションのインデックス
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

 @param sectionIndex セクションのインデックス
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
