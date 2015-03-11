//
//  MainViewController.h
//  Otherbu
//
//  Created by fujimisakari on 2015/02/17.
//  Copyright (c) 2015年 fujimisakari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionHeaderView.h"

@class ScrollView, NavigationBar;

@interface MainViewController : UIViewController<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, SectionHeaderViewDelegate>

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet ScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NavigationBar *navigationBar;

@end

