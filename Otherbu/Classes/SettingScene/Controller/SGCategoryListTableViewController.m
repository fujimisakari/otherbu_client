//
//  SGCategoryListTableViewController.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "SGCategoryListTableViewController.h"
#import "DescHeaderView.h"
#import "PageData.h"
#import "CategoryData.h"

@interface SGCategoryListTableViewController () {
    NSMutableArray *_categoryList;
    NSIndexPath *_deleteIndexPath;
    UIAlertView *_confirmAlert;
}

@end

@implementation SGCategoryListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 説明Headerを追加
    DescHeaderView *descHeaderView = [[DescHeaderView alloc] init];
    CGSize size = CGSizeMake(self.view.frame.size.width - (kOffsetXOfTableCell * 2), kHeightOfSettingDesc + kMarginOfSettingDesc);
    [descHeaderView setupWithCGSize:size descMessage:@"Categoryの削除ができます"];
    [self.tableView setTableHeaderView:descHeaderView];

    self.editing = YES;
    _categoryList = [[DataManager sharedManager] getCategoryList];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // 削除確認Viewの生成
    [self _createConfirmAlertView];
}

- (void)_createConfirmAlertView {
    _confirmAlert = [[UIAlertView alloc] init];
    _confirmAlert.delegate = self;
    _confirmAlert.title = @"Categoryの削除";
    [_confirmAlert addButtonWithTitle:@"Cancel"];
    [_confirmAlert addButtonWithTitle:@"OK"];
    _confirmAlert.cancelButtonIndex = 0;
}

//--------------------------------------------------------------//
#pragma mark -- UITableViewDataSource --
//--------------------------------------------------------------//

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _categoryList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];

    CategoryData *category = (CategoryData *)_categoryList[indexPath.row];
    cell.textLabel.text = category.name;
    cell.imageView.image = [UIImage imageNamed:kCategoryIcon];
    return cell;
}

- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
     forRowAtIndexPath:(NSIndexPath *)indexPath {

    // 削除時
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        _deleteIndexPath = indexPath;
        CategoryData *category = _categoryList[indexPath.row];
        _confirmAlert.message = [NSString stringWithFormat:@"%@に設定されているBookmarkも削除されますがよろしいですか？", category.name];
        [_confirmAlert show];
    }
}

//--------------------------------------------------------------//
#pragma mark -- UIAlertViewDelegate --
//--------------------------------------------------------------//

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // 削除確認Viewのボタンタップした場合
    if (buttonIndex != alertView.cancelButtonIndex) {

        CategoryData *deleteCategory = _categoryList[_deleteIndexPath.row];

        // カテゴリに設定されているブックマークデータを削除
        NSArray *deleteBookmarkList = [deleteCategory getBookmarkList];
        [[DataManager sharedManager] bulkDeleteBookmarkData:deleteBookmarkList];
        // データ保存、同期対象に追加
        for (id<DataInterface> bookmark in deleteBookmarkList) {
            [[DataManager sharedManager] updateSyncData:bookmark DataType:SAVE_BOOKMARK Action:@"delete"];
        }
        [[DataManager sharedManager] save:SAVE_BOOKMARK];

        // ページデータの更新
        for (PageData *page in [[DataManager sharedManager] getPageList]) {
            [page updatePageData:deleteCategory isCheckMark:NO];
            [[DataManager sharedManager] updateSyncData:page DataType:SAVE_PAGE Action:@"update"];
        }
        [[DataManager sharedManager] save:SAVE_PAGE];

        // カテゴリの削除
        [[DataManager sharedManager] deleteCategoryData:deleteCategory];
        [_categoryList removeObjectAtIndex:_deleteIndexPath.row];
        [[DataManager sharedManager] updateSyncData:deleteCategory DataType:SAVE_CATEGORY Action:@"delete"];
        [[DataManager sharedManager] save:SAVE_CATEGORY];

        // cellから削除
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[_deleteIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
}

@end
