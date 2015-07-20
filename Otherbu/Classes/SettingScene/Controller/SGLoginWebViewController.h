//
//  SGLoginViewController.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

// #import "ModalInterface.h"

// @class NavigationBar, CustomWebView, BookmarkData;
@class LoginWebView;

@interface SGLoginWebViewController : UIViewController<UIWebViewDelegate>
// @interface SGWebViewController : UIViewController<UIScrollViewDelegate, ModalInterface>

// @property(weak, nonatomic) IBOutlet NavigationBar *navigationBar;
@property(weak, nonatomic) IBOutlet LoginWebView *webView;
// @property(nonatomic) BookmarkData *bookmark;

@end
