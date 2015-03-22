//
//  WebViewController.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

@class NavigationBar, CustomWebView, BookmarkData;

@interface WebViewController : UIViewController<UIScrollViewDelegate>

@property(weak, nonatomic) IBOutlet NavigationBar *navigationBar;
@property(weak, nonatomic) IBOutlet CustomWebView *webView;
@property(nonatomic) BookmarkData *bookmark;

- (void)setBookmark:(BookmarkData *)bookmark;

@end
