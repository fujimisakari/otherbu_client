//
//  ViewController.m
//  Otherbu
//
//  Created by fujimisakari on 2015/02/17.
//  Copyright (c) 2015年 fujimisakari. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

static const NSInteger kNumberOfPages = 3;
static const NSInteger kViewWidth = 375;
static const NSInteger kViewHeight = 460;

- (void)viewDidLoad {
    [super viewDidLoad];

    // 背景色を設定
    _pageControl.backgroundColor = [UIColor blackColor];

    // ページ数を設定
    _pageControl.numberOfPages = kNumberOfPages;

    // 現在のページを設定
    _pageControl.currentPage = 0;

    _scrollView.delegate = self;

    _scrollView.frame = self.view.bounds;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    // 横にページスクロールできるようにコンテンツの大きさを横長に設定
    _scrollView.contentSize = CGSizeMake(kViewWidth * kNumberOfPages, kViewHeight);
    // ページごとのスクロールにする
    _scrollView.pagingEnabled = YES;
    // スクロールバーを非表示にする
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    // ステータスバータップでトップにスクロールする機能をOFFにする
    _scrollView.scrollsToTop = NO;

    // スクロールビューに各画面をはりつけ
    for (int i = 0; i < kNumberOfPages; ++i) {
        MyViewController *myViewController = [MyViewController myViewControllerWithNumber:i];
        myViewController.view.frame = CGRectMake(kViewWidth * i, 0, kViewWidth, kViewHeight);
        [_scrollView addSubview:myViewController.view];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    // UIScrollViewのページ切替時イベント:UIPageControlの現在ページを切り替える処理
    _pageControl.currentPage = _scrollView.contentOffset.x / kViewWidth;

    // CGFloat pageWidth = scrollView.frame.size.width;
    // if ((NSInteger)fmod(scrollView.contentOffset.x , pageWidth) == 0) {
    //     // ページコントロールに現在のページを設定
    //     _pageControl.currentPage = scrollView.contentOffset.x / pageWidth;
    // }
}

@end
