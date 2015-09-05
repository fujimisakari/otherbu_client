//
//  SGIndexTableViewController.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "MBProgressHUD.h"
#import "SGIndexTableViewController.h"
#import "SettingTableViewCell.h"
#import "SectionHeaderView.h"
#import "SettingAlertView.h"
#import "UserData.h"
#import "AuthTypeData.h"

@interface SGIndexTableViewController () {
    NSArray *_menuSectionList;
    NSMutableArray *_menuSectionCountList;
    NSMutableDictionary *_menuItems;
    SettingAlertView *_alertView;
}

@end

@implementation SGIndexTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _menuSectionList = @[ kMenuSectionName1, kMenuSectionName2, kMenuSectionName3 ];
    [self.tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.1, 20)]];

    // 同期終了時のポップアップ
    _alertView = [[SettingAlertView alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self _pageReload];
}


- (void)_pageReload {
    _menuSectionCountList = [@[ [Helper getNumberByInt:0], [Helper getNumberByInt:0], [Helper getNumberByInt:0] ] mutableCopy];
    [self _setupMenuData];
    [self.tableView reloadData];
}

//--------------------------------------------------------------//
#pragma mark -- UITableViewDataSource --
//--------------------------------------------------------------//

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _menuSectionCountList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_menuSectionCountList[section] intValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];

    NSString *itemKey = [self _getMenuItemKey:(int)indexPath.section row:(int)indexPath.row];
    NSMutableDictionary *menuItem = _menuItems[itemKey];
    cell.textLabel.text = menuItem[@"menuName"];
    cell.imageView.image = menuItem[@"iconImage"];
    if ([menuItem[@"styleNone"] boolValue]) {
        // タップを無効、アクセサリを非表示
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    if ([cell.textLabel.text isEqualToString:kMenuVersionName]) {
        [self _setAppVersion:cell];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *itemKey = [self _getMenuItemKey:(int)indexPath.section row:(int)indexPath.row];
    NSMutableDictionary *menuItem = _menuItems[itemKey];

    void (^block)(void) = menuItem[@"block"];
    block();

    // 同期ボタンを押して終了時にノーマル状態に戻す処理(途中)
    // if ([menuItem[@"menuName"] isEqualToString:kMenuSyncName]) {
    //     UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    //     void (^block)(UITableViewCell *) = menuItem[@"block"];
    //     block(cell);
    // } else {
    //     void (^block)(void) = menuItem[@"block"];
    //     block();
    // }
}

- (void)_setAppVersion:(UITableViewCell *)cell {
    // 右端にVersion情報を設定
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    label.textColor = [UIColor grayColor];
    label.backgroundColor = [UIColor clearColor];
    label.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [container addSubview:label];
    cell.accessoryView = container;
}

//--------------------------------------------------------------//
#pragma mark -- UITableViewDelegate --
//--------------------------------------------------------------//

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    // セクションヘッダーの高さを返す
    return kHeightOfSettingDesc;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    // セクションヘッダーのコンテンツを設定する
    NSString *sectionName = _menuSectionList[section];
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, kHeightOfSettingDesc);

    SectionHeaderView *sectionView = [[SectionHeaderView alloc] initWithFrame:frame];
    [sectionView setup:sectionName FontSize:kFontSizeOfSettingDesc];
    return sectionView;
}

//--------------------------------------------------------------//
#pragma mark -- Private Method --
//--------------------------------------------------------------//

- (void)_setupMenuData {
    // 設定メニュー名とアイコン、画面遷移blockのセットを生成
    _menuItems = [[NSMutableDictionary alloc] init];

    int currentSection = 0;
    int offset = 0;
    for (int idx = 0; idx < LastMenu; ++idx) {
        NSMutableDictionary *menuItem = [self _getMenuItem:idx];
        if (menuItem[@"ignore"] && [(NSNumber *)menuItem[@"ignore"] boolValue]) {
            continue;
        }
        if ([menuItem[@"section"] intValue] != currentSection) {
            offset = 0;
            currentSection = [menuItem[@"section"] intValue];
        }

        NSString *itemKey = [self _getMenuItemKey:[(NSNumber *)menuItem[@"section"] intValue] row:offset];
        _menuItems[itemKey] = menuItem;
        offset++;
        [self _sectionCountUp:currentSection];
    }
}

- (NSString *)_getMenuItemKey:(int)section row:(int)row {
    return [NSString stringWithFormat:@"%d-%d", section, row];
}

- (void)_sectionCountUp:(int)section {
    int currentCount = [_menuSectionCountList[section] intValue];
    currentCount++;
    _menuSectionCountList[section] = [Helper getNumberByInt:currentCount];
}

- (NSMutableDictionary *)_getMenuItem:(int)menuKey {
    // 設定メニューデータを取得
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    switch (menuKey) {
        case MENU_BOOKMARK: {
            [self _setBookmarkItem:dict];
        } break;
        case MENU_CATEGORY: {
            [self _setCategoryItem:dict];
        } break;
        case MENU_PAGE: {
            [self _setPageItem:dict];
        } break;
        case MENU_DESIGN: {
            [self _setDesignItem:dict];
        } break;
        case MENU_SEARCH: {
            [self _setSearchItem:dict];
        } break;
        case MENU_AUTHTYPE: {
            [self _setAuthTypeItem:dict];
        } break;
        case MENU_SYNC: {
            [self _setSyncItem:dict];
        } break;
        case MENU_LOGIN: {
            [self _setLoginItem:dict];
        } break;
        case MENU_HELP: {
            [self _setHelpItem:dict];
        } break;
        // case MENU_REVIEW: {
        //     [self _setReviewItem:dict];
        // } break;
        case MENU_WEBSITE: {
            [self _setWebSiteItem:dict];
        } break;
        case MENU_VERSION: {
            [self _setVersionItem:dict];
        } break;
    }
    return dict;
}

- (void)_setBookmarkItem:(NSMutableDictionary *)dict {
    dict[@"section"] = [Helper getNumberByInt:0];
    dict[@"menuName"] = [NSString stringWithFormat:@"%@%@", kMenuBookmarkName, @"設定"];
    dict[@"iconImage"] = [UIImage imageNamed:kBookmarkIcon];
    dict[@"block"] = ^() {
        [self performSegueWithIdentifier:kToCategoryOfBookmarkBySegue sender:self];
    };
}

- (void)_setCategoryItem:(NSMutableDictionary *)dict {
    dict[@"section"] = [Helper getNumberByInt:0];
    dict[@"menuName"] = [NSString stringWithFormat:@"%@%@", kMenuCategoryName, @"設定"];
    dict[@"iconImage"] = [UIImage imageNamed:kCategoryIcon];
    dict[@"block"] = ^() {
        [self performSegueWithIdentifier:kToCategoryListBySegue sender:self];
    };
}

- (void)_setPageItem:(NSMutableDictionary *)dict {
    dict[@"section"] = [Helper getNumberByInt:0];
    dict[@"menuName"] = [NSString stringWithFormat:@"%@%@", kMenuPageName, @"設定"];
    dict[@"iconImage"] = [UIImage imageNamed:kPageIcon];
    dict[@"block"] = ^() {
        [self performSegueWithIdentifier:kToPageListBySegue sender:self];
    };
}

- (void)_setDesignItem:(NSMutableDictionary *)dict {
    dict[@"section"] = [Helper getNumberByInt:0];
    dict[@"menuName"] = [NSString stringWithFormat:@"%@%@", kMenuDesignName, @"設定"];
    dict[@"iconImage"] = [UIImage imageNamed:kDesignIcon];
    dict[@"block"] = ^() {
        [self performSegueWithIdentifier:kToDesignBySegue sender:self];
    };
}

- (void)_setSearchItem:(NSMutableDictionary *)dict {
    dict[@"section"] = [Helper getNumberByInt:0];
    dict[@"menuName"] = [NSString stringWithFormat:@"%@%@", kMenuSearchName, @"設定"];
    dict[@"iconImage"] = [UIImage imageNamed:kBlackSearchIcon];
    dict[@"block"] = ^() {
        [self performSegueWithIdentifier:kToSearchBySegue sender:self];
    };
}

- (void)_setAuthTypeItem:(NSMutableDictionary *)dict {
    UserData *user = [[DataManager sharedManager] getUser];
    if ([user isLogin]) {
        dict[@"section"] = [Helper getNumberByInt:1];
        dict[@"menuName"] = [NSString stringWithFormat:@"%@でログイン中", user.name];
        dict[@"iconImage"] = [UIImage imageNamed:[user authType].iconName];
        dict[@"block"] = ^() {};
        dict[@"styleNone"] = [NSNumber numberWithBool:YES];
    } else {
        dict[@"ignore"] = [Helper getNumberByInt:1];
    }
}

- (void)_setSyncItem:(NSMutableDictionary *)dict {
    dict[@"section"] = [Helper getNumberByInt:1];
    dict[@"menuName"] = kMenuSyncName;
    dict[@"iconImage"] = [UIImage imageNamed:kSyncIcon];
    dict[@"block"] = ^() {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[DataManager sharedManager] syncToWebWithBlock:^(int statusCode, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (error) {
                LOG(@"\nerror = %@", error);
                [_alertView setup:statusCode];
            } else {
                [_alertView setup:statusCode];
            }
            [_alertView show];
        }];
    };

    UserData *user = [[DataManager sharedManager] getUser];
    if (![user isLogin]) {
        dict[@"ignore"] = [Helper getNumberByInt:1];
    }
}

- (void)_setLoginItem:(NSMutableDictionary *)dict {
    dict[@"section"] = [Helper getNumberByInt:1];
    UserData *user = [[DataManager sharedManager] getUser];
    if ([user isLogin]) {
        dict[@"menuName"] = kMenuLogoutName;
        dict[@"iconImage"] = [UIImage imageNamed:kLogoutIcon];
        dict[@"block"] = ^() {
            [SNSProcess logout:user.type];
            [self _pageReload];
        };
    } else {
        dict[@"menuName"] = kMenuLoginName;
        dict[@"iconImage"] = [UIImage imageNamed:kLoginIcon];
        dict[@"block"] = ^() {
            [self performSegueWithIdentifier:kToLoginBySegue sender:self];
        };
    }
}

- (void)_setHelpItem:(NSMutableDictionary *)dict {
    dict[@"section"] = [Helper getNumberByInt:2];
    dict[@"menuName"] = kMenuHelpName;
    dict[@"iconImage"] = [UIImage imageNamed:kHelpIcon];
    dict[@"block"] = ^() {
        [self performSegueWithIdentifier:kToHelpWebViewBySegue sender:self];
    };
}

- (void)_setReviewItem:(NSMutableDictionary *)dict {
    dict[@"section"] = [Helper getNumberByInt:2];
    dict[@"menuName"] = kMenuReviewName;
    dict[@"iconImage"] = [UIImage imageNamed:kReviewIcon];
    dict[@"block"] = ^() {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://otherbu.com/"]];
    };
}

- (void)_setWebSiteItem:(NSMutableDictionary *)dict {
    dict[@"section"] = [Helper getNumberByInt:2];
    dict[@"menuName"] = kMenuWebSiteName;
    dict[@"iconImage"] = [UIImage imageNamed:kWebSiteIcon];
    dict[@"block"] = ^() {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://otherbu.com/"]];
    };
}

- (void)_setVersionItem:(NSMutableDictionary *)dict {
    dict[@"section"] = [Helper getNumberByInt:2];
    dict[@"menuName"] = [NSString stringWithFormat:@"%@", kMenuVersionName];
    dict[@"iconImage"] = [UIImage imageNamed:kVersionIcon];
    dict[@"block"] = ^() {};
    dict[@"styleNone"] = [NSNumber numberWithBool:YES];
}

@end
