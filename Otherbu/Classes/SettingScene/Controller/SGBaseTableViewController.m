//
//  SGBaseTableViewController.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "SGBaseTableViewController.h"
#import "SettingTableViewCell.h"

@interface SGBaseTableViewController ()

@end

@implementation SGBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[SettingTableViewCell class] forCellReuseIdentifier:kCellIdentifier];}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // セルの区切り線を非表示
    self.tableView.separatorColor = [UIColor clearColor];

    // 背景画像を設定
    [self updateBackgroundView];

    // NavigationBarにXボタンを設置する
    [self _setCloseButton];
}

- (void)updateBackgroundView {
    UIView *bgView = [[UIView alloc] initWithFrame:self.tableView.frame];
    [Helper setupBackgroundImage:bgView];
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
    float height = cell.frame.size.height - kCellMarginOfSetting;
    CGRect rect = CGRectMake(kCellMarginOfSetting, kCellMarginOfSetting, width, height);
    [settingCell setBackground:rect];
    [settingCell createMoveIconImage];
}

//--------------------------------------------------------------//
#pragma mark -- Close Button --
//--------------------------------------------------------------//

- (void)_setCloseButton {
    // NavigationBarにXボタンを設置する
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                         target:self
                                                                         action:@selector(_closeSettingView:)];
    self.navigationItem.rightBarButtonItem = btn;
}

- (void)_closeSettingView:(UIButton *)sender {
    // 設定ページを閉じる
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
