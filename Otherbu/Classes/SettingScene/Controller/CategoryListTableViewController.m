//
//  CategoryListTableViewController.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "CategoryListTableViewController.h"
#import "CategoryData.h"

@interface CategoryListTableViewController () {
    NSMutableArray *_categoryList;
    NSIndexPath *_deleteIndexPath;
    UIAlertView *_confirmAlert;
}

@end

@implementation CategoryListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.editing = YES;
    _categoryList = [[DataManager sharedManager] getCategoryList];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self _createConfirmAlertView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)_createConfirmAlertView {
    _confirmAlert = [[UIAlertView alloc] init];
    _confirmAlert.delegate = self;
    _confirmAlert.title = @"カテゴリの削除";
    [_confirmAlert addButtonWithTitle:@"Cancel"];
    [_confirmAlert addButtonWithTitle:@"OK"];
    _confirmAlert.cancelButtonIndex = 0;
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
        _deleteIndexPath = indexPath;
        CategoryData *category = _categoryList[indexPath.row];
        _confirmAlert.message = [NSString stringWithFormat:@"%@に設定されているブックマークも削除されますがよろしいですか？", category.name];
        [_confirmAlert show];
    }
}

//--------------------------------------------------------------//
#pragma mark -- UIAlertViewDelegate --
//--------------------------------------------------------------//

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex != alertView.cancelButtonIndex) {
        // MasterDataからカテゴリ、関連ブックマークを削除
        _categoryList = [[DataManager sharedManager] deleteCategoryData:_categoryList DeleteIndex:_deleteIndexPath.row];

        // cellから削除
        [self.tableView deleteRowsAtIndexPaths:@[_deleteIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


@end
