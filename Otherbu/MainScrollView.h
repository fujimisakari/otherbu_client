//
//  MainScrollView.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

@class MainViewController;

@interface MainScrollView : UIScrollView

- (void)setupWithCGSize:(CGSize)cgSize viewController:(MainViewController *)viewController;
- (void)reloadTableData;

@end
