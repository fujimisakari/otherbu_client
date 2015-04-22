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

//--------------------------------------------------------------//
#pragma mark -- Set Delete Button --
//--------------------------------------------------------------//

- (void)setButtonInMainScene {
    UIBarButtonItem *addButton = [self _getAddButton];
    self.topItem.leftBarButtonItem = addButton;

    UIBarButtonItem *settingBtn = [self _getSettingButton];
    UIBarButtonItem *swapButton = [self _getSwapButton];
    self.topItem.rightBarButtonItems = @[ settingBtn, swapButton ];
}

- (void)deleteButtonInMainScene {
    self.topItem.leftBarButtonItem = nil;
    self.topItem.rightBarButtonItems = nil;
}

- (void)setButtonInSwapScene {
    UIBarButtonItem *closeButon = [self _getCloseButton];
    self.topItem.rightBarButtonItem = closeButon;
}

- (void)deleteButtonInSwapScene {
    self.topItem.rightBarButtonItem = nil;
}

//--------------------------------------------------------------//
#pragma mark -- Get Button --
//--------------------------------------------------------------//

- (UIBarButtonItem *)_getSettingButton {
    // Settingボタンを設置する
    UIBarButtonItem *settingButton =
        [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:kSettingIcon] style:UIBarButtonItemStylePlain target:nil action:nil];
    return settingButton;
}

- (UIBarButtonItem *)_getAddButton {
    // 項目追加ボタンを設置する
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:nil action:nil];
    return addButton;
}

- (UIBarButtonItem *)_getSwapButton {
    // 入れ替えボタンを設置する
    UIBarButtonItem *swapButton =
        [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:kSwapIcon] style:UIBarButtonItemStylePlain target:nil action:nil];
    return swapButton;
}

- (UIBarButtonItem *)_getCloseButton {
    // Xボタンを設置する
    UIBarButtonItem *closeButton =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:nil action:nil];
    return closeButton;
}

@end
