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

    // 設定ボタンを追加
    [self _setSettingButtontoLeft];
    [self _setAddButtontoRight];
}

//--------------------------------------------------------------//
#pragma mark -- Setting Button --
//--------------------------------------------------------------//

- (void)_setSettingButtontoLeft {

    // NavigationBarにXボタンを設置する
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:kSettingIcon]
                                                            style:UIBarButtonItemStylePlain
                                                           target:nil
                                                           action:nil];
    self.topItem.leftBarButtonItem = btn;
}

- (void)_setAddButtontoRight {
    // NavigationBarに項目追加、入れ替えボタンを設置する
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:nil action:nil];
    UIBarButtonItem *swapButton =
        [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:kSwapIcon] style:UIBarButtonItemStylePlain target:nil action:nil];
    self.topItem.rightBarButtonItems = @[ addButton, swapButton ];
}

@end
