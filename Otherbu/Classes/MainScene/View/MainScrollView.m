//
//  MainScrollView.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "MainScrollView.h"
#import "InnerTableView.h"

@implementation MainScrollView

//--------------------------------------------------------------//
#pragma mark -- initialize --
//--------------------------------------------------------------//

- (void)setupWithCGSize:(CGSize)cgSize delegate:(id<UIScrollViewDelegate>)delegate {
    self.delegate = delegate;
    self.pagingEnabled = YES;                  // ページごとのスクロールにする
    self.showsHorizontalScrollIndicator = NO;  // 横スクロールバーを非表示にする
    self.showsVerticalScrollIndicator = NO;    // 縦スクロールバーを非表示にする
    self.scrollsToTop = NO;                    // ステータスバータップでトップにスクロールする機能をOFFにする
    self.contentSize = cgSize;  // 横にページスクロールできるようにコンテンツの大きさを横長に設定

    // create innerTableView
    float _viewWidth = self.superview.frame.size.width;
    float _viewHeight = self.superview.frame.size.height - self.frame.origin.y;
    for (int i = 1; i < LastAngle; ++i) {
        CGRect rect = CGRectMake(_viewWidth * (i - 1), self.bounds.origin.y, _viewWidth, _viewHeight);
        InnerTableView *innerTableView = [[InnerTableView alloc] initWithTag:i frame:rect];
        [innerTableView setUp];
        innerTableView.delegate = (id<UITableViewDelegate>)delegate;
        innerTableView.dataSource = (id<UITableViewDataSource>)delegate;
        [self addSubview:innerTableView];
    }
}

//--------------------------------------------------------------//
#pragma mark -- Public Method --
//--------------------------------------------------------------//

- (void)scrollToTop {
    for (int i = 1; i < LastAngle; ++i) {
        InnerTableView *tableView = (InnerTableView *)[self viewWithTag:i];
        [tableView setContentOffset:CGPointMake(0.0, 0 - (int)kMarginTopOfTableFrame)];
    }
}

- (void)reloadTableData {
    // 全アングルのTableデータの再読み込み
    for (int i = 1; i < LastAngle; ++i) {
        InnerTableView *tableView = (InnerTableView *)[self viewWithTag:i];
        [tableView reloadData];
    }
}

- (void)reloadTableDataByAnimation {
    // アニメーション付きで全アングルのTableデータの再読み込み
    [UIView transitionWithView: self duration: 0.35f options: UIViewAnimationOptionTransitionFlipFromLeft
        animations: ^(void) {
            for (int i = 1; i < LastAngle; ++i) {
                InnerTableView *tableView = (InnerTableView *)[self viewWithTag:i];
                [tableView reloadData];
            }
        }
        completion: ^(BOOL isFinished) {
        }
    ];
}

- (void)reloadTableDataWithAngleID:(int)angleId {
    // ピンポイントでTableデータの再読み込み
    for (int i = 1; i < LastAngle; ++i) {
        if (i == angleId) {
            InnerTableView *tableView = (InnerTableView *)[self viewWithTag:i];
            [tableView reloadData];
        }
    }
}

@end
