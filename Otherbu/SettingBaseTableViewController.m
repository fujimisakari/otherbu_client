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

    // todo 意味を調べる
    [self.tableView registerClass:[SettingTableViewCell class] forCellReuseIdentifier:kCellIdentifier];

    // セルの区切り線を非表示
    self.tableView.separatorColor = [UIColor clearColor];

    // 背景画像を設定
    CGRect rect = CGRectMake(self.tableView.frame.origin.x,   self.tableView.frame.origin.y + 64,
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 半透明で間隔が空いたセルを生成
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];

    UIView *whiteRoundedCornerView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 40)];
    whiteRoundedCornerView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6];
    whiteRoundedCornerView.layer.masksToBounds = NO;
    whiteRoundedCornerView.layer.cornerRadius = 3.0;
    whiteRoundedCornerView.layer.shadowOffset = CGSizeMake(-1, 1);
    whiteRoundedCornerView.layer.shadowOpacity = 0.5;
    [cell.contentView addSubview:whiteRoundedCornerView];
    [cell.contentView sendSubviewToBack:whiteRoundedCornerView];
}

@end
