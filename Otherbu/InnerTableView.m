//
//  InnerTableView.m
//  Otherbu
//
//  Created by fujimisakari on 2015/02/17.
//  Copyright (c) 2015年 fujimisakari. All rights reserved.
//

#import "InnerTableView.h"

@implementation InnerTableView

// 数値を設定してMyViewControllerのインスタンスを取得するクラスメソッド
+ (InnerTableView *)initInnerTableViewWithNumber:(NSInteger)number {
    InnerTableView *innerTableView = [[InnerTableView alloc] init];
    // innerTableView.number = number;
    return innerTableView;
}

@end
