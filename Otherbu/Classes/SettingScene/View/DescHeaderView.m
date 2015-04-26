//
//  DescHeaderView.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "DescHeaderView.h"

@interface DescHeaderView () {
   UIView *_labelView;
}

@end

@implementation DescHeaderView

- (void)setupWithCGSize:(CGSize)size descMessage:(NSString *)descMessage {

    self.frame = CGRectMake(kOffsetXOfTableCell, 0, size.width, size.height);

    // 下地となるViewを生成
    CGRect labelFrame = CGRectMake(kOffsetXOfTableCell, kMarginOfSettingDesc, self.frame.size.width, kHeightOfSettingDesc);
    _labelView = [[UIView alloc] initWithFrame:labelFrame];
    [self addSubview:_labelView];

    // 背景の設定
    [self _setBackgroundView];

    // 文言の設定
    [self _setLabel:descMessage];
}

- (void)_setBackgroundView {
    // DescHeaderの背景Viewを生成
    UIView *background = [[UIView alloc] init];
    background.frame = CGRectMake(0, 0, _labelView.frame.size.width, _labelView.frame.size.height);
    background.backgroundColor = [UIColor colorWithWhite:0.65 alpha:0.7];
    background.layer.masksToBounds = NO;
    background.layer.cornerRadius = 3.0;
    [_labelView addSubview:background];
}

- (void)_setLabel:(NSString *)descMessage {
    // DescHeaderのラベルを生成
    UILabel *descLable = [[UILabel alloc] init];
    descLable.text = descMessage;
    descLable.textColor = [UIColor whiteColor];
    descLable.backgroundColor = [UIColor clearColor];
    descLable.font = [UIFont fontWithName:kDefaultFont size:kFontSizeOfSettingDesc];
    descLable.textAlignment = NSTextAlignmentCenter;
    [descLable sizeToFit];
    CGSize cgSize = descLable.frame.size;
    descLable.frame = CGRectMake(0, 0, cgSize.width, cgSize.height);
    descLable.center = CGPointMake(_labelView.center.x - kOffsetXOfTableCell, _labelView.frame.size.height / 2);
    [_labelView addSubview:descLable];
}

@end
