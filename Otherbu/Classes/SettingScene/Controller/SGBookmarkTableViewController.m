//
//  SGBookmarkTableViewController.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "SGBookmarkTableViewController.h"
#import "DescHeaderView.h"
#import "BookmarkData.h"
#import "CategoryData.h"

@interface SGBookmarkTableViewController ()

@end

@implementation SGBookmarkTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _category.name;
    self.editing = YES;

    // 説明Headerを追加
    DescHeaderView *descHeaderView = [[DescHeaderView alloc] init];
    CGSize size = CGSizeMake(self.view.frame.size.width - (kOffsetXOfTableCell * 2), kHeightOfSettingDesc + kMarginOfSettingDesc);
    [descHeaderView setupWithCGSize:size descMessage:@"Bookmarkの並び替え、削除ができます"];
    [self.tableView setTableHeaderView:descHeaderView];
}

//--------------------------------------------------------------//
#pragma mark -- UITableViewDataSource --
//--------------------------------------------------------------//

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _bookmarkList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];

    BookmarkData *bookmark = (BookmarkData *)_bookmarkList[indexPath.row];
    cell.textLabel.text = bookmark.name;
    cell.imageView.image = [UIImage imageNamed:kBookmarkIcon];
    return cell;
}

- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
     forRowAtIndexPath:(NSIndexPath *)indexPath {

    // 削除時
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // MasterDataからBookmarkデータを削除
        _bookmarkList = [[DataManager sharedManager] deleteBookmarkData:_bookmarkList DeleteIndex:indexPath.row];

        [[DataManager sharedManager] save:SAVE_BOOKMARK];

        // CellからPageデータを削除
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    // 表示順(sort)の編集
    // BookmarkDataのsortを更新を行っている
    if (toIndexPath.row < _bookmarkList.count) {
        BookmarkData *bookmark = [_bookmarkList objectAtIndex:fromIndexPath.row];
        [_bookmarkList removeObjectAtIndex:fromIndexPath.row];
        [_bookmarkList insertObject:bookmark atIndex:toIndexPath.row];

        for (int i=0 ; i < _bookmarkList.count; i++) {
            BookmarkData *bookmark = _bookmarkList[i];
            bookmark.sort = i;
        }

        [[DataManager sharedManager] save:SAVE_BOOKMARK];
    }
}

@end
