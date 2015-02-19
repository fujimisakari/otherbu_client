//
//  MyViewController.m
//  Otherbu
//
//  Created by fujimisakari on 2015/02/17.
//  Copyright (c) 2015年 fujimisakari. All rights reserved.
//

#import "MyViewController.h"

@implementation MyViewController {
    NSArray *tableDataList;
}

@synthesize number = number_;

// 数値を設定してMyViewControllerのインスタンスを取得するクラスメソッド
+ (MyViewController *)myViewControllerWithNumber:(NSInteger)number {
    MyViewController *myViewController = [[MyViewController alloc] init];
    myViewController.number = number;
    return myViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // UILabel *label = [[UILabel alloc] init];
    // label.frame = self.view.bounds;
    // label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    // label.backgroundColor = (self.number % 2) ? [UIColor blackColor] : [UIColor whiteColor];
    // label.textColor = !(self.number % 2) ? [UIColor blackColor] : [UIColor whiteColor];
    // label.textAlignment = UITextAlignmentCenter;
    // label.font = [UIFont boldSystemFontOfSize:128];
    // label.text = [NSString stringWithFormat:@"%ld", self.number];
    // [self.view addSubview:label];

    NSDictionary *cell0 = @{@"site" : @"アップル", @"url" : @"http://www.apple.com/jp/"};
    NSDictionary *cell1 = @{@"site" : @"アップルストア", @"url" : @"http://store.apple.com/jp"};
    NSDictionary *cell2 = @{@"site" : @"Yahoo!JAPAN", @"url" : @"http://www.yahoo.co.jp"};
    NSDictionary *cell3 = @{@"site" : @"THE NORTH FACE", @"url" : @"http://www.thenorthface.com/en_US/index.html"};
    NSDictionary *cell4 = @{@"site" : @"Manchester United", @"url" : @"http://www.manutd.jp"};
    NSDictionary *section1 = @{@"header": @"list1", @"data": @[cell0, cell1, cell2]};
    NSDictionary *section2 = @{@"header": @"list2", @"data": @[cell3, cell4]};
    tableDataList = @[section1, section2];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// #pragma mark - Segues

// - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//     if ([[segue identifier] isEqualToString:@"showDetail"]) {
//         // 選択された行を調べる
//         // NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//         NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//         // セクションデータを取り出す
//         NSDictionary *theSection = tableDataList[indexPath.section];
//         // セクションのセルの配置を取り出す
//         NSArray *theData = theSection[@"data"];
//         // 指定行のセルを取り出す
//         Bookmark *theCell = theData[indexPath.row];
//         // urlを取り出す
//         NSString *url = theCell.url;
//         [[segue destinationViewController] setDetailItem:url];
//     }
// }

#pragma mark - Table View

/**
 * テーブル全体のセクションの数を返す
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return tableDataList.count;
}

/**
 * 指定されたセクションのセクション名を返す
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDictionary *theSection = tableDataList[section];
    return theSection[@"header"];
}

/**
 * 指定されたセクションの項目数を返す
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *theSection = tableDataList[section];
    NSArray *theData = theSection[@"data"];
    return theData.count;
}

/**
 * 指定された箇所のセルを作成する
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    // セルが作成されていないか?
    if (!cell) {  // yes
        // セルを作成
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    NSDictionary *theSection = tableDataList[indexPath.section];
    NSArray *theData = theSection[@"data"];
    NSDictionary *theCell = theData[indexPath.row];
    cell.textLabel.text = theCell[@"site"];
    cell.detailTextLabel.text = theCell[@"url"];
    return cell;
}

@end
