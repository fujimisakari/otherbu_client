//
//  SGLoginViewController.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

@class LoginWebView;

@interface SGLoginWebViewController : UIViewController<UIWebViewDelegate>

@property(weak, nonatomic) IBOutlet LoginWebView *webView;

@end
