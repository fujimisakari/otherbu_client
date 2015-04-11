//
//  PageListTableViewController.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "PageListTableViewController.h"
#import "EditPageTableViewController.h"
#import "PageData.h"

@interface PageListTableViewController () {
    NSMutableArray *_pageList;
    PageData *_selectPage;
}

@end

@implementation PageListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageList = [[DataManager sharedManager] getPageList];
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
        // MasterDataからPageデータを削除
        _pageList = [[DataManager sharedManager] deletePageData:_pageList DeleteIndex:indexPath.row];

        // CellからPageデータを削除
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
        }
    }
}

//--------------------------------------------------------------//
#pragma mark -- segue --
//--------------------------------------------------------------//

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:kToEditPageBySegue]) {
        EditPageTableViewController *pageDetailTableViewController = (EditPageTableViewController *)[segue destinationViewController];
        [pageDetailTableViewController setPage:_selectPage];
    }
}

@end
