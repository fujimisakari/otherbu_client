//
//  EditModalBookmarkView.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "EditModalBookmarkView.h"

@implementation EditModalBookmarkView

//--------------------------------------------------------------//
#pragma mark -- Create Methods --
//--------------------------------------------------------------//

- (void)_bulkCreate {
    int space = 10;
    int startY = 10;
    int totalTitleHeight = startY + kCommonHeightOfEditModal + space;  // 画面上部からメニュータイトル名までの高さ
    int totalButtonHeight = space + kCommonHeightOfEditModal + space;  // 画面下部から編集ボタンまでの高さ
    int availableHeight = self.frame.size.height - (totalTitleHeight + totalButtonHeight);
    int restHeight = availableHeight - (kViewHeightOfColorPalette + kCommonHeightOfEditModal + kCommonHeightOfEditModal);
    int margin = restHeight / 2;

    // TitleLabel生成
    CGRect titleRect = CGRectMake(0, startY + 10, self.frame.size.width, kCommonHeightOfEditModal);
    [self setTitleLabel:titleRect];

    // NameLabel生成
    int textFieldLabelY = totalTitleHeight + margin / 3;
    CGRect textFieldLabelRect = CGRectMake(kCommonAdaptWidthOfEditModal, textFieldLabelY, kLabelWidthOfEditModal, kCommonHeightOfEditModal);
    [self setFieldLabel:textFieldLabelRect label:@"Name :"];

    // TextField生成
    int textFieldY = textFieldLabelY + kCommonHeightOfEditModal + space;
    float fwidth = self.frame.size.width - (kAdaptButtonWidthOfEditModal * 2);
    CGRect textFieldRect = CGRectMake(kAdaptWidthOfEditModal, textFieldY, fwidth, kCommonHeightOfEditModal);
    // [self setTextField:textFieldRect];

    // ColorLabel生成
    int colorLabelY = textFieldY + margin + space;
    CGRect colorLabelRect = CGRectMake(kCommonAdaptWidthOfEditModal, colorLabelY, kLabelWidthOfEditModal, kCommonHeightOfEditModal);
    [self setFieldLabel:colorLabelRect label:@"Set Color :"];

}

//--------------------------------------------------------------//
#pragma mark-- Set Method--
//--------------------------------------------------------------//

@end
