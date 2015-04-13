//
//  SettingTableViewController.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "SettingTableViewController.h"
#import "SettingTableViewCell.h"

@interface SettingTableViewController () {
    NSArray *_menuNameList;
    NSArray *_menuIconList;
    NSArray *_menSegueActionList;
}

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self _setupMenuData];
    [self _closeButtontoLeft];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

//--------------------------------------------------------------//
#pragma mark -- UITableViewDataSource --
//--------------------------------------------------------------//

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _menuNameList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.text = _menuNameList[indexPath.row];
    cell.imageView.image = _menuIconList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 画面遷移
    void (^block)(void) = _menSegueActionList[indexPath.row];
    block();
}

//--------------------------------------------------------------//
#pragma mark -- Close Button --
//--------------------------------------------------------------//

- (void)_closeButtontoLeft {
    // NavigationBarにXボタンを設置する
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                         target:self
                                                                         action:@selector(_closeSettingView:)];
    self.navigationItem.leftBarButtonItem = btn;
}

- (void)_closeSettingView:(UIButton *)sender {
    // 設定ページを閉じる
    [self dismissViewControllerAnimated:YES completion:nil];
}

//--------------------------------------------------------------//
#pragma mark -- Private Method --
//--------------------------------------------------------------//

- (void)_setupMenuData {
    // 設定メニュー名とアイコン、画面遷移blockのセットを生成
    NSMutableArray *menuNameList = [[NSMutableArray alloc] init];
    NSMutableArray *menuIconList = [[NSMutableArray alloc] init];
    NSMutableArray *menuSegueActionList = [[NSMutableArray alloc] init];

    for (int idx = 0; idx < LastMenu; ++idx) {
        NSMutableDictionary *menuItem = [self _getMenuItem:idx];
        [menuNameList addObject:menuItem[@"menuName"]];
        [menuIconList addObject:menuItem[@"iconImage"]];
        [menuSegueActionList addObject:menuItem[@"block"]];
    }
    _menuNameList = menuNameList;
    _menuIconList = menuIconList;
    _menSegueActionList = menuSegueActionList;
}

- (NSMutableDictionary *)_getMenuItem:(int)menuKey {
    // 設定メニューデータを取得
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    switch (menuKey) {
        case MENU_BOOKMARK: {
            dict[@"menuName"] = kMenuBookmarkName;
            dict[@"iconImage"] = [UIImage imageNamed:kBookmarkIcon];
            dict[@"block"] = ^() {
                [self performSegueWithIdentifier:kToCategoryOfBookmarkBySegue sender:self];
            };
        } break;
        case MENU_CATEGORY: {
            dict[@"menuName"] = kMenuCategoryName;
            dict[@"iconImage"] = [UIImage imageNamed:kCategoryIcon];
            dict[@"block"] = ^() {
                [self performSegueWithIdentifier:kToCategoryListBySegue sender:self];
            };
        } break;
        case MENU_PAGE: {
            dict[@"menuName"] = kMenuPageName;
            dict[@"iconImage"] = [UIImage imageNamed:kPageIcon];
            dict[@"block"] = ^() {
                [self performSegueWithIdentifier:kToPageListBySegue sender:self];
            };
        } break;
        case MENU_DESIGN: {
            dict[@"menuName"] = kMenuDesignName;
            dict[@"iconImage"] = [UIImage imageNamed:kDesignIcon];
            dict[@"block"] = ^() {
                [self performSegueWithIdentifier:kToPageListBySegue sender:self];
            };
        } break;
    }
    dict[@"menuName"] = [NSString stringWithFormat:@"%@%@", dict[@"menuName"], @"設定"];
    return dict;
}

@end
