//
//  InnerTableView.m
//  Otherbu
//
//  Created by fujimisakari on 2015/02/17.
//  Copyright (c) 2015年 fujimisakari. All rights reserved.
//

#import "InnerTableView.h"
#import "DataManager.h"

@implementation InnerTableView

@synthesize number = number_;

// 数値を設定してMyViewControllerのインスタンスを取得するクラスメソッド
+ (InnerTableView *)initInnerTableViewWithNumber:(NSInteger)number {
    InnerTableView *innerTableView = [[InnerTableView alloc] init];
    innerTableView.number = number;
    return innerTableView;
}

- (NSMutableArray *)categoryList {
    DataManager *dataManager = [DataManager sharedManager];
    PageData *page = dataManager.pageDict[@16];
    if (page) {
        NSMutableDictionary *categoryListOfAngle =[page getCategoryListOfAngle];
        return categoryListOfAngle[[NSNumber numberWithInt: self.number]];
    } else {
        return [[NSMutableArray alloc] init];
    }
}

// - (void)viewDidLoad {
//     [super viewDidLoad];
//     // UILabel *label = [[UILabel alloc] init];
//     // label.frame = self.view.bounds;
//     // label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//     // label.backgroundColor = (self.number % 2) ? [UIColor blackColor] : [UIColor whiteColor];
//     // label.textColor = !(self.number % 2) ? [UIColor blackColor] : [UIColor whiteColor];
//     // label.textAlignment = UITextAlignmentCenter;
//     // label.font = [UIFont boldSystemFontOfSize:128];
//     // label.text = [NSString stringWithFormat:@"%ld", self.number];
//     // [self.view addSubview:label];
// }

// - (void)didReceiveMemoryWarning {
//     [super didReceiveMemoryWarning];
//     // Dispose of any resources that can be recreated.
// }

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

@end
