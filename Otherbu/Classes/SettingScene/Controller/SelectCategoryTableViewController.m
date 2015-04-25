//
//  SelectCategoryTableViewController.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "SelectCategoryTableViewController.h"
#import "CategoryData.h"
#import "BookmarkTableViewController.h"

@interface SelectCategoryTableViewController ()  {
    CategoryData *_selectCategory;
    NSArray *_categoryList;
}

@end

@implementation SelectCategoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _categoryList = [[DataManager sharedManager] getCategoryList];
}

//--------------------------------------------------------------//
#pragma mark -- UITableViewDataSource --
//--------------------------------------------------------------//

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _categoryList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];

    CategoryData *category = (CategoryData *)_categoryList[indexPath.row];
    cell.textLabel.text = category.name;
    cell.imageView.image = [UIImage imageNamed:kCategoryIcon];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectCategory = (CategoryData *)_categoryList[indexPath.row];
    [self performSegueWithIdentifier:kToBookmarkListBySegue sender:self];
}

//--------------------------------------------------------------//
#pragma mark -- segue --
//--------------------------------------------------------------//

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:kToBookmarkListBySegue]) {
        BookmarkTableViewController *bookmarkTableViewController = (BookmarkTableViewController*)[segue destinationViewController];
        bookmarkTableViewController.category = _selectCategory;
        bookmarkTableViewController.bookmarkList = [_selectCategory getBookmarkList];
    }
}

@end
