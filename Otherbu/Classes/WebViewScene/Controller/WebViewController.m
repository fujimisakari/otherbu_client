//
//  WebViewController.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "WebViewController.h"
#import "NavigationBar.h"
#import "BookmarkData.h"
#import "CustomWebView.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // setup NavigationBar
    [_navigationBar setup];
    [self _closeButtontoLeft];

    // set Webview
    [_webView setupWithView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    // 画面が表示され終ったらWebPageの読み込み
    [super viewDidAppear:animated];
    NSURL *url = [NSURL URLWithString:_bookmark.url];
    NSURLRequest *urlReq = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:urlReq];
}

- (void)viewWillDisappear:(BOOL)animated {
    // 画面を閉じるときにステータスバーのインジケータ確実にOFFにする
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

//--------------------------------------------------------------//
#pragma mark -- Public Method --
//--------------------------------------------------------------//

- (void)setBookmark:(BookmarkData *)bookmark {
    if (bookmark != _bookmark) {
        _bookmark = bookmark;
    }
}

//--------------------------------------------------------------//
#pragma mark -- Close Button --
//--------------------------------------------------------------//

- (void)_closeButtontoLeft {
    // NavigationBarにXボタンを設置する
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                         target:self
                                                                         action:@selector(_closeWebView:)];
    _navigationBar.topItem.leftBarButtonItem = btn;
}

- (void)_closeWebView:(UIButton *)sender {
    // WebViewのクローズ
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
