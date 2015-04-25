//
//  ModalPageViewController.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "ModalInterface.h"

@class PageData, NavigationBar;

@interface ModalPageViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property(weak, nonatomic) IBOutlet NavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UINavigationBar *aa;
@property(weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic, weak) id<ModalInterface> delegate;

@property(nonatomic) PageData *page;

@end
