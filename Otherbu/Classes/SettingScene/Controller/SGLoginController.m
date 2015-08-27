//
//  SGLoginController.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "SGLoginController.h"

#import "DescHeaderView.h"
#import "UserData.h"
#import "AccountTypeData.h"

@interface SGLoginController () {
    NSArray *_accountTypeList;
    UITableViewCell *_selectCell;
}

@end

@implementation SGLoginController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 説明Headerを追加
    DescHeaderView *descHeaderView = [[DescHeaderView alloc] init];
    CGSize size = CGSizeMake(self.view.frame.size.width - (kOffsetXOfTableCell * 2), kHeightOfSettingDesc + kMarginOfSettingDesc);
    [descHeaderView setupWithCGSize:size descMessage:@"同期で利用するアカウントを選択ください"];
    [self.tableView setTableHeaderView:descHeaderView];

    _accountTypeList = [[DataManager sharedManager] getAccountTypeList];
    self.navigationItem.title = [NSString stringWithFormat:@"%@%@", kMenuLoginName, @"設定"];
}

//--------------------------------------------------------------//
#pragma mark -- UITableViewDataSource --
//--------------------------------------------------------------//

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _accountTypeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // セルの生成
    AccountTypeData *accountType = (AccountTypeData *)_accountTypeList[indexPath.row];
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = accountType.name;
    cell.imageView.image = [UIImage imageNamed:kLoginIcon];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // セルタップ時にSearchDataの情報を更新する
    // UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    AccountTypeData *accountType = (AccountTypeData *)_accountTypeList[indexPath.row];
    [accountType login];
    // SearchData *search = (SearchData *)_searchList[indexPath.row];
    // if (cell.accessoryType == UITableViewCellAccessoryNone) {
    //     _selectCell.accessoryType = UITableViewCellAccessoryNone;
    //     cell.accessoryType = UITableViewCellAccessoryCheckmark;
    //     _selectCell = cell;
    //     [[[DataManager sharedManager] getUser] updateSearch:search.dataId];
    //     [[DataManager sharedManager] save:SAVE_USER];
    // }
}

@end
