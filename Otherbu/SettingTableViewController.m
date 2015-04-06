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
}

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[SettingTableViewCell class] forCellReuseIdentifier:kCellIdentifier];

    [self _setupMenuData];
    [self _closeButtontoLeft];

    self.tableView.separatorColor = [UIColor clearColor];

    [self _setupBackgroundImage];
}

- (void)_setupBackgroundImage {
    // UIViewContollerに背景画像を設定する
    UIGraphicsBeginImageContextWithOptions(self.tableView.bounds.size, NO, 0.0);
    [[UIImage imageNamed:kDefaultImageName] drawInRect:self.tableView.bounds];
    UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CALayer *layer = [CALayer layer];
    layer.contents = (id)backgroundImage.CGImage;
    layer.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y,
                             self.tableView.frame.size.width, self.tableView.frame.size.height);
    layer.zPosition = -1.0;
    [self.tableView.layer addSublayer:layer];
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
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = _menuNameList[indexPath.row];
    cell.imageView.image = _menuIconList[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

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

    // LOG_SIZE(cell.textLabel.frame.size);
    // int labelY = cell.textLabel.frame.origin.y + 40;
    // cell.textLabel.bounds = CGRectMake(0, labelY, cell.textLabel.frame.size.width, cell.textLabel.frame.size.height);
    // cell.imageView.bounds = CGRectMake(0, labelY, cell.imageView.frame.size.width, cell.imageView.frame.size.height);
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
        menuName = [NSString stringWithFormat:@"%@%@", menuName, @"設定"];
        [menuNameList addObject:menuName];
        [menuIconList addObject:iconImage];
    }
    _menuNameList = menuNameList;
    _menuIconList = menuIconList;
}

@end
