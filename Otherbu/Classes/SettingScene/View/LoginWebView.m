//
//  LoginWebView.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "LoginWebView.h"

@interface LoginWebView () {
}

@end

@implementation LoginWebView

//--------------------------------------------------------------//
#pragma mark -- initialize --
//--------------------------------------------------------------//

- (void)setupWithView:(UIView *)view {
    // 初期値設定
    self.delegate = self;
    self.scalesPageToFit = YES;  // Webページの大きさを自動的に画面にフィットさせる
}

//--------------------------------------------------------------//
#pragma mark -- UIWebViewDelegate --
//--------------------------------------------------------------//

- (void)webViewDidStartLoad:(UIWebView *)webview {
    // 読み込みが開始した直後に呼ばれる
    [self _updateStatusbar];
}

- (void)webViewDidFinishLoad:(UIWebView *)webview {
    // 読み込みが完了した直後に呼ばれる
    [self _updateStatusbar];
}

- (void)webView:(UIWebView *)webview didFailLoadWithError:(NSError *)error {
    // 読み込み中にエラーが発生したタイミングで呼ばれる
    [self _updateStatusbar];
}

- (void)_updateStatusbar {
    // ステータスバーのインジケータの更新
    [UIApplication sharedApplication].networkActivityIndicatorVisible = self.loading;
}


@end
