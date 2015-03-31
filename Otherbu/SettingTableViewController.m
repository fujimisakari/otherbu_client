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
    NSArray *_menuIconList;
}

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];

    [self _setupMenuData];
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
    cell.imageView.image = _menuIconList[indexPath.row];
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

- (void)_setupMenuData {
    // 設定メニュー名とアイコンのセットを生成
    NSMutableArray *menuNameList = [[NSMutableArray alloc] init];
    NSMutableArray *menuIconList = [[NSMutableArray alloc] init];

    for (int idx = 0; idx < LastMenu; ++idx) {
        NSString *menuName = nil;
        UIImage *iconImage = nil;
        switch (idx) {
            case MENU_BOOKMARK:
                menuName = kMenuBookmarkName;
                iconImage = [UIImage imageNamed:kBookmarkIcon];
                break;
            case MENU_BOOKMARKMOVE:
                menuName = kMenuBookmarkMoveName;
                iconImage = [UIImage imageNamed:kBookmarkMoveIcon];
                break;
            case MENU_CATEGORY:
                menuName = kMenuCategoryName;
                iconImage = [UIImage imageNamed:kCategoryIcon];
                break;
            case MENU_PAGE:
                menuName = kMenuPageName;
                iconImage = [UIImage imageNamed:kPageIcon];
                break;
            case MENU_DESIGN:
                menuName = kMenuDesignName;
                iconImage = [UIImage imageNamed:kDesignIcon];
                break;
        }
        [menuNameList addObject:menuName];
        [menuIconList addObject:iconImage];
    }
    _menuNameList = menuNameList;
    _menuIconList = menuIconList;
}

@end
