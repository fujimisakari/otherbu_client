//
//  InnerTableView.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;

@interface InnerTableView : UITableView

+ (id)initWithTag:(int)tag frame:(CGRect)rect;

- (id)setUpWithViewController:(MainViewController *)viewController;

@end
