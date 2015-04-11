//
//  SettingCategoryListTableViewController.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "SettingCategoryListTableViewController.h"
#import "CategoryData.h"

@interface SettingCategoryListTableViewController () {
    NSMutableArray *_categoryList;
}

@end

@implementation SettingCategoryListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.editing = YES;
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
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];

    CategoryData *category = (CategoryData *)_categoryList[indexPath.row];
    cell.textLabel.text = category.name;
    cell.imageView.image = [UIImage imageNamed:kCategoryIcon];
    return cell;
}

- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
     forRowAtIndexPath:(NSIndexPath *)indexPath {

    // 削除時
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_categoryList removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

        NSMutableDictionary *newCategoryDict = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < _categoryList.count; i++) {
            CategoryData *category = _categoryList[i];
            [newCategoryDict setObject:category forKey:[[NSNumber alloc] initWithInt:(int)category.dataId]];
        }
        [DataManager sharedManager].categoryDict = newCategoryDict;

        // todo
        // datamanageに削除済みを登録する
    }
}


@end
