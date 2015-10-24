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
#import "SectionHeaderView.h"
#import "SettingTableViewCell.h"
#import "UserData.h"
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
    UIView *bgView = [[UIView alloc] initWithFrame:self.view.frame];
    [Helper setupBackgroundImage:bgView];
    self.tableView.backgroundView = bgView;

    // NavigationBar設定
    [_navigationBar setup];
    [_navigationBar setButtonInSwapScene];
    _navigationBar.topItem.title = @"Move Category";
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

    // cell情報の差し替え
    [_categoryListOfAngle[fromAngleId] removeObjectAtIndex:fromIndexPath.row];
    [_categoryListOfAngle[toAngleId] insertObject:category atIndex:toIndexPath.row];

    // データの更新
    UserData *user = [[DataManager sharedManager] getUser];
    if ([user.pageId isEqualToString:kDefaultPageDataId]){
        // デフォルトのPage(ALL)の場合
        [self _updateCategoryDataBySwap:_categoryListOfAngle];
        [[DataManager sharedManager] save:SAVE_CATEGORY];
    } else {
        // 作成したPageの場合
        [_page updatePageDataBySwap:_categoryListOfAngle];
        // データの同期登録、保存
        [[DataManager sharedManager] updateSyncData:_page DataType:SAVE_PAGE Action:@"update"];
        [[DataManager sharedManager] save:SAVE_PAGE];
    }
}

- (void)_updateCategoryDataBySwap:(NSMutableDictionary *)categoryListOfAngle {
    LOG(@"== updateCategoryDataBySwap(befor) ==\n%@\n", categoryListOfAngle);
    // ALLページのカテゴリの入れ替えのための情報更新
    for (int i = 1; i < LastAngle; ++i) {
        NSNumber *angleId = [Helper getNumberByInt:i];
        NSMutableArray *categoryArray = categoryListOfAngle[angleId];
        for (int idx = 0; idx < categoryArray.count; ++idx) {
            CategoryData *category = categoryArray[idx];
            category.sort = idx + 1;
            category.angle = [angleId intValue];
            // 同期対象に追加
            [[DataManager sharedManager] updateSyncData:category DataType:SAVE_CATEGORY Action:@"update"];
        }
    }
    LOG(@"== updateCategoryDataBySwap(after) ==\n%@\n", categoryListOfAngle);
}

//--------------------------------------------------------------//
#pragma mark -- UITableViewDelegate --
//--------------------------------------------------------------//

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    // 編集モード時のインデントを無効にする
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // セルの高さ
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    // セクションヘッダーの高さを返す
    return kHeightOfSectionHeader;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    // セクションヘッダーのコンテンツを設定する
    NSString *sectionName = [self _getSectionName:section];
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, kHeightOfSectionHeader);
    SectionHeaderView *sectionView = [[SectionHeaderView alloc] initWithFrame:frame];
    [sectionView setup:sectionName FontSize:kFontSizeOfSectionTitle];
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
