//
//  SGSelectCategoryTableViewController.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "SGSelectCategoryTableViewController.h"
#import "CategoryData.h"
#import "DescHeaderView.h"
#import "SGBookmarkTableViewController.h"

@interface SGSelectCategoryTableViewController ()  {
    CategoryData *_selectCategory;
    NSArray *_categoryList;
}

@end

@implementation SGSelectCategoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 説明Headerを追加
    DescHeaderView *descHeaderView = [[DescHeaderView alloc] init];
    CGSize size = CGSizeMake(self.view.frame.size.width - (kOffsetXOfTableCell * 2), kHeightOfSettingDesc + kMarginOfSettingDesc);
    [descHeaderView setupWithCGSize:size descMessage:@"BookmarkのCategoryを選択ください"];
    [self.tableView setTableHeaderView:descHeaderView];

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
        SGBookmarkTableViewController *bookmarkTableViewController = (SGBookmarkTableViewController*)[segue destinationViewController];
        bookmarkTableViewController.category = _selectCategory;
        bookmarkTableViewController.bookmarkList = [_selectCategory getBookmarkList];
    }
}

@end
