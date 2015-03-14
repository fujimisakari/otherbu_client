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
    // self.userInteractionEnabled = YES;

    // create innerTableView
    float _viewWidth = viewController.view.frame.size.width;
    float _viewHeight = viewController.view.frame.size.height - self.frame.origin.y;
    for (int i = 1; i < LastAngle; ++i) {
        CGRect rect = CGRectMake(_viewWidth * (i - 1), self.bounds.origin.y, _viewWidth, _viewHeight);
        InnerTableView *innerTableView = [InnerTableView initWithTag:i frame:rect];
        [innerTableView setUpWithViewController:viewController];
        [self addSubview:innerTableView];
    }

    // CGRect rect = CGRectMake(0, _viewHeight - 4, _viewWidth, 4);
    // UIView *tabFooterView = [[UIView alloc] initWithFrame:(CGRect)rect];
    // tabFooterView.backgroundColor = [UIColor blueColor];
    // [self addSubview:tabFooterView];

    // // スクロールビュー例文
    // CGRect cgRect = CGRectMake(0, _viewHeight - 44, _viewWidth, 40);
    // UIScrollView *sv = [[UIScrollView alloc] initWithFrame:cgRect];
    // sv.backgroundColor = [UIColor cyanColor];

    // //ラベル例文
    // UILabel *label = [[UILabel alloc] init];
    // label.frame = CGRectMake(10, 10, 70, 40);
    // label.backgroundColor = [UIColor yellowColor];
    // label.textColor = [UIColor blueColor];
    // label.font = [UIFont fontWithName:@"AppleGothic" size:12];
    // label.textAlignment = UITextAlignmentCenter;
    // label.text = @"hoge";
    // // [self addSubview:label];
    // [sv addSubview:label];
    // sv.contentSize = label.bounds.size * 2;
    // [self addSubview:sv];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // [super touchesEnded: touches withEvent: event];
    NSLog(@"hoooooooooooooo %d", self.dragging);
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    self.beginScrollOffsetY = location.y;
    NSLog(@"x:%f y:%f", location.x, location.y);

    if (self.dragging) {
        NSLog(@"oooooooooooooooo!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
        // シングルタッチの場合
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInView:self];
        self.beginScrollOffsetY = location.y;
        NSLog(@"x:%f y:%f", location.x, location.y);
    }
    // [super touchesEnded: touches withEvent: event];
    // [self.nextResponder touchesBegan: touches withEvent:event];

    // if (!self.dragging){
    //    [self.nextResponder touchesBegan: touches withEvent:event];
    //  }
    //  else{
    //    [super touchesEnded: touches withEvent: event];
    //  }
}

@end
