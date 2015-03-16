//
//  ScrollView.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;

@interface ScrollView : UIScrollView

@property(nonatomic) CGFloat beginScrollOffsetY;

- (void)setupWithCGSize:(CGSize)cgSize viewController:(MainViewController *)viewController;

@end
