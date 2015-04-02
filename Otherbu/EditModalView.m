//
//  EditModalView.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "EditModalView.h"

@implementation EditModalView

//--------------------------------------------------------------//
#pragma mark -- initialize --
//--------------------------------------------------------------//

- (void)setup {
    // setup initialize value
    // self.viewbackgroundColor = [UIColor colorWithRed:0 green:0 blue:0.1 alpha:0.4];

    // self.translatesAutoresizingMaskIntoConstraints = YES;
    // //Viewのframe変更
    // self.frame = CGRectMake(0, 0, 100, 100);

    // 背景色
    self.backgroundColor = UIColor.blackColor;

    // 角丸にする
    self.layer.cornerRadius = 10.0f;
    self.layer.masksToBounds = YES;

    // 枠線
    self.layer.borderWidth = 2.0f;
    self.layer.borderColor = [[UIColor blueColor] CGColor];

    // TitleLabel生成
    [self setTitleLabel];

    // Name編集フィールド生成

    // Color選択View生成

    // 編集ボタン生成
    [self setButton];
}

- (void)setTitleLabel {
    UILabel *titleLabel = [[UILabel alloc] init];
    NSLog(@"%@", NSStringFromCGRect(self.frame));
    CGRect rect = CGRectMake(28, 20, 70.0f, 30.0f);
    titleLabel.frame = rect;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"編集";
    titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:titleLabel];
}

- (void)setButton {
    //ボタンの名前はnumButton
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelButton setTitle:@"キャンセル" forState:UIControlStateNormal];
    //ボタンの色と文字の色を決める
    // numButton.backgroundColor = [UIColor blackColor];
    // numButton.tintColor = [UIColor whiteColor];
}

@end
