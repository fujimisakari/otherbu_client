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

- (void)setupWithCGSize:(CGSize)cgSize viewController:(MainViewController *)viewController;
- (void)reloadTableData;

@end
