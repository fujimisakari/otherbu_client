//
//  InnerTableView.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "InnerTableView.h"

@implementation InnerTableView

//--------------------------------------------------------------//
#pragma mark -- initialize --
//--------------------------------------------------------------//

- (id)initWithTag:(int)tag frame:(CGRect)rect {
    self = [super initWithFrame:rect style:UITableViewStyleGrouped];
    if (self) {
        self.tag = tag;
    }
    return self;
}

- (id)setUp {
    // 自前で区切り線は用意するので利用しない
    self.separatorStyle = UITableViewCellSeparatorStyleNone;

    // テーブルの上部、下部に余白を空ける
    self.contentInset = UIEdgeInsetsMake(kMarginTopOfTableFrame, 0, kMarginBottomOfTableFrame, 0);

    // 背景は透過させる
    UIColor *color = [UIColor blackColor];
    UIColor *alphaColor = [color colorWithAlphaComponent:0.0];
    self.backgroundColor = alphaColor;

    return self;
}

@end
