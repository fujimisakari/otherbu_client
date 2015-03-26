//
//  BookmarkTableViewController.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "BookmarkTableViewController.h"
#import "BookmarkData.h"

@interface BookmarkTableViewController () {
    NSArray *itemList;
}

@end

@implementation BookmarkTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return itemList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    BookmarkData *item = (BookmarkData *)itemList[indexPath.row];
    cell.textLabel.text = item.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


//--------------------------------------------------------------//
#pragma mark -- Public Method --
//--------------------------------------------------------------//

- (void)setBookmarkList:(NSArray *)bookmarkList {
    itemList = bookmarkList;
}


@end