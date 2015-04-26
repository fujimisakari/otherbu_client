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
    UIBarButtonItem *searchButton = [self _getSearchButton];
    self.topItem.leftBarButtonItems = @[ addButton, searchButton ];

    UIBarButtonItem *settingBtn = [self _getSettingButton];
    UIBarButtonItem *swapButton = [self _getSwapButton];
    self.topItem.rightBarButtonItems = @[ settingBtn, swapButton ];
}

- (void)setButtonInWebViewScene {
    UIBarButtonItem *addButton = [self _getAddButton];
    self.topItem.leftBarButtonItem = addButton;

    UIBarButtonItem *closeButon = [self _getCloseButton];
    self.topItem.rightBarButtonItem = closeButon;
}

- (void)setButtonInSwapScene {
    UIBarButtonItem *closeButon = [self _getCloseButton];
    self.topItem.rightBarButtonItem = closeButon;
}

- (void)deleteButtonInMainScene {
    self.topItem.leftBarButtonItems = nil;
    self.topItem.rightBarButtonItems = nil;
}

- (void)deleteButtonInWebViewScene {
    self.topItem.leftBarButtonItem = nil;
    self.topItem.rightBarButtonItem = nil;
}

- (void)deleteButtonInSwapScene {
    self.topItem.rightBarButtonItem = nil;
}

//--------------------------------------------------------------//
#pragma mark -- Get Button --
//--------------------------------------------------------------//

- (UIBarButtonItem *)_getSettingButton {
    // Settingボタンを設置する
    UIBarButtonItem *button =
        [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:kSettingIcon] style:UIBarButtonItemStylePlain target:nil action:nil];
    return button;
}

- (UIBarButtonItem *)_getSearchButton {
    // 検索ボタンを設置する
    UIBarButtonItem *button =
        [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:kSearchIcon] style:UIBarButtonItemStylePlain target:nil action:nil];
    return button;
}

- (UIBarButtonItem *)_getAddButton {
    // 項目追加ボタンを設置する
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:nil action:nil];
    return button;
}

- (UIBarButtonItem *)_getSwapButton {
    // 入れ替えボタンを設置する
    UIBarButtonItem *button =
        [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:kSwapIcon] style:UIBarButtonItemStylePlain target:nil action:nil];
    return button;
}

- (UIBarButtonItem *)_getCloseButton {
    // Xボタンを設置する
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:nil action:nil];
    return button;
}

@end
