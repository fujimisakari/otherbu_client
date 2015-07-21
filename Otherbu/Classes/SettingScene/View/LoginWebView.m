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

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
            navigationType:(UIWebViewNavigationType)navigationType {
    // Webページのロード（表示）の開始前
    // リンクがクリックされたとき
    if (navigationType == UIWebViewNavigationTypeLinkClicked ||
        navigationType == UIWebViewNavigationTypeOther) {

        NSString *url = [[request URL] absoluteString];
        if ([self _isRequestCheck:url]) {
            NSString *urlString = [NSString stringWithFormat:@"%@client/", url];
            NSURL *loadURL = [NSURL URLWithString:urlString];
            NSURLRequest *urlReq = [NSURLRequest requestWithURL:loadURL];
            [self loadRequest:urlReq];
            return NO;
        }
    }
    return YES;
}

- (BOOL)_isRequestCheck:(NSString *)url {
    NSString *facebookUrlString = @"/oauth/facebook/";
    NSString *twitterUrlString = @"/oauth/twitter/";
    if ([url rangeOfString:@"client"].location != NSNotFound) {
        return NO;
    } else if ([url rangeOfString:facebookUrlString].location != NSNotFound) {
        return YES;
    } else if ([url rangeOfString:twitterUrlString].location != NSNotFound) {
        return YES;
    }
    return NO;
}

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
