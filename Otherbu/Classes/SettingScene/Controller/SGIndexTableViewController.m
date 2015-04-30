//
//  SGIndexTableViewController.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "SGIndexTableViewController.h"
#import "SettingTableViewCell.h"
#import "SGSectionHeaderView.h"

@interface SGIndexTableViewController () {
    NSArray *_menuSectionList;
    NSMutableArray *_menuSectionCountList;
    NSMutableDictionary *_menuItems;
}

@end

@implementation SGIndexTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _menuSectionList = @[ kMenuSectionName1, kMenuSectionName2, kMenuSectionName3 ];
    _menuSectionCountList = [@[ [Helper getNumberByInt:0], [Helper getNumberByInt:0], [Helper getNumberByInt:0] ] mutableCopy];
    [self _setupMenuData];
    [self.tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.1, 20)]];
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

    NSString *itemKey = [self _getMenuItemKey:indexPath.section row:indexPath.row];
    NSMutableDictionary *menuItem = _menuItems[itemKey];
    cell.textLabel.text = menuItem[@"menuName"];
    cell.imageView.image = menuItem[@"iconImage"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 画面遷移
    NSString *itemKey = [self _getMenuItemKey:indexPath.section row:indexPath.row];
    NSMutableDictionary *menuItem = _menuItems[itemKey];
    void (^block)(void) = menuItem[@"block"];
    block();
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

    SGSectionHeaderView *sectionView = [[SGSectionHeaderView alloc] initWithFrame:frame];
    [sectionView setup:sectionName];
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
        case MENU_SYNC: {
            [self _setSyncItem:dict];
        } break;
        case MENU_SIGN: {
            [self _setSignItem:dict];
        } break;
        case MENU_HELP: {
            [self _setHelpItem:dict];
        } break;
        case MENU_REVIEW: {
            [self _setReviewItem:dict];
        } break;
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
        [self performSegueWithIdentifier:kToPageListBySegue sender:self];
    };
}

- (void)_setSearchItem:(NSMutableDictionary *)dict {
    dict[@"section"] = [Helper getNumberByInt:0];
    dict[@"menuName"] = [NSString stringWithFormat:@"%@%@", kMenuSearchName, @"設定"];
    dict[@"iconImage"] = [UIImage imageNamed:kBlackSearchIcon];
    dict[@"block"] = ^() {
        [self performSegueWithIdentifier:kToPageListBySegue sender:self];
    };
}

- (void)_setSyncItem:(NSMutableDictionary *)dict {
    dict[@"section"] = [Helper getNumberByInt:1];
    dict[@"menuName"] = kMenuSyncName;
    dict[@"iconImage"] = [UIImage imageNamed:kSyncIcon];
    dict[@"block"] = ^() {
        [self performSegueWithIdentifier:kToPageListBySegue sender:self];
    };
}

- (void)_setSignItem:(NSMutableDictionary *)dict {
    dict[@"section"] = [Helper getNumberByInt:1];
    dict[@"menuName"] = kMenuSigninName;
    dict[@"iconImage"] = [UIImage imageNamed:kSignInIcon];
    dict[@"block"] = ^() {
        [self performSegueWithIdentifier:kToPageListBySegue sender:self];
    };
}

- (void)_setHelpItem:(NSMutableDictionary *)dict {
    dict[@"section"] = [Helper getNumberByInt:2];
    dict[@"menuName"] = kMenuHelpName;
    dict[@"iconImage"] = [UIImage imageNamed:kHelpIcon];
    dict[@"block"] = ^() {
        [self performSegueWithIdentifier:kToPageListBySegue sender:self];
    };
}

- (void)_setReviewItem:(NSMutableDictionary *)dict {
    dict[@"section"] = [Helper getNumberByInt:2];
    dict[@"menuName"] = kMenuReviewName;
    dict[@"iconImage"] = [UIImage imageNamed:kReviewIcon];
    dict[@"block"] = ^() {
        [self performSegueWithIdentifier:kToPageListBySegue sender:self];
    };
}

- (void)_setWebSiteItem:(NSMutableDictionary *)dict {
    dict[@"section"] = [Helper getNumberByInt:2];
    dict[@"menuName"] = kMenuWebSiteName;
    dict[@"iconImage"] = [UIImage imageNamed:kWebSiteIcon];
    dict[@"block"] = ^() {
        [self performSegueWithIdentifier:kToPageListBySegue sender:self];
    };
}

- (void)_setVersionItem:(NSMutableDictionary *)dict {
    dict[@"section"] = [Helper getNumberByInt:2];
    dict[@"menuName"] = kMenuVersionName;
    dict[@"menuName"] = [NSString stringWithFormat:@"%@         %@", kMenuVersionName, kAppVersion];
    dict[@"iconImage"] = [UIImage imageNamed:kVersionIcon];
    dict[@"block"] = ^() {};
}

@end
