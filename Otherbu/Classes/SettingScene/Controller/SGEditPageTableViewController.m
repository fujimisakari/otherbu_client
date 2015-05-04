//
//  SGEditPageTableViewController.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "SGEditPageTableViewController.h"
#import "DescHeaderView.h"
#import "PageData.h"
#import "CategoryData.h"

@interface SGEditPageTableViewController () {
    NSArray *_categoryList;
    NSArray *_categoryListOfPage;
}

@end

@implementation SGEditPageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 説明Headerを追加
    DescHeaderView *descHeaderView = [[DescHeaderView alloc] init];
    CGSize size = CGSizeMake(self.view.frame.size.width - (kOffsetXOfTableCell * 2), kHeightOfSettingDesc + kMarginOfSettingDesc);
    [descHeaderView setupWithCGSize:size descMessage:@"Pageに含めるCategoryを選択ください"];
    [self.tableView setTableHeaderView:descHeaderView];

    _categoryList = [[DataManager sharedManager] getCategoryList];
    _categoryListOfPage = [_page getCategoryList];
    self.navigationItem.title = _page.name;
}

//--------------------------------------------------------------//
#pragma mark -- UITableViewDataSource --
//--------------------------------------------------------------//

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _categoryList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // セルの生成。ページに設定しているカテゴリはチェックマーク画像が表示させる
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    CategoryData *category = (CategoryData *)_categoryList[indexPath.row];
    NSUInteger isExistCategory = [_categoryListOfPage indexOfObject:category];
    if (isExistCategory == NSNotFound) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    cell.textLabel.text = category.name;
    cell.imageView.image = [UIImage imageNamed:kCategoryIcon];
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

@end
