//
//  SectionHeaderView.m
//  Otherbu
//
//  Created by fujimisakari on 2015/02/17.
//  Copyright (c) 2015年 fujimisakari. All rights reserved.
//

#import "SectionHeaderView.h"
#import "CategoryData.h"

@implementation SectionHeaderView {
    UIImageView *_arrowImgView;
    UIImage *_downImg;
    UIImage *_rightImg;
    CGSize _downImgSize;
    CGSize _rightImgSize;
    CategoryData *_categoryData;
    NSInteger _section;
    NSInteger _tag;
}

#pragma mark - initialization

// デフォルト設定で初期化
- (id)initWithCategory:(CategoryData *)categoryData frame:(CGRect)frame  section:(NSInteger)section tag:(NSInteger)tag;
    self = [super initWithFrame:frame];
    if (self) {
        _categoryData = categoryData;
        _section = section;
        _tag = tag;
        [self setDefaultStyle];
        [self switchArrowImg];
        [self addTapGesture];
        [self setTitle];
    }
    return self;
}

#pragma mark - Private Methods

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

    // // レイヤーの作成
    // CAGradientLayer *gradient = [CAGradientLayer layer];
    // // レイヤーサイズをビューのサイズをそろえる
    // gradient.frame = self.bounds;
    // // 開始色と終了色を設定
    // gradient.colors = @[
    //     // 開始色
    //     (id)[UIColor colorWithRed:.87 green:.68 blue:.27 alpha:1].CGColor,
    //     // 終了色
    //     (id)[UIColor colorWithRed:.89 green:.54 blue:.72 alpha:1].CGColor
    // ];
    // // レイヤーを追加
    // [self.layer insertSublayer:gradient atIndex:0];

    // 背景色（グラデーション）
    CAGradientLayer *pageGradient = [CAGradientLayer layer];
    pageGradient.frame = self.frame;
    pageGradient.colors =
    [NSArray arrayWithObjects:
     (id)[UIColor colorWithRed:0.26 green:1.29 blue:2.36 alpha:1.0].CGColor,
     (id)[UIColor colorWithRed:0.52 green:0.25 blue:1.32 alpha:1.0].CGColor,
     nil];
    [self.layer insertSublayer:pageGradient atIndex:0];

    self.backgroundColor = [UIColor darkGrayColor];

    //角丸
    // self.layer.cornerRadius = 10.0f;
    self.layer.cornerRadius = 5.0;
    self.layer.masksToBounds = YES;
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
    [self switchArrowImg];
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
