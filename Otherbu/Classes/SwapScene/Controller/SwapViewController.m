//
//  SwapTableViewController.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "SwapViewController.h"
#import "NavigationBar.h"
#import "CategoryData.h"
#import "PageData.h"

@interface SwapViewController () {
    NSMutableDictionary *_categoryListOfAngle;
}

@end

@implementation SwapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _tableView.editing = YES;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    _categoryListOfAngle = [_page getCategoryListOfAngle];

    // 背景画像設定
    CGRect rect = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + _navigationBar.frame.size.height,
                             self.view.frame.size.width, self.view.frame.size.height);
    [Helper setupBackgroundImage:rect TargetView:self.view];

    // NavigationBar設定
    [_navigationBar setup];
    [_navigationBar setButtonInSwapScene];
    _navigationBar.topItem.leftBarButtonItem.target = self;
    _navigationBar.topItem.rightBarButtonItem.action = @selector(_closeSwapView:);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_navigationBar deleteButtonInSwapScene];
}

//--------------------------------------------------------------//
#pragma mark -- UITableViewDataSource --
//--------------------------------------------------------------//

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _categoryListOfAngle.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSNumber *angleId = [Helper getNumberByInt:section + 1];
    NSMutableArray *categoryList = _categoryListOfAngle[angleId];
    return categoryList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];

    NSNumber *angleId = [Helper getNumberByInt:indexPath.section + 1];
    NSMutableArray *categoryList = _categoryListOfAngle[angleId];
    CategoryData *categoryData = categoryList[indexPath.row];
    cell.textLabel.text = categoryData.name;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // 指定されたセクションのセクション名を返す
    int idx = section + 1;
    NSString *sectionName;
    switch (idx) {
        case LEFT:
            sectionName = @"LEFT";
            break;
        case CENTER:
            sectionName = @"CENTER";
            break;
        case RIGHT:
            sectionName = @"RIGHT";
            break;
    }
    return sectionName;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    // 表示順(Page)の編集
    NSNumber *fromAngleId = [Helper getNumberByInt:fromIndexPath.section + 1];
    NSNumber *toAngleId = [Helper getNumberByInt:toIndexPath.section + 1];
    CategoryData *category = [_categoryListOfAngle[fromAngleId] objectAtIndex:fromIndexPath.row];
    [_categoryListOfAngle[fromAngleId] removeObjectAtIndex:fromIndexPath.row];
    [_categoryListOfAngle[toAngleId] insertObject:category atIndex:toIndexPath.row];
    [_page updatePageDataBySwap:_categoryListOfAngle];
}

//--------------------------------------------------------------//
#pragma mark-- Navi Button Event--
//--------------------------------------------------------------//

- (void)_closeSwapView:(UIButton *)sender {
    // 画面を閉じるを閉じる
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
