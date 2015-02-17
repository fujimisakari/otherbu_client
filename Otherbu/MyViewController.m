//
//  MyViewController.m
//  Otherbu
//
//  Created by fujimisakari on 2015/02/17.
//  Copyright (c) 2015年 fujimisakari. All rights reserved.
//

#import "MyViewController.h"

@implementation MyViewController

@synthesize number = number_;

// 数値を設定してMyViewControllerのインスタンスを取得するクラスメソッド
+ (MyViewController *)myViewControllerWithNumber:(NSInteger)number {
    MyViewController *myViewController = [[MyViewController alloc] init];
    myViewController.number = number;
    return myViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *label = [[UILabel alloc] init];
    label.frame = self.view.bounds;
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    label.backgroundColor = (self.number % 2) ? [UIColor blackColor] : [UIColor whiteColor];
    label.textColor = !(self.number % 2) ? [UIColor blackColor] : [UIColor whiteColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:128];
    label.text = [NSString stringWithFormat:@"%ld", self.number];
    [self.view addSubview:label];
}

@end
