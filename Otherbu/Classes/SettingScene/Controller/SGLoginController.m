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
#import "AuthTypeData.h"
#import "SettingAlertView.h"

@interface SGLoginController () {
    NSArray *_authTypeList;
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

    _authTypeList = [[DataManager sharedManager] getAuthTypeList];
    self.navigationItem.title = [NSString stringWithFormat:@"%@%@", kMenuLoginName, @"設定"];
}

//--------------------------------------------------------------//
#pragma mark -- UITableViewDataSource --
//--------------------------------------------------------------//

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _authTypeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // セルの生成
    AuthTypeData *authType = (AuthTypeData *)_authTypeList[indexPath.row];
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = authType.name;
    cell.imageView.image = [UIImage imageNamed:authType.iconName];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // セルタップ時のLogin手続き
    AuthTypeData *authType = (AuthTypeData *)_authTypeList[indexPath.row];
    [SNSProcess login:self.navigationController
                 View:self.view
             TypeName:authType.name
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
