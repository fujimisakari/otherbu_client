//
//  MainScrollView.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

@interface MainScrollView : UIScrollView

- (void)setupWithCGSize:(CGSize)cgSize delegate:(id<UIScrollViewDelegate>)delegate;
- (void)reloadTableData;
- (void)reloadTableDataByAnimation;
- (void)reloadTableDataWithAngleID:(int)angleId;

@end
