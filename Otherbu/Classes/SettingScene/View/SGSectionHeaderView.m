//
//  SGSectionHeaderView.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "SGSectionHeaderView.h"

@implementation SGSectionHeaderView

//--------------------------------------------------------------//
#pragma mark -- initialize --
//--------------------------------------------------------------//

- (void)setup:(NSString *)sectionName {
    // 背景View設定
    [self _createWhiteRoundedCornerView];

    // タイトル設定
    [self _setTitle:sectionName];
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

- (void)_createWhiteRoundedCornerView {
    // セルの背景Viewを生成
    UIView *whiteRoundedCornerView = [[UIView alloc] init];
    whiteRoundedCornerView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    whiteRoundedCornerView.backgroundColor = [UIColor colorWithWhite:0.65 alpha:0.7];
    whiteRoundedCornerView.layer.masksToBounds = NO;
    whiteRoundedCornerView.layer.cornerRadius = 3.0;
    // whiteRoundedCornerView.layer.shadowOffset = CGSizeMake(-1, 1);
    // whiteRoundedCornerView.layer.shadowOpacity = 0.5;
    [self addSubview:whiteRoundedCornerView];
}

- (void)_setTitle:(NSString *)sectionName {
    // セクションのタイトルを設定する
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.text = sectionName;
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.font = [UIFont fontWithName:kDefaultFont size:kFontSizeOfSettingDesc];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    [titleLbl sizeToFit];
    CGSize cgSize = titleLbl.frame.size;
    titleLbl.frame = CGRectMake(0, 0, cgSize.width, cgSize.height);
    titleLbl.center = CGPointMake(self.center.x - kOffsetXOfTableCell, self.center.y);
    [self addSubview:titleLbl];
}

@end
