//
//  InnerTableView.m
//  Otherbu
//
//  Created by fujimisakari on 2015/02/17.
//  Copyright (c) 2015年 fujimisakari. All rights reserved.
//

#import "InnerTableView.h"
#import "DataManager.h"
#import "PageData.h"

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

@end
