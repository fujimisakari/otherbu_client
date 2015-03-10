//
//  ScrollView.h
//  Otherbu
//
//  Created by fujimisakari on 2015/03/11.
//  Copyright (c) 2015年 fujimisakari. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;

@interface ScrollView : UIScrollView

- (void)setUpWithCGSize:(CGSize)cgSize viewController:(MainViewController *)viewController;

@end
