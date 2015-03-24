//
//  SectionHeaderView.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "SectionHeaderView.h"
#import "CategoryData.h"
#import "ColorData.h"

@interface SectionHeaderView ()

@property(nonatomic) UIImageView  *arrowImgView;
@property(nonatomic) UIImage      *downImg;
@property(nonatomic) UIImage      *rightImg;
@property(nonatomic) CAShapeLayer *maskLayerOfSectionOpen;
@property(nonatomic) CAShapeLayer *maskLayerOfSectionClose;
@property(nonatomic) CGSize       downImgSize;
@property(nonatomic) CGSize       rightImgSize;
@property(nonatomic) CategoryData *categoryData;
@property(nonatomic) NSInteger    section;
@property(nonatomic) NSInteger    tagNumber;

@end

@implementation SectionHeaderView

//--------------------------------------------------------------//
#pragma mark -- initialize --
//--------------------------------------------------------------//

- (id)initWithCategory:(CategoryData *)categoryData
                 frame:(CGRect)frame
               section:(NSInteger)section
              delegate:(id<SectionHeaderViewDelegate>)delegate
             tagNumber:(NSInteger)tagNumber {
    self = [super initWithFrame:frame];
    if (self) {
        _categoryData = categoryData;
        _section = section;
        _tagNumber = tagNumber;
        self.delegate = delegate;
        [self _setDefaultStyle];
        [self _setTitle];
        [self _didSwitchDataByTapped];
        [self _setTapGesture];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    // セクションヘッダーのframeを変更するため、setFrameをOverWrideする
    frame.origin.x += kOffsetXOfTableCell;
    frame.size.width -= kAdaptWidthOfTableCell;
    [super setFrame:frame];
}


//--------------------------------------------------------------//
#pragma mark -- Set Methods --
//--------------------------------------------------------------//

- (void)_setDefaultStyle {
    // 開閉画像作成
    _downImg = [UIImage imageNamed:kDownArrowImageName];
    _rightImg = [UIImage imageNamed:kRightArrowImageName];
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
    [self _setMaskLayerWithSectionType:YES];
    [self _setMaskLayerWithSectionType:NO];
}

- (void)_setMaskLayerWithSectionType:(BOOL)isOpenSection {
    // 角丸のmaskLayerを設定する
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

- (void)_setTitle {
    // セクションのタイトルを設定する
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.text = _categoryData.name;
    titleLbl.textColor = [[_categoryData color] getSectionHeaderFontColor];
    titleLbl.font = [UIFont fontWithName:kDefaultFont size:kFontSizeOfSectionTitle];
    titleLbl.backgroundColor = [UIColor clearColor];
    [titleLbl sizeToFit];
    CGSize cgSize = titleLbl.frame.size;
    titleLbl.frame = CGRectMake(kOffsetXOfSectionTitle, kOffsetYOfSectionTitle, cgSize.width, cgSize.height);
    [self addSubview:titleLbl];
}

- (void)_setTapGesture {
    // タップジェスチャを追加
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_didSigleTapped)];
    [self addGestureRecognizer:singleTap];
}

//--------------------------------------------------------------//
#pragma mark -- Tapped Action Methods --
//--------------------------------------------------------------//

- (void)_didSigleTapped {
    // シングルタップイベント
    [self.delegate didSectionHeaderSingleTap:_section tagNumber:_tagNumber];
    [self _didSwitchDataByTapped];
}

- (void)_didSwitchDataByTapped {
    // タップ時のデータ切り替え
    if (_categoryData.isOpenSection) {
        _arrowImgView.image = _downImg;
        _arrowImgView.frame = CGRectMake(kOffsetXOfDownArrow, kOffsetYOfDownArrow, _downImgSize.width, _downImgSize.height);
        self.layer.mask = _maskLayerOfSectionOpen;
    } else {
        _arrowImgView.image = _rightImg;
        _arrowImgView.frame = CGRectMake(kOffsetXOfRightArrow, kOffsetYOfRightArrow, _rightImgSize.width, _rightImgSize.height);
        self.layer.mask = _maskLayerOfSectionClose;
    }
}

@end
