//
//  SGHelpWebViewController.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "SGHelpWebViewController.h"
#import "HelpWebView.h"

@interface SGHelpWebViewController () {
}

@end

@implementation SGHelpWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // set Webview
    [_webView setupWithView:self.view];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    // 画面が表示され終ったらWebPageの読み込み
    [super viewDidAppear:animated];
    [_webView initLoad];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    // 画面を閉じるときにステータスバーのインジケータ確実にOFFにする
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
