//
//  SettingEditPageTableViewController.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "SettingEditPageTableViewController.h"
#import "PageData.h"
#import "CategoryData.h"

@interface SettingEditPageTableViewController () {
    NSArray *_categoryList;
    NSArray *_categoryListOfPage;
    PageData *_page;
}

@end

@implementation SettingEditPageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];

    _categoryList = [[DataManager sharedManager] getCategoryList];
    _categoryListOfPage = [_page getCategoryList];
}

- (void)viewDidAppear:(BOOL)animated {
    // UIBarButtonItem *barButtonItem1 = [[UIBarButtonItem alloc]
    //                                    initWithBarButtonSystemItem:UIBarButtonSystemItemSave
    //                                    target:self action:@selector(_openSettingView:)];

    // animated:YESでItemを設定する
    // [self.navigationController.toolbar setItems:[NSArray arrayWithObjects:barButtonItem1, nil] animated:YES];    // (1)
    // self.navigationItem.rightBarButtonItem = barButtonItem1;

    [super viewDidAppear:animated];
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
    return _categoryList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    CategoryData *category = (CategoryData *)_categoryList[indexPath.row];
    NSUInteger isExistCategory = [_categoryListOfPage indexOfObject:category];
    if (isExistCategory == NSNotFound) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    cell.textLabel.text = category.name;
    return cell;
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
#pragma mark -- Public Method --
//--------------------------------------------------------------//

- (void)setPage:(PageData *)page {
    _page = page;
}

@end
