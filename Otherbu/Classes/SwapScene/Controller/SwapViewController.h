//
//  SwapViewController.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

@class PageData, NavigationBar;

@interface SwapViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property(weak, nonatomic) IBOutlet NavigationBar *navigationBar;
@property(nonatomic) PageData *page;

@end
