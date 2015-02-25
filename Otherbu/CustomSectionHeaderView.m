//
//  CustomSectionHeaderView.m
//  Otherbu
//
//  Created by fujimisakari on 2015/02/17.
//  Copyright (c) 2015年 fujimisakari. All rights reserved.
//

#import "CustomSectionHeaderView.h"
#import "CategoryData.h"

@implementation CustomSectionHeaderView {
    UIImageView *_arrowImgView;
    UIImage *_downImg;
    UIImage *_rightImg;
    CGSize _downImgSize;
    CGSize _rightImgSize;
    CategoryData *_categoryData;
    NSInteger _section;
    NSNumber *_angleNumber;
    NSInteger _tag;
}

#pragma mark - initialization

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// デフォルト設定で初期化
- (id)initWithCategory:(CategoryData *)categoryData section:(NSInteger)section angle:(NSNumber *)angleNumber tag:(NSInteger)tag {
    self = [super init];
    if (self) {
        _categoryData = categoryData;
        _section = section;
        _angleNumber = angleNumber;
        _tag = tag;
        [self setDefaultStyle];
        [self switchArrowImg];
        [self addTapGesture];
        [self setTitle];
    }
    return self;
}

#pragma mark - Public Methods

// セクションのタイトルを設定する
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

#pragma mark - Private Methods

/**
 デフォルトのスタイル設定
 */
- (void)setDefaultStyle {
    _downImg = [UIImage imageNamed:@"downArrow"];
    _rightImg = [UIImage imageNamed:@"rightArrow"];
    _downImgSize = _downImg.size;
    _rightImgSize = _rightImg.size;

    _arrowImgView = [[UIImageView alloc] init];

    self.backgroundColor = [UIColor blackColor];
    [self addSubview:_arrowImgView];
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
    [self switchArrowImg];
    [self.delegate didSectionHeaderSingleTap:_section angle:_angleNumber tag:_tag];
}

/**
 矢印画像を切り替える
 */
- (void)switchArrowImg {
    if (_categoryData.isOpenSection) {
        _arrowImgView.image = _downImg;
        _arrowImgView.frame = CGRectMake(20, 15, _downImgSize.width, _downImgSize.height);
    } else {
        _arrowImgView.image = _rightImg;
        _arrowImgView.frame = CGRectMake(25, 12, _rightImgSize.width, _rightImgSize.height);
    }
}

@end
