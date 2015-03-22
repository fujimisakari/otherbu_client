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

@implementation WebViewController {
    UIToolbar *_toolbar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // setup NavigationBar
    [_navigationBar setup];
    [self closeButtontoLeft];

    // set Webview
    [_webView setupWithView:self.view];

    // open Web Page
    [self openWebPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
#pragma mark -- Private Method --
//--------------------------------------------------------------//

- (void)openWebPage {
    // Webを表示する
    NSURL *url = [NSURL URLWithString:_bookmark.url];
    NSURLRequest *urlReq = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:urlReq];
}

- (void)closeButtontoLeft {
    // NavigationBarにXボタンを設置する
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                         target:self
                                                                         action:@selector(closeWebView:)];
    _navigationBar.topItem.leftBarButtonItem = btn;
}

- (void)closeWebView:(UIButton *)sender {
    // WebViewのクローズ
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
