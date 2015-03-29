//
//  SettingTableViewController.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "SettingTableViewController.h"

@interface SettingTableViewController () {
    NSArray *_menuNameList;
}

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];

    _menuNameList = [self _createMenuNameList];
    [self _closeButtontoLeft];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//--------------------------------------------------------------//
#pragma mark -- UITableViewDataSource --
//--------------------------------------------------------------//

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _menuNameList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = _menuNameList[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case MENU_BOOKMARK:
            [self performSegueWithIdentifier:kToCategoryOfBookmarkBySegue sender:self];
            break;
        case MENU_BOOKMARKMOVE:
            [self performSegueWithIdentifier:@"" sender:self];
            break;
        case MENU_CATEGORY:
            [self performSegueWithIdentifier:kToCategoryListBySegue sender:self];
            break;
        case MENU_PAGE:
            [self performSegueWithIdentifier:kToPageListBySegue sender:self];
            break;
        case MENU_DESIGN:
            break;
    }
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

- (NSMutableArray *)_createMenuNameList {
    // 設定メニュー名リストを生成
    NSMutableArray *menuNameList = [[NSMutableArray alloc] init];

    for (int idx = 0; idx < LastMenu; ++idx) {
        NSString *menuName = nil;
        switch (idx) {
            case MENU_BOOKMARK:
                menuName = kMenuBookmarkName;
                break;
            case MENU_BOOKMARKMOVE:
                menuName = kMenuBokkmarkMoveName;
                break;
            case MENU_CATEGORY:
                menuName = kMenuCategoryName;
                break;
            case MENU_PAGE:
                menuName = kMenuPageName;
                break;
            case MENU_DESIGN:
                menuName = kMenuDesignName;
                break;
        }
        if (menuName) {
            [menuNameList addObject:menuName];
        }
    }
    return menuNameList;
}

@end
