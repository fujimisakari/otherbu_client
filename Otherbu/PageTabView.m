//
//  PageTabView.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "PageTabView.h"
#import "PageData.h"
#import "DataManager.h"
#import "ColorData.h"

@implementation PageTabView {
    PageData *_page;
    UIView *_activeTab;
    UIView *_stanbyTab;
    BOOL _isActive;
}

//--------------------------------------------------------------//
#pragma mark -- initialize --
//--------------------------------------------------------------//

+ (id)initWithFrame:(CGRect)rect {
    PageTabView *pageTab = [[PageTabView alloc] initWithFrame:rect];
    return pageTab;
}

+ (CGSize)getTextSizeOfPageViewWithString:(NSString *)string {
    // PageView用のtextSizeを取得
    CGSize textSize =
        [string boundingRectWithSize:CGSizeMake(200, 400)
                             options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                          attributes:[NSDictionary dictionaryWithObject:[UIFont fontWithName:kDefaultFont size:kFontSizeOfPageTab]
                                                                 forKey:NSFontAttributeName]
                             context:nil].size;
    CGSize text = CGSizeMake(textSize.width + kAdaptWidthOfPageTab, kHeightOfPageTab);
    return text;
}

- (void)setUpWithPage:(PageData *)page delegate:(id<PageTabDelegate>)delegate {
    // タップされている、されていない場合のTabVeiwを切り換え用に用意しておく
    CGFloat offsetX = 0;
    CGFloat offsetY = self.frame.origin.y;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGRect activeRect = CGRectMake(offsetX, offsetY, width, height);
    CGRect stanbyRect = CGRectMake(offsetX, offsetY + kAdaptHeightOfPageTab, width, height - kAdaptHeightOfPageTab);
    _activeTab = [[UIView alloc] initWithFrame:activeRect];
    _stanbyTab = [[UIView alloc] initWithFrame:stanbyRect];
    _activeTab.hidden = YES;
    _stanbyTab.hidden = NO;
    _isActive = NO;
    _page = page;
    self.backgroundColor = [UIColor clearColor];
    self.delegate = delegate;
    [self addSubview:_activeTab];
    [self addSubview:_stanbyTab];

    // タイトル生成
    [self setTitle:_activeTab];
    [self setTitle:_stanbyTab];

    // 背景色の設定
    [self setBackground:_activeTab];
    [self setBackground:_stanbyTab];

    // 角丸にする
    [self setMaskLayerWithSectionType:_activeTab];
    [self setMaskLayerWithSectionType:_stanbyTab];

    // タップジェスチャーを設定
    [self addTapGesture];
}

//--------------------------------------------------------------//
#pragma mark -- Public Method --
//--------------------------------------------------------------//

- (void)switchTabStatus {
    // Tabの状態の切り換え
    if (_isActive) {
        _activeTab.hidden = YES;
        _stanbyTab.hidden = NO;
        _isActive = NO;
    } else {
        _activeTab.hidden = NO;
        _stanbyTab.hidden = YES;
        _isActive = YES;
    }
}

//--------------------------------------------------------------//
#pragma mark -- Private Method --
//--------------------------------------------------------------//

- (void)setTitle:(UIView *)view {
    // ラベルのタイトルを設定する
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.text = _page.name;
    titleLbl.textColor = [[_page color] getSectionHeaderFontColor];
    titleLbl.font = [UIFont fontWithName:kDefaultFont size:16];
    titleLbl.backgroundColor = [UIColor clearColor];
    [titleLbl sizeToFit];
    CGFloat titleLabelOffsetX = (view.bounds.size.width - titleLbl.bounds.size.width) / 2;
    titleLbl.frame = CGRectMake(titleLabelOffsetX, view.bounds.origin.y, view.frame.size.width, view.frame.size.height);
    [view addSubview:titleLbl];
}

- (void)setBackground:(UIView *)view {
    // 背景色(グラデーション)を設定する
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.colors = [[_page color] getGradientColorList];
    [view.layer insertSublayer:gradient atIndex:0];
}

- (void)setMaskLayerWithSectionType:(UIView *)view {
    // 角丸のmaskLayerを設定する
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                                   byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                         cornerRadii:CGSizeMake(5.0, 5.0)];

    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

- (void)addTapGesture {
    // タップジェスチャを追加
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sigleTapped)];
    [self addGestureRecognizer:singleTap];
}

- (void)sigleTapped {
    // シングルタップイベント
    [self.delegate didPageTabSingleTap:_page pageTabView:self];
}

@end
