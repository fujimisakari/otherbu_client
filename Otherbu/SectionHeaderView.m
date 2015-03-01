//
//  SectionHeaderView.m
//  Otherbu
//
//  Created by fujimisakari on 2015/02/17.
//  Copyright (c) 2015年 fujimisakari. All rights reserved.
//

#import "SectionHeaderView.h"
#import "CategoryData.h"
#import "ColorData.h"
#import "UIColor+Hex.h"

@implementation SectionHeaderView {
    UIImageView *_arrowImgView;
    UIImage *_downImg;
    UIImage *_rightImg;
    CGSize _downImgSize;
    CGSize _rightImgSize;
    CAShapeLayer *_maskLayerOfSectionOpen;
    CAShapeLayer *_maskLayerOfSectionClose;
    CategoryData *_categoryData;
    NSInteger _section;
    NSInteger _tag;
}

#pragma mark - initialization

// デフォルト設定で初期化
- (id)initWithCategory:(CategoryData *)categoryData frame:(CGRect)frame section:(NSInteger)section tag:(NSInteger)tag {
    self = [super initWithFrame:frame];
    if (self) {
        _categoryData = categoryData;
        _section = section;
        _tag = tag;
        [self setDefaultStyle];
        [self setTitle];
        [self switchDataByTapped];
        [self addTapGesture];
    }
    return self;
}

#pragma mark - Private Methods

/**
 セクションのスタイル設定
 */
- (void)setDefaultStyle {
    // 開閉画像作成
    _downImg = [UIImage imageNamed:@"downArrow"];
    _rightImg = [UIImage imageNamed:@"rightArrow"];
    _downImgSize = _downImg.size;
    _rightImgSize = _rightImg.size;
    _arrowImgView = [[UIImageView alloc] init];
    [self addSubview:_arrowImgView];

    // 背景色(グラデーション)
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    gradient.colors = [[_categoryData color] getGradientColorList];
    [self.layer insertSublayer:gradient atIndex:0];

    // 角丸
    [self setMaskLayerWithSectionType:YES];
    [self setMaskLayerWithSectionType:NO];
}

/**
 角丸のmaskLayerを設定する
 */
- (void)setMaskLayerWithSectionType:(BOOL)isOpenSection {
    UIBezierPath *maskPath;
    if (isOpenSection) {
        maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                         byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                               cornerRadii:CGSizeMake(12.0, 12.0)];
    } else {
        maskPath = [UIBezierPath
            bezierPathWithRoundedRect:self.bounds
                    byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight)
                          cornerRadii:CGSizeMake(12.0, 12.0)];
    }

    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    if (isOpenSection) {
        _maskLayerOfSectionOpen = maskLayer;
    } else {
        _maskLayerOfSectionClose = maskLayer;
    }
}

/**
 セクションのタイトルを設定する
 */
- (void)setTitle {
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.text = _categoryData.name;
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.backgroundColor = [UIColor clearColor];
    [titleLbl sizeToFit];
    CGSize lglSize = titleLbl.frame.size;
    titleLbl.frame = CGRectMake(50, 10, lglSize.width, lglSize.height);
    [self addSubview:titleLbl];
}

/**
 タップジェスチャを追加
 */
- (void)addTapGesture {
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sigleTapped)];
    [self addGestureRecognizer:singleTap];
}

/**
 シングルタップイベント
 */
- (void)sigleTapped {
    [self.delegate didSectionHeaderSingleTap:_section tag:_tag];
    [self switchDataByTapped];
}

/**
 タップ時のデータ切り替え
 */
- (void)switchDataByTapped {
    if (_categoryData.isOpenSection) {
        _arrowImgView.image = _downImg;
        _arrowImgView.frame = CGRectMake(20, 15, _downImgSize.width, _downImgSize.height);
        self.layer.mask = _maskLayerOfSectionOpen;
    } else {
        _arrowImgView.image = _rightImg;
        _arrowImgView.frame = CGRectMake(25, 12, _rightImgSize.width, _rightImgSize.height);
        self.layer.mask = _maskLayerOfSectionClose;
    }
}

@end
