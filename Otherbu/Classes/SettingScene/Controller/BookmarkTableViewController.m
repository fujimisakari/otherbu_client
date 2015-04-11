//
//  BookmarkTableViewController.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "BookmarkTableViewController.h"
#import "BookmarkData.h"
#import "CategoryData.h"

@interface BookmarkTableViewController () {
    CategoryData *_category;
    NSArray *_bookmarkList;
}

@end

@implementation BookmarkTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _category.name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//--------------------------------------------------------------//
#pragma mark -- UITableViewDataSource --
//--------------------------------------------------------------//

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _bookmarkList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];

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
