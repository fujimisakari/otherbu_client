//
//  WebViewController.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "WebViewController.h"
#import "ModalBKViewController.h"
#import "NavigationBar.h"
#import "BookmarkData.h"
#import "CustomWebView.h"

@interface WebViewController () {
    id<DataInterface> currentWebPage;
}

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // setup NavigationBar
    [_navigationBar setup];
    [self _closeButtonToLeft];
    [self _addButtonToRight];

    // set Webview
    [_webView setupWithView:self.view];
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
#pragma mark-- Setting Button--
//--------------------------------------------------------------//

- (void)_closeButtonToLeft {
    // NavigationBarにXボタンを設置する
    UIBarButtonItem *btn =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(_closeWebView:)];
    _navigationBar.topItem.leftBarButtonItem = btn;
}

- (void)_addButtonToRight {
    // NavigationBarに項目追加ボタンを設置する
    UIBarButtonItem *btn =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(_addBookmark:)];
    _navigationBar.topItem.rightBarButtonItem = btn;
}

//--------------------------------------------------------------//
#pragma mark-- Navi Button Event--
//--------------------------------------------------------------//

- (void)_closeWebView:(UIButton *)sender {
    // WebViewを閉じる
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)_addBookmark:(UIButton *)sender {
    // 現在表示しているページの名前とURLを入れてBookmark追加画面へ遷移する
    NSString *name = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSString *url = [_webView stringByEvaluatingJavaScriptFromString:@"document.URL"];

    currentWebPage = [BookmarkData alloc];
    [currentWebPage iSetName:name];
    [currentWebPage iSetUrl:url];

    ModalBKViewController *modalBKViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ModalBKViewController"];
    modalBKViewController.delegate = self;
    modalBKViewController.editItem = currentWebPage;
    [self presentViewController:modalBKViewController animated:YES completion:nil];
}

- (void)returnActionOfModal:(NSInteger)menuId{};

@end
