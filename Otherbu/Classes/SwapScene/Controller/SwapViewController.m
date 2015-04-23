//
//  SwapTableViewController.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "SwapViewController.h"
#import "NavigationBar.h"
#import "CategoryData.h"
#import "SwapSectionHeaderView.h"
#import "SettingTableViewCell.h"
#import "PageData.h"

@interface SwapViewController () {
    NSMutableDictionary *_categoryListOfAngle;
}

@end

@implementation SwapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _tableView.editing = YES;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[SettingTableViewCell class] forCellReuseIdentifier:kCellIdentifier];

    // UITableViewの一番上に隙間が出来てしまう問題の対応
    [_tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.1, 20)]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    _categoryListOfAngle = [_page getCategoryListOfAngle];

    // セルの区切り線を非表示
    self.tableView.separatorColor = [UIColor clearColor];

    // 背景画像設定
    CGRect rect = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    UIView *bgView = [[UIView alloc] initWithFrame:self.view.frame];
    [Helper setupBackgroundImage:rect TargetView:bgView];
    self.tableView.backgroundView = bgView;

    // NavigationBar設定
    [_navigationBar setup];
    [_navigationBar setButtonInSwapScene];
    _navigationBar.topItem.leftBarButtonItem.target = self;
    _navigationBar.topItem.rightBarButtonItem.action = @selector(_closeSwapView:);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_navigationBar deleteButtonInSwapScene];
}

//--------------------------------------------------------------//
#pragma mark -- UITableViewDataSource --
//--------------------------------------------------------------//

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _categoryListOfAngle.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSNumber *angleId = [Helper getNumberByInt:(int)section + 1];
    NSMutableArray *categoryList = _categoryListOfAngle[angleId];
    return categoryList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    [cell setup];

    NSNumber *angleId = [Helper getNumberByInt:(int)indexPath.section + 1];
    NSMutableArray *categoryList = _categoryListOfAngle[angleId];
    CategoryData *categoryData = categoryList[indexPath.row];
    cell.textLabel.text = categoryData.name;
    cell.imageView.image = [UIImage imageNamed:kCategoryIcon];
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
    [settingCell createMoveIconImage];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    // 表示順(Page)の編集
    NSNumber *fromAngleId = [Helper getNumberByInt:(int)fromIndexPath.section + 1];
    NSNumber *toAngleId = [Helper getNumberByInt:(int)toIndexPath.section + 1];
    CategoryData *category = [_categoryListOfAngle[fromAngleId] objectAtIndex:fromIndexPath.row];
    [_categoryListOfAngle[fromAngleId] removeObjectAtIndex:fromIndexPath.row];
    [_categoryListOfAngle[toAngleId] insertObject:category atIndex:toIndexPath.row];
    [_page updatePageDataBySwap:_categoryListOfAngle];
}

//--------------------------------------------------------------//
#pragma mark -- UITableViewDelegate --
//--------------------------------------------------------------//

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    // セクションヘッダーの高さを返す
    return kHeightOfSectionHeader;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    // セクションヘッダーのコンテンツを設定する
    NSString *sectionName = [self _getSectionName:section];
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, kHeightOfSectionHeader);
    SwapSectionHeaderView *sectionView = [[SwapSectionHeaderView alloc] initWithFrame:frame];
    [sectionView setup:sectionName];
    return sectionView;
}

- (NSString *)_getSectionName:(NSInteger)section {
    // 指定されたセクションのセクション名を返す
    int idx = (int)section + 1;
    NSString *sectionName;
    switch (idx) {
        case LEFT:
            sectionName = @"LEFT";
            break;
        case CENTER:
            sectionName = @"CENTER";
            break;
        case RIGHT:
            sectionName = @"RIGHT";
            break;
    }
    return sectionName;
}

//--------------------------------------------------------------//
#pragma mark-- Navi Button Event--
//--------------------------------------------------------------//

- (void)_closeSwapView:(UIButton *)sender {
    // 画面を閉じるを閉じる
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
