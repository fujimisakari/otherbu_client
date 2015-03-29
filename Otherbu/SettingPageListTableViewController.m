//
//  SettingPageListTableViewController.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "SettingPageListTableViewController.h"
#import "SettingEditPageTableViewController.h"
#import "PageData.h"

@interface SettingPageListTableViewController () {
    NSMutableArray *_categoryList;
    PageData *_selectPage;
}

@end

@implementation SettingPageListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    _categoryList = [[DataManager sharedManager] getPageList];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];

    PageData *page = (PageData *)_categoryList[indexPath.row];
    cell.textLabel.text = page.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PageData *page = (PageData *)_categoryList[indexPath.row];
    _selectPage = page;
    [self performSegueWithIdentifier:kToEditPageBySegue sender:self];
}

//--------------------------------------------------------------//
#pragma mark -- segue --
//--------------------------------------------------------------//

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:kToEditPageBySegue]) {
        SettingEditPageTableViewController *pageDetailTableViewController = (SettingEditPageTableViewController *)[segue destinationViewController];
        [pageDetailTableViewController setPage:_selectPage];
    }
}

@end
