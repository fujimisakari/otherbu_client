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
    NSArray *_categoryList;
}

@end

@implementation SettingCategoryListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    _categoryList = [[DataManager sharedManager] getCategoryList];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated {
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    // self.navigationController.navigationBar.topItem.title = _page.name;
    // UIBarButtonItem *barButtonItem1 = [[UIBarButtonItem alloc]
    //                                    initWithBarButtonSystemItem:UIBarButtonSystemItemSave
    //                                    target:self action:@selector(_openSettingView:)];

    // animated:YESでItemを設定する
    // [self.navigationController.toolbar setItems:[NSArray arrayWithObjects:barButtonItem1, nil] animated:YES];    // (1)
    // self.navigationItem.rightBarButtonItem = barButtonItem1;

    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//--------------------------------------------------------------//
#pragma mark -- UITableViewDataSource --
//--------------------------------------------------------------//

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _categoryList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];

    CategoryData *category = (CategoryData *)_categoryList[indexPath.row];
    cell.textLabel.text = category.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = [UIImage imageNamed:kCategoryIcon];
    return cell;
}

@end
