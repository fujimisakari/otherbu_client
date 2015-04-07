//
//  SettingSelectCategoryTableViewController.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "SettingSelectCategoryTableViewController.h"
#import "CategoryData.h"
#import "SettingBookmarkTableViewController.h"

@interface SettingSelectCategoryTableViewController ()  {
    CategoryData *_category;
    NSArray *_categoryList;
    NSArray *_bookmarkList;
}

@end

@implementation SettingSelectCategoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _categoryList = [[DataManager sharedManager] getCategoryList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//--------------------------------------------------------------//
#pragma mark -- UITableViewDataSource --
//--------------------------------------------------------------//

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _categoryList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];

    CategoryData *category = (CategoryData *)_categoryList[indexPath.row];
    cell.textLabel.text = category.name;
    cell.imageView.image = [UIImage imageNamed:kCategoryIcon];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _category = (CategoryData *)_categoryList[indexPath.row];
    _bookmarkList = [_category getBookmarkList];
    [self performSegueWithIdentifier:kToBookmarkListBySegue sender:self];
}

//--------------------------------------------------------------//
#pragma mark -- segue --
//--------------------------------------------------------------//

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:kToBookmarkListBySegue]) {
        SettingBookmarkTableViewController *bookmarkTableViewController = (SettingBookmarkTableViewController*)[segue destinationViewController];
        [bookmarkTableViewController setCategory:_category];
        [bookmarkTableViewController setBookmarkList:_bookmarkList];
    }
}

@end
