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

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // setup NavigationBar
    [_navigationBar setup];

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
        [self configureView];
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
