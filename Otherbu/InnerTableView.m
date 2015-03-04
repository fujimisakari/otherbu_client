//
//  InnerTableView.m
//  Otherbu
//
//  Created by fujimisakari on 2015/03/04.
//  Copyright (c) 2015年 fujimisakari. All rights reserved.
//

#import "InnerTableView.h"
#import "ViewController.h"

@implementation InnerTableView

+ (id)initWithTag:(int)tag frame:(CGRect)rect {
    InnerTableView *innerTableView = [[InnerTableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    innerTableView.tag = tag;
    return innerTableView;
}

- (id)setUpWithViewController:(ViewController *)viewController {
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.delegate = viewController;
    self.dataSource = viewController;
    return self;
}

@end
