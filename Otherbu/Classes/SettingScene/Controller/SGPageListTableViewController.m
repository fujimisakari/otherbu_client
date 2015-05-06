//
//  SGPageListTableViewController.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "SGPageListTableViewController.h"
#import "SGEditPageTableViewController.h"
#import "SettingTableViewCell.h"
#import "DescHeaderView.h"
#import "PageData.h"

@interface SGPageListTableViewController () {
    NSMutableArray *_pageList;
    PageData *_selectPage;
}

@end

@implementation SGPageListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageList = [[DataManager sharedManager] getPageList];

    // 説明Headerを追加
    DescHeaderView *descHeaderView = [[DescHeaderView alloc] init];
    CGSize size = CGSizeMake(self.view.frame.size.width - (kOffsetXOfTableCell * 2), kHeightOfSettingDesc + kMarginOfSettingDesc);
    [descHeaderView setupWithCGSize:size descMessage:@"Pageの並び替え、削除ができます"];
    [self.tableView setTableHeaderView:descHeaderView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//--------------------------------------------------------------//
#pragma mark -- UITableViewDataSource --
//--------------------------------------------------------------//

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _pageList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];

    PageData *page = (PageData *)_pageList[indexPath.row];
    cell.textLabel.text = page.name;
    cell.imageView.image = [UIImage imageNamed:kPageIcon];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PageData *page = (PageData *)_pageList[indexPath.row];
    _selectPage = page;
    [self performSegueWithIdentifier:kToEditPageBySegue sender:self];
}

- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
     forRowAtIndexPath:(NSIndexPath *)indexPath {

    // 削除時
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PageData *deletePage = _pageList[indexPath.row];

        // DataManagerからPageデータを削除
        [[DataManager sharedManager] deletePageData:deletePage];

        // tavbleViewのPageデータから削除
        [_pageList removeObjectAtIndex:indexPath.row];

        // データの同期登録、保存
        [[DataManager sharedManager] updateSyncData:deletePage DataType:SAVE_PAGE Action:@"delete"];
        [[DataManager sharedManager] save:SAVE_PAGE];

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
    // 表示順(sortId)の編集
    // PageDataのsortIdを更新を行っている
    if (toIndexPath.row < _pageList.count) {
        PageData *page = [_pageList objectAtIndex:fromIndexPath.row];
        [_pageList removeObjectAtIndex:fromIndexPath.row];
        [_pageList insertObject:page atIndex:toIndexPath.row];

        for (int i=0 ; i < _pageList.count; i++) {
            PageData *page = _pageList[i];
            page.sortId = i;
            // webにはpage sortは存在しないため同期登録はしなくていい
        }
        [[DataManager sharedManager] save:SAVE_PAGE];
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animate {
    [super setEditing:editing animated:animate];
    if (editing) {
        // Editボタン押下時に移動アイコンを生成する
        for (int i = 0; i < _pageList.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            SettingTableViewCell *settingCell = (SettingTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            [settingCell createMoveIconImage];
        }
    }
}

//--------------------------------------------------------------//
#pragma mark -- segue --
//--------------------------------------------------------------//

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:kToEditPageBySegue]) {
        SGEditPageTableViewController *pageDetailTableViewController = (SGEditPageTableViewController *)[segue destinationViewController];
        pageDetailTableViewController.page = _selectPage;
    }
}

@end
