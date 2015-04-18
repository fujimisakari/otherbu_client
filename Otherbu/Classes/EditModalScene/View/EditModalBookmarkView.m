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
    int startTitleY = 10;
    int startLabelY = 10;
    int categoryPickerHeight = 120;
    int totalTitleHeight = startTitleY + kCommonHeightOfEditModal + space;  // 画面上部からメニュータイトル名までの高さ
    int totalButtonHeight = space + kCommonHeightOfEditModal + space;       // 画面下部から編集ボタンまでの高さ
    int availableHeight = self.frame.size.height - (totalTitleHeight + totalButtonHeight + startLabelY);
    int availableMargin = availableHeight - categoryPickerHeight - (int)((kCommonHeightOfEditModal + space) * 5);  // 利用できる高さ - (項目高さ x 項目数)
    int margin = availableMargin / 3;  // 利用できる余白 / 項目ブロック
    float textFieldWidth = self.frame.size.width - (kAdaptButtonWidthOfEditModal * 2);

    // TitleLabel生成
    CGRect titleRect = CGRectMake(0, startTitleY + 10, self.frame.size.width, kCommonHeightOfEditModal);
    [self setTitleLabel:titleRect];

    // NameLabel生成
    int nameTextFieldLabelY = totalTitleHeight + startLabelY;
    CGRect textFieldLabelRect = CGRectMake(kCommonAdaptWidthOfEditModal, nameTextFieldLabelY, kLabelWidthOfEditModal, kCommonHeightOfEditModal);
    [self setFieldLabel:textFieldLabelRect label:@"Set Name :"];

    // NameTextField生成
    int nameTextFieldY = nameTextFieldLabelY + kCommonHeightOfEditModal + space;
    CGRect nameTextFieldRect = CGRectMake(kAdaptWidthOfEditModal, nameTextFieldY, textFieldWidth, kCommonHeightOfEditModal);
    _nameTextField = [[UITextField alloc] init];
    [self setTextField:nameTextFieldRect TextField:_nameTextField Text:[super.editItem iGetName]];

    // UrlLabel生成
    int urlFieldLabelY = nameTextFieldY + kCommonHeightOfEditModal + margin;
    CGRect urlFieldLabelRect = CGRectMake(kCommonAdaptWidthOfEditModal, urlFieldLabelY, kLabelWidthOfEditModal, kCommonHeightOfEditModal);
    [self setFieldLabel:urlFieldLabelRect label:@"Set URL :"];

    // UrlTextField生成
    int urlTextFieldY = urlFieldLabelY + kCommonHeightOfEditModal + space;
    CGRect urlTextFieldRect = CGRectMake(kAdaptWidthOfEditModal, urlTextFieldY, textFieldWidth, kCommonHeightOfEditModal);
    _urlTextField = [[UITextField alloc] init];
    [self setTextField:urlTextFieldRect TextField:_urlTextField Text:[super.editItem iGetUrl]];

    // CategoryLabel生成
    int categoryFieldLabelY = urlTextFieldY + kCommonHeightOfEditModal  + margin;
    CGRect categoryFieldLabelRect = CGRectMake(kCommonAdaptWidthOfEditModal, categoryFieldLabelY, kLabelWidthOfEditModal, kCommonHeightOfEditModal);
    [self setFieldLabel:categoryFieldLabelRect label:@"Set Category :"];

    // CategoryPicker生成
    int categoryTextFieldY = categoryFieldLabelY + kCommonHeightOfEditModal + space + space;
    CGRect categoryTextFieldRect = CGRectMake(kAdaptWidthOfEditModal, categoryTextFieldY, textFieldWidth, categoryPickerHeight);
    [self _setPickerView:categoryTextFieldRect];
}

//--------------------------------------------------------------//
#pragma mark-- Set Method--
//--------------------------------------------------------------//

- (void)_setPickerView:(CGRect)rect {
    _categoryPicker = [[UIPickerView alloc] initWithFrame:rect];
    _categoryPicker.backgroundColor = [UIColor colorWithHex:kTextFieldColorOfEditModal];
    [_categoryPicker.layer setCornerRadius:10.0];
    // PickerViewの高さを調整
    CGAffineTransform t0 = CGAffineTransformMakeTranslation(0, _categoryPicker.bounds.size.height / 1.5);
    CGAffineTransform s0 = CGAffineTransformMakeScale(1.0, 0.75);
    CGAffineTransform t1 = CGAffineTransformMakeTranslation(0, -_categoryPicker.bounds.size.height / 1.5);
    _categoryPicker.transform = CGAffineTransformConcat(t0, CGAffineTransformConcat(s0, t1));
    [self addSubview:_categoryPicker];
}

@end
