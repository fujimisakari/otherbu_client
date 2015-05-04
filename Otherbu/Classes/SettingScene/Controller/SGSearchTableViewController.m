//
//  SGSearchTableViewController.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "SGSearchTableViewController.h"

#import "DescHeaderView.h"
#import "UserData.h"
#import "SearchData.h"

@interface SGSearchTableViewController () {
    NSArray *_searchList;
    UITableViewCell *_selectCell;
}

@end

@implementation SGSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 説明Headerを追加
    DescHeaderView *descHeaderView = [[DescHeaderView alloc] init];
    CGSize size = CGSizeMake(self.view.frame.size.width - (kOffsetXOfTableCell * 2), kHeightOfSettingDesc + kMarginOfSettingDesc);
    [descHeaderView setupWithCGSize:size descMessage:@"利用する検索サイトの指定ができます"];
    [self.tableView setTableHeaderView:descHeaderView];

    _searchList = [[DataManager sharedManager] getSearchList];
    self.navigationItem.title = [NSString stringWithFormat:@"%@%@", kMenuSearchName, @"設定"];
}

//--------------------------------------------------------------//
#pragma mark -- UITableViewDataSource --
//--------------------------------------------------------------//

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _searchList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // セルの生成。検索サイトの設定セルにはデフォルトでチェックマーク画像が表示させる
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    SearchData *search = (SearchData *)_searchList[indexPath.row];
    SearchData *currentSearch = [[[DataManager sharedManager] getUser] search];
    if ([search.dataId isEqualToString:currentSearch.dataId]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        _selectCell = cell;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = search.name;
    cell.imageView.image = [UIImage imageNamed:kBlackSearchIcon];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // セルタップ時にSearchDataの情報を更新する
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    SearchData *search = (SearchData *)_searchList[indexPath.row];
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        _selectCell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        _selectCell = cell;
        [[[DataManager sharedManager] getUser] updateSearch:search.dataId];
    }
}

@end
