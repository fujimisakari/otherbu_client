//
//  NavigationBar.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "NavigationBar.h"

@implementation NavigationBar

//--------------------------------------------------------------//
#pragma mark -- initialize --
//--------------------------------------------------------------//

- (void)setup {
    self.topItem.title = kTitle;               // タイトル名
    self.tintColor = [UIColor whiteColor];     // バーアイテムカラー
    self.barTintColor = [UIColor blackColor];  // 背景色

    // タイトル名のフォントカラー設定
    NSDictionary *attributes = @{
        NSFontAttributeName : [UIFont fontWithName:kDefaultFont size:kFontSizeOfTitle],
        NSForegroundColorAttributeName : [UIColor whiteColor],
    };
    [self setTitleTextAttributes:attributes];

    // タイトル名の位置設定
    [self setTitleVerticalPositionAdjustment:kOffsetYOfTitle forBarMetrics:UIBarMetricsDefault];
}

@end
