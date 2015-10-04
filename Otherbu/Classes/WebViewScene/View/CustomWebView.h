//
//  CustomWebView.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

@interface CustomWebView : UIWebView<UIScrollViewDelegate, UIWebViewDelegate>

- (void)setupWithView:(UIViewController *)viewController;

@end
