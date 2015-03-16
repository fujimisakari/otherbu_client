//
//  MainViewController.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "SectionHeaderView.h"
#import "PageTabView.h"

@class MainScrollView, NavigationBar;

@interface MainViewController : UIViewController<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, SectionHeaderViewDelegate, PageTabDelegate>

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet MainScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIScrollView *tabScrollView;
@property (weak, nonatomic) IBOutlet UIView *tabFrameView;

@end

