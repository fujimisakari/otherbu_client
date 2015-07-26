//
//  LoginWebView.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "LoginWebView.h"
#import "UserData.h"

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

- (void)initLoad {
    // 初回ページ
    NSURL *url;
    #ifdef DEBUG
        url = [NSURL URLWithString:@"http://dev.otherbu.com/login/client/"];
    #else
        url = [NSURL URLWithString:@"http://otherbu.com/login/client/"];
    #endif
    NSURLRequest *urlReq = [NSURLRequest requestWithURL:url];
    [self loadRequest:urlReq];
}

//--------------------------------------------------------------//
#pragma mark -- UIWebViewDelegate --
//--------------------------------------------------------------//

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
            navigationType:(UIWebViewNavigationType)navigationType {
    // Webページのロード（表示）の開始前

    // リンクがクリックされたとき
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSURL *url = [request URL];
        NSString *requestURL = [self _getRequestURL:url];
        if (requestURL) {
            NSURL *loadURL = [NSURL URLWithString:requestURL];
            NSURLRequest *urlReq = [NSURLRequest requestWithURL:loadURL];
            [self loadRequest:urlReq];
            return NO;
        }
    }
    return YES;
}

- (NSString *)_getRequestURL:(NSURL *)_url {
    NSString *url = [_url absoluteString];
    NSString *facebookUrlString = @"/oauth/facebook/";
    NSString *twitterUrlString = @"/oauth/twitter/";
    NSString *domain = [NSString stringWithFormat:@"%@://%@", [_url scheme], [_url host]];
    if ([url rangeOfString:@"client"].location != NSNotFound) {
        return nil;
    } else if ([url rangeOfString:facebookUrlString].location != NSNotFound) {
        return [NSString stringWithFormat:@"%@/oauth/client/facebook/", domain];
    } else if ([url rangeOfString:twitterUrlString].location != NSNotFound) {
        return [NSString stringWithFormat:@"%@/oauth/client/twitter/", domain];
    }
    return nil;
}

- (void)webViewDidStartLoad:(UIWebView *)webview {
    // 読み込みが開始した直後に呼ばれる
    [self _updateStatusbar];
}

- (void)webViewDidFinishLoad:(UIWebView *)webview {
    // 読み込みが完了した直後に呼ばれる
    [self _updateStatusbar];

    // ログイン完了ページの場合
    NSString* url = [webview stringByEvaluatingJavaScriptFromString:@"document.URL"];
    if ([url rangeOfString:@"/oauth/completion/"].location != NSNotFound) {
        UserData *user = [[DataManager sharedManager] getUser];

        // ユーザー情報更新処理
        NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
        NSString *_id = [webview stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"id\").value;"];
        userDict[@"id"] = [NSNumber numberWithInt:[_id intValue]];
        userDict[@"type"] = [webview stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"type\").value;"];
        userDict[@"type_id"] = [webview stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"type_id\").value;"];
        userDict[@"page_id"] = [NSNumber numberWithInt:[user.pageId intValue]];
        [user updateWithDictionary:userDict];

        // データ保存(レスポンスデータなので同期登録は不要)
        [[DataManager sharedManager] save:SAVE_USER];

        LOG(@"id - %@", userDict[@"id"]);
        LOG(@"type - %@", userDict[@"type"]);
        LOG(@"type_id - %@", userDict[@"type_id"]);
        LOG(@"comp");
    }
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
