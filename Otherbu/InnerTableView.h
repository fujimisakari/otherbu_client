//
//  InnerTableView.h
//  Otherbu
//
//  Created by fujimisakari on 2015/03/04.
//  Copyright (c) 2015年 fujimisakari. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface InnerTableView : UITableView

+ (id)initWithTag:(int)tag frame:(CGRect)rect;

- (id)setUpWithViewController:(ViewController *)viewController;

@end
