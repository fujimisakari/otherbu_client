//
//  PageTabView.m
//  Otherbu
//
//  Created by fujimisakari on 2015/03/14.
//  Copyright (c) 2015年 fujimisakari. All rights reserved.
//

#import "PageTabView.h"
#import "PageData.h"
#import "DataManager.h"
#import "ColorData.h"
#import "Constants.h"

@implementation PageTabView {
    PageData *_page;
}

+ (id)initWithFrame:(CGRect)rect {
    PageTabView *pageTab = [[PageTabView alloc] initWithFrame:rect];
    return pageTab;
}

/**
 pageラベル生成
*/
- (void)setUpWithPage:(PageData *)page {
    _page = page;

    // タイトル生成
    [self setTitle];

    // 背景色の設定
    [self setBackground];

    // 角丸にする
    [self setMaskLayerWithSectionType];
}

/**
 ラベルのタイトルを設定する
 */
- (void)setTitle {
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.text = _page.name;
    titleLbl.textColor = [[_page color] getSectionHeaderFontColor];
    titleLbl.font = [UIFont fontWithName:kDefaultFont size:16];
    titleLbl.backgroundColor = [UIColor clearColor];
    [titleLbl sizeToFit];
    CGFloat titleLabelOffsetX = (self.bounds.size.width - titleLbl.bounds.size.width) / 2;
    titleLbl.frame = CGRectMake(titleLabelOffsetX, self.bounds.origin.y, self.frame.size.width, self.frame.size.height);
    [self addSubview:titleLbl];
}

/**
 背景色(グラデーション)を設定する
 */
- (void)setBackground {
    //
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    gradient.colors = [[_page color] getGradientColorList];
    [self.layer insertSublayer:gradient atIndex:0];
}

/**
 角丸のmaskLayerを設定する
 */
- (void)setMaskLayerWithSectionType {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                         cornerRadii:CGSizeMake(6.0, 6.0)];

    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

@end
