//
//  SGNavigationViewController.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "SGNavigationViewController.h"

@interface SGNavigationViewController ()

@end

@implementation SGNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationBar.barTintColor = [UIColor blackColor];  // 背景色
    self.navigationBar.tintColor = [UIColor whiteColor];     // バーアイテムカラー

    // タイトル名のフォント設定
    NSDictionary *attributes = @{
        NSFontAttributeName : [UIFont fontWithName:kDefaultFont size:kFontSizeOfTitle],
        NSForegroundColorAttributeName : [UIColor whiteColor],
    };
    [self.navigationBar setTitleTextAttributes:attributes];

    // タイトル名の位置設定
    [self.navigationBar setTitleVerticalPositionAdjustment:kOffsetYOfTitle forBarMetrics:UIBarMetricsDefault];
}

@end
