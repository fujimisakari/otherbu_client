//
//  ModalBKView.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "ModalBKView.h"

@implementation ModalBKView

//--------------------------------------------------------------//
#pragma mark -- Create Methods --
//--------------------------------------------------------------//

- (void)_bulkCreate {
    int space = 10;
    int startTitleY = 10;
    int startLabelY = 10;
    int categoryPickerHeight = 120;
    int totalTitleHeight = startTitleY + kCommonHeightOfModal + space;  // 画面上部からメニュータイトル名までの高さ
    int totalButtonHeight = space + kCommonHeightOfModal + space;       // 画面下部から編集ボタンまでの高さ
    int availableHeight = self.frame.size.height - (totalTitleHeight + totalButtonHeight + startLabelY);
    int availableMargin = availableHeight - categoryPickerHeight - (int)((kCommonHeightOfModal + space) * 5);  // 利用できる高さ - (項目高さ x 項目数)
    int margin = availableMargin / 3;  // 利用できる余白 / 項目ブロック
    float textFieldWidth = self.frame.size.width - (kAdaptButtonWidthOfModal * 2);

    // TitleLabel生成
    CGRect titleRect = CGRectMake(0, startTitleY + 10, self.frame.size.width, kCommonHeightOfModal);
    [self setTitleLabel:titleRect];

    // NameLabel生成
    int nameTextFieldLabelY = totalTitleHeight + startLabelY;
    CGRect textFieldLabelRect = CGRectMake(kCommonAdaptWidthOfModal, nameTextFieldLabelY, kLabelWidthOfModal, kCommonHeightOfModal);
    [self setFieldLabel:textFieldLabelRect label:@"Set Name :"];

    // NameTextField生成
    int nameTextFieldY = nameTextFieldLabelY + kCommonHeightOfModal + space;
    CGRect nameTextFieldRect = CGRectMake(kAdaptWidthOfModal, nameTextFieldY, textFieldWidth, kCommonHeightOfModal);
    _nameTextField = [[UITextField alloc] init];
    [self setTextField:nameTextFieldRect TextField:_nameTextField Text:[super.editItem iGetName]];

    // UrlLabel生成
    int urlFieldLabelY = nameTextFieldY + kCommonHeightOfModal + margin;
    CGRect urlFieldLabelRect = CGRectMake(kCommonAdaptWidthOfModal, urlFieldLabelY, kLabelWidthOfModal, kCommonHeightOfModal);
    [self setFieldLabel:urlFieldLabelRect label:@"Set URL :"];

    // UrlTextField生成
    int urlTextFieldY = urlFieldLabelY + kCommonHeightOfModal + space;
    CGRect urlTextFieldRect = CGRectMake(kAdaptWidthOfModal, urlTextFieldY, textFieldWidth, kCommonHeightOfModal);
    _urlTextField = [[UITextField alloc] init];
    [self setTextField:urlTextFieldRect TextField:_urlTextField Text:[super.editItem iGetUrl]];

    // CategoryLabel生成
    int categoryFieldLabelY = urlTextFieldY + kCommonHeightOfModal  + margin;
    CGRect categoryFieldLabelRect = CGRectMake(kCommonAdaptWidthOfModal, categoryFieldLabelY, kLabelWidthOfModal, kCommonHeightOfModal);
    [self setFieldLabel:categoryFieldLabelRect label:@"Set Category :"];

    // CategoryPicker生成
    int categoryTextFieldY = categoryFieldLabelY + kCommonHeightOfModal + space + space;
    CGRect categoryTextFieldRect = CGRectMake(kAdaptWidthOfModal, categoryTextFieldY, textFieldWidth, categoryPickerHeight);
    [self _setPickerView:categoryTextFieldRect];
}

//--------------------------------------------------------------//
#pragma mark-- Set Method--
//--------------------------------------------------------------//

- (void)_setPickerView:(CGRect)rect {
    _categoryPicker = [[UIPickerView alloc] initWithFrame:rect];
    _categoryPicker.backgroundColor = [UIColor colorWithHex:kTextFieldColorOfModal];
    [_categoryPicker.layer setCornerRadius:10.0];
    // PickerViewの高さを調整
    CGAffineTransform t0 = CGAffineTransformMakeTranslation(0, _categoryPicker.bounds.size.height / 1.5);
    CGAffineTransform s0 = CGAffineTransformMakeScale(1.0, 0.75);
    CGAffineTransform t1 = CGAffineTransformMakeTranslation(0, -_categoryPicker.bounds.size.height / 1.5);
    _categoryPicker.transform = CGAffineTransformConcat(t0, CGAffineTransformConcat(s0, t1));
    [self addSubview:_categoryPicker];
}

@end
