//
//  SettingBaseTableViewController.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "SettingBaseTableViewController.h"
#import "SettingTableViewCell.h"

@interface SettingBaseTableViewController ()

@end

@implementation SettingBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[SettingTableViewCell class] forCellReuseIdentifier:kCellIdentifier];

    // セルの区切り線を非表示
    self.tableView.separatorColor = [UIColor clearColor];

    // 背景画像を設定
    float height = self.navigationController.navigationBar.frame.size.height + 20;  // 20はステータスバーの高さ
    CGRect rect = CGRectMake(self.tableView.frame.origin.x,   self.tableView.frame.origin.y + height,
                             self.tableView.frame.size.width, self.tableView.frame.size.height);
    UIView *bgView = [[UIView alloc] initWithFrame:self.tableView.frame];
    [Helper setupBackgroundImage:rect TargetView:bgView];
    self.tableView.backgroundView = bgView;
}

//--------------------------------------------------------------//
#pragma mark -- UITableViewDataSource --
//--------------------------------------------------------------//

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    [cell setup];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeightOfSetting;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 半透明で間隔が空いたセルを生成
    SettingTableViewCell *settingCell = (SettingTableViewCell *)cell;
    float width = self.view.frame.size.width - (kCellMarginOfSetting * 2);
    float height = kCellHeightOfSetting - kCellMarginOfSetting;
    CGRect rect = CGRectMake(kCellMarginOfSetting, kCellMarginOfSetting, width, height);
    [settingCell setBackground:rect];
}

@end
