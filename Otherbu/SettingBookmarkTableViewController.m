//
//  SettingBookmarkTableViewController.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "SettingBookmarkTableViewController.h"
#import "BookmarkData.h"
#import "CategoryData.h"

@interface SettingBookmarkTableViewController () {
    CategoryData *_category;
    NSArray *_bookmarkList;
}

@end

@implementation SettingBookmarkTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    self.navigationController.navigationBar.topItem.title = _category.name;
}

//--------------------------------------------------------------//
#pragma mark -- UITableViewDataSource --
//--------------------------------------------------------------//

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _bookmarkList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];

    BookmarkData *bookmark = (BookmarkData *)_bookmarkList[indexPath.row];
    cell.textLabel.text = bookmark.name;
    cell.imageView.image = [UIImage imageNamed:kBookmarkIcon];
    return cell;
}


//--------------------------------------------------------------//
#pragma mark -- Public Method --
//--------------------------------------------------------------//

- (void)setCategory:(CategoryData *)category {
    _category = category;
}

- (void)setBookmarkList:(NSArray *)bookmarkList {
    _bookmarkList = bookmarkList;
}

@end
