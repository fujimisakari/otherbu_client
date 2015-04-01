//
//  設定 → ページ一覧
//
//  SettingPageListTableViewController.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "SettingPageListTableViewController.h"
#import "SettingEditPageTableViewController.h"
#import "PageData.h"

@interface SettingPageListTableViewController () {
    NSMutableArray *_pageList;
    PageData *_selectPage;
}

@end

@implementation SettingPageListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    _pageList = [[DataManager sharedManager] getPageList];
}

- (void)viewDidAppear:(BOOL)animated {
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//--------------------------------------------------------------//
#pragma mark -- UITableViewDataSource --
//--------------------------------------------------------------//

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _pageList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];

    PageData *page = (PageData *)_pageList[indexPath.row];
    cell.textLabel.text = page.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = [UIImage imageNamed:kPageIcon];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PageData *page = (PageData *)_pageList[indexPath.row];
    _selectPage = page;
    [self performSegueWithIdentifier:kToEditPageBySegue sender:self];
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
        SettingEditPageTableViewController *pageDetailTableViewController = (SettingEditPageTableViewController *)[segue destinationViewController];
        [pageDetailTableViewController setPage:_selectPage];
    }
}

@end
