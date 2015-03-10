//
//  InnerTableView.m
//  Otherbu
//
//  Created by fujimisakari on 2015/03/04.
//  Copyright (c) 2015年 fujimisakari. All rights reserved.
//

#import "InnerTableView.h"
#import "MainViewController.h"

@implementation InnerTableView

+ (id)initWithTag:(int)tag frame:(CGRect)rect {
    InnerTableView *innerTableView = [[InnerTableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    innerTableView.tag = tag;
    return innerTableView;
}

- (id)setUpWithViewController:(MainViewController *)viewController {
    self.separatorStyle = UITableViewCellSeparatorStyleNone; // 自前で区切り線は用意するので利用しない
    self.delegate = viewController;
    self.dataSource = viewController;

    // テーブルの上部に余白を空ける
    self.contentInset = UIEdgeInsetsMake(20.0, 0, 0, 0);

    // 背景は透過させる
    UIColor *color = [UIColor blackColor];
    UIColor *alphaColor = [color colorWithAlphaComponent:0.0];
    self.backgroundColor = alphaColor;

    return self;
}

@end
