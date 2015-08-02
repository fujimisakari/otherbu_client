//
//  SGHelpWebViewController.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

@class HelpWebView;

@interface SGHelpWebViewController : UIViewController<UIWebViewDelegate>

@property(weak, nonatomic) IBOutlet HelpWebView *webView;

@end
