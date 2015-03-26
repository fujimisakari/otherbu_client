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
    NSMutableArray *itemList;
    NSArray *_bookmarkList;
}

@end

@implementation SelectCategoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];

    itemList = [[DataManager sharedManager] getCategoryList];
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

    CategoryData *item = (CategoryData *)itemList[indexPath.row];
    cell.textLabel.text = item.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoryData *item = (CategoryData *)itemList[indexPath.row];
    _bookmarkList = [item getBookmarkList];
    [self performSegueWithIdentifier:@"toBookmarkTableViewController" sender:self];
}

//--------------------------------------------------------------//
#pragma mark -- segue --
//--------------------------------------------------------------//

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"toBookmarkTableViewController"]) {
        NSLog(@"%@", _bookmarkList);
        BookmarkTableViewController *bookmarkTableViewController = (BookmarkTableViewController*)[segue destinationViewController];
        [bookmarkTableViewController setBookmarkList:_bookmarkList];
    }
}


@end
