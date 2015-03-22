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

    // set Webview
    [_webView setupWithView:self.view];

    [self closeButtontoLeft];

    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setBookmark:(BookmarkData *)bookmark {
    if (bookmark != _bookmark) {
        _bookmark = bookmark;
    }
}

- (void)configureView {
    // Webを表示する
    NSURL *url = [NSURL URLWithString:_bookmark.url];
    NSURLRequest *urlReq = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:urlReq];
}

- (void)closeWebViewController:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)closeButtontoLeft {
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                         target:self
                                                                         action:@selector(closeWebViewController:)];
    _navigationBar.topItem.leftBarButtonItem = btn;
}

@end
