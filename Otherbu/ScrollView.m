//
//  ScrollView.m
//  Otherbu
//
//  Created by fujimisakari on 2015/03/11.
//  Copyright (c) 2015年 fujimisakari. All rights reserved.
//

#import "ScrollView.h"
#import "InnerTableView.h"
#import "MainViewController.h"
#import "PageData.h"

@implementation ScrollView

- (void)setupWithCGSize:(CGSize)cgSize viewController:(MainViewController *)viewController {
    self.delegate = (id)viewController;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.pagingEnabled = YES;                  // ページごとのスクロールにする
    self.showsHorizontalScrollIndicator = NO;  // 横スクロールバーを非表示にする
    self.showsVerticalScrollIndicator = NO;    // 縦スクロールバーを非表示にする
    self.scrollsToTop = NO;                    // ステータスバータップでトップにスクロールする機能をOFFにする
    self.contentSize = cgSize;  // 横にページスクロールできるようにコンテンツの大きさを横長に設定

    // create innerTableView
    float _viewWidth = viewController.view.frame.size.width;
    float _viewHeight = viewController.view.frame.size.height - self.frame.origin.y;
    for (int i = 1; i < LastAngle; ++i) {
        CGRect rect = CGRectMake(_viewWidth * (i - 1), self.bounds.origin.y, _viewWidth, _viewHeight);
        InnerTableView *innerTableView = [InnerTableView initWithTag:i frame:rect];
        [innerTableView setUpWithViewController:viewController];
        [self addSubview:innerTableView];
    }
}

@end
