//
//  InnerTableView.h
//  Otherbu
//
//  Created by fujimisakari on 2015/02/17.
//  Copyright (c) 2015年 fujimisakari. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InnerTableView : UITableView

@property (nonatomic, assign) NSInteger number;

+ (InnerTableView *)initInnerTableViewWithNumber:(NSInteger)number;

@end
