//
//  WebViewController.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

@class NavigationBar, WebView, BookmarkData;

@interface WebViewController : UIViewController

@property(weak, nonatomic) IBOutlet NavigationBar *navigationBar;
@property(weak, nonatomic) IBOutlet UIWebView *webView;
@property(nonatomic) BookmarkData *bookmark;

- (void)setBookmark:(BookmarkData *)bookmark;

@end
