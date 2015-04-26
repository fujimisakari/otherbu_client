//
//  ModalPageViewController.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "ModalPageViewController.h"
#import "NavigationBar.h"
#import "DescHeaderView.h"
#import "CategoryData.h"
#import "SettingTableViewCell.h"
#import "PageData.h"

@interface ModalPageViewController () {
    NSArray *_categoryList;
    NSArray *_categoryListOfPage;
}

@end

@implementation ModalPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _tableView.delegate = self;
    _tableView.dataSource = self;

    [_tableView registerClass:[SettingTableViewCell class] forCellReuseIdentifier:kCellIdentifier];

    // 説明Headerを追加
    DescHeaderView *descHeaderView = [[DescHeaderView alloc] init];
    CGSize size = CGSizeMake(self.view.frame.size.width - (kOffsetXOfTableCell * 2), kHeightOfSettingDesc + kMarginOfSettingDesc);
    [descHeaderView setupWithCGSize:size descMessage:@"Pageに入れるCategoryの選択ができます"];
    [self.tableView setTableHeaderView:descHeaderView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    _categoryList = [[DataManager sharedManager] getCategoryList];
    _categoryListOfPage = [_page getCategoryList];

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
    _navigationBar.topItem.title = @"Edit Page";
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _categoryList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // セルの生成。ページに設定しているカテゴリはチェックマーク画像が表示させる
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    [cell setup];

    CategoryData *category = (CategoryData *)_categoryList[indexPath.row];
    NSUInteger isExistCategory = [_categoryListOfPage indexOfObject:category];
    if (isExistCategory == NSNotFound) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    cell.textLabel.text = category.name;
    cell.imageView.image = [UIImage imageNamed:kCategoryIcon];
    return cell;
}

//--------------------------------------------------------------//
#pragma mark -- UITableViewDelegate --
//--------------------------------------------------------------//

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
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // セルタップ時にPageDataの情報を更新する
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    CategoryData *category = (CategoryData *)_categoryList[indexPath.row];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [_page updatePageData:(CategoryData *)category isCheckMark:NO];
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [_page updatePageData:(CategoryData *)category isCheckMark:YES];
    }
    _categoryListOfPage = [_page getCategoryList];
}

//--------------------------------------------------------------//
#pragma mark-- Navi Button Event--
//--------------------------------------------------------------//

- (void)_closeSwapView:(UIButton *)sender {
    // 画面を閉じるを閉じる
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.delegate closeModalView];
}

@end
