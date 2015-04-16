//
//  EditModalView.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "EditModalView.h"

@interface EditModalView ()

@end

@implementation EditModalView

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
    _nameTextField = [[UITextField alloc] init];
    [self setTextField:textFieldRect TextField:_nameTextField Text:[super.editItem iGetName]];

    // ColorLabel生成
    int colorLabelY = textFieldY + margin + space;
    CGRect colorLabelRect = CGRectMake(kCommonAdaptWidthOfEditModal, colorLabelY, kLabelWidthOfEditModal, kCommonHeightOfEditModal);
    [self setFieldLabel:colorLabelRect label:@"Set Color :"];

    // ColorPalette生成
    float width = self.frame.size.width - (kAdaptWidthOfEditModal * 2);
    float height = kViewHeightOfColorPalette;
    int colorPaletteY = colorLabelY + kCommonHeightOfEditModal;
    CGRect colorPaletteRect = CGRectMake(kCommonAdaptWidthOfEditModal, colorPaletteY, width, height);
    [self _setColorPalette:colorPaletteRect];
}

//--------------------------------------------------------------//
#pragma mark-- Set Method--
//--------------------------------------------------------------//

- (void)_setColorPalette:(CGRect)rect {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    float cellSize = kCellSizeOfColorPalette;
    layout.itemSize = CGSizeMake(cellSize, cellSize);            //表示するアイテムのサイズ
    layout.minimumLineSpacing = kCellMarginOfColorPalette;       //セクションとアイテムの間隔
    layout.minimumInteritemSpacing = kCellMarginOfColorPalette;  //アイテム同士の間隔

    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.frame = rect;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
    [self addSubview:_collectionView];
}

@end
