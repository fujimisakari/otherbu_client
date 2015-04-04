//
//  EditModalViewController.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "EditModalViewController.h"
#import "EditModalView.h"

@interface EditModalViewController ()

@end

@implementation EditModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    LOG_SIZE(self.view.frame.size);

    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0.1 alpha:0.4];

    // [_editModalView setup];

    // self.view.layer.shouldRasterize = YES;  //レイヤーをラスタライズする
    // self.view.layer.rasterizationScale = 0.2;  //ラスタライズ時の縮小率
    // self.view.layer.minificationFilter = kCAFilterTrilinear;  //縮小時のフィルタ種類

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIModalPresentationStyle)modalPresentationStyle {
    return UIModalPresentationOverCurrentContext;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
