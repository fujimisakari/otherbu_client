//
//  SettingTableViewController.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "SettingTableViewController.h"

@interface SettingTableViewController () {
    NSArray *menuList;
}

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];

    NSString *bookmark = @"ブックマーク";
    NSString *bookmarkMove = @"ブックマーク移動";
    NSString *category = @"カテゴリ";
    NSString *page = @"ページ";
    NSString *design = @"デザイン";
    menuList = @[bookmark, bookmarkMove, category, page, design];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    [self _closeButtontoLeft];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//--------------------------------------------------------------//
#pragma mark -- Close Button --
//--------------------------------------------------------------//

- (void)_closeButtontoLeft {
    // NavigationBarにXボタンを設置する
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                         target:self
                                                                         action:@selector(_closeWebView:)];
    self.navigationItem.leftBarButtonItem = btn;
    // self.navigationController.navigationItem.leftBarButtonItem = btn;
    // _navigationBar.topItem.leftBarButtonItem = btn;
}

- (void)_closeWebView:(UIButton *)sender {
    // WebViewのクローズ
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return menuList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    cell.textLabel.text = menuList[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"toSelectCategoryTableViewController" sender:self];
    } else if (indexPath.row == 1) {
        [self performSegueWithIdentifier:@"" sender:self];
    } else if (indexPath.row == 2) {
        [self performSegueWithIdentifier:@"toCateogoryTableViewController" sender:self];
    } else if (indexPath.row == 3) {
        [self performSegueWithIdentifier:@"toPageTableViewController" sender:self];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
