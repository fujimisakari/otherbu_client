//
//  PageTabLabel.m
//  Otherbu
//
//  Created by fujimisakari on 2015/03/14.
//  Copyright (c) 2015年 fujimisakari. All rights reserved.
//

#import "PageTabLabel.h"
#import "PageData.h"
#import "DataManager.h"
#import "ColorData.h"
#import "Constants.h"

@implementation PageTabLabel {
    PageData *_page;
}


+ (id)initWithFrame:(CGRect)rect {
    PageTabLabel *label = [[PageTabLabel alloc] initWithFrame:rect];
    return label;
}

/**
   pageTABラベル生成
*/
- (void)setUpWithPage:(PageData *)page {
    _page = page;

    UIFont *font = [UIFont fontWithName:kDefaultFont size:16];
    self.font = font;
    self.text = _page.name;
    self.textColor = [[page color] getSectionHeaderFontColor];
    self.numberOfLines = 1;
    self.textAlignment = NSTextAlignmentCenter;

    // 背景色(グラデーション)
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    gradient.colors = [[page color] getGradientColorList];
    [self.layer insertSublayer:gradient atIndex:0];

    // 角丸にする
    [self setMaskLayerWithSectionType];
}

/**
 角丸のmaskLayerを設定する
 */
- (void)setMaskLayerWithSectionType {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                         byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                               cornerRadii:CGSizeMake(12.0, 12.0)];

    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

@end
