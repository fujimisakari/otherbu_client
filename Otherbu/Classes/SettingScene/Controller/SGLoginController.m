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
#import "SettingAlertView.h"

@interface SGLoginController () {
    NSArray *_accountTypeList;
    UITableViewCell *_selectCell;
    SettingAlertView *_alertView;
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

    // エラー時のポップアップ
    _alertView = [[SettingAlertView alloc] init];

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
    cell.imageView.image = [UIImage imageNamed:accountType.iconName];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // セルタップ時のLogin手続き
    AccountTypeData *accountType = (AccountTypeData *)_accountTypeList[indexPath.row];
    [SNSProcess login:self.navigationController
             TypeName:accountType.name
             Callback:^(int statusCode, NSError *error) {
               if (error) {
                   LOG(@"\nerror = %@", error);
                   [_alertView setup:statusCode];
                   [_alertView show];
               }
             }
     ];
}

@end
