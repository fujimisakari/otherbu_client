//
//  NavigationBar.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "NavigationBar.h"
#import "Constants.h"

@implementation NavigationBar

- (void)setup {
    // タイトル名設定
    self.topItem.title = kTitle;

    // タイトル名のフォントカラー設定
    NSDictionary *attributes = @{
        NSFontAttributeName : [UIFont fontWithName:kDefaultFont size:kFontSizeOfTitle],
        NSForegroundColorAttributeName : [UIColor whiteColor],
    };
    [self setTitleTextAttributes:attributes];

    // タイトル名の位置設定
    [self setTitleVerticalPositionAdjustment:kVerticalOffsetOfTitle forBarMetrics:UIBarMetricsDefault];
}

@end
