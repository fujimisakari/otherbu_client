//
//  HelpWebView.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

@interface HelpWebView : UIWebView<UIScrollViewDelegate, UIWebViewDelegate>

- (void)setupWithView:(UIView *)view;
- (void)initLoad;

@end
