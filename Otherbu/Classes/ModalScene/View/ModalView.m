//
//  ModalView.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "ModalView.h"

@interface ModalView ()

@end

@implementation ModalView

//--------------------------------------------------------------//
#pragma mark -- Create Methods --
//--------------------------------------------------------------//

- (void)_bulkCreate {
    int space = 10;
    int startTitleY = 10;
    int startLabelY = 20;
    int totalTitleHeight = startTitleY + kCommonHeightOfModal + space;  // 画面上部からメニュータイトル名までの高さ
    int totalButtonHeight = space + kCommonHeightOfModal + space;       // 画面下部から編集ボタンまでの高さ
    int availableHeight = self.frame.size.height - (totalTitleHeight + totalButtonHeight + startLabelY);
    int availableMargin = availableHeight - (kViewHeightOfColorPalette + (int)((kCommonHeightOfModal + space) * 3));
    int margin = availableMargin / 2;  // 利用できる余白 / 項目ブロック

    // TitleLabel生成
    CGRect titleRect = CGRectMake(0, startTitleY + 10, self.frame.size.width, kCommonHeightOfModal);
    [self setTitleLabel:titleRect];

    // NameLabel生成
    int nameTextFieldLabelY = totalTitleHeight + startLabelY;
    CGRect textFieldLabelRect = CGRectMake(kCommonAdaptWidthOfModal, nameTextFieldLabelY, kLabelWidthOfModal, kCommonHeightOfModal);
    [self setFieldLabel:textFieldLabelRect label:@"Set Name :"];

    // NameTextField生成
    int nameTextFieldY = nameTextFieldLabelY + kCommonHeightOfModal + space;
    float textFieldWidth = self.frame.size.width - (kAdaptButtonWidthOfModal * 2);
    CGRect textFieldRect = CGRectMake(kAdaptWidthOfModal, nameTextFieldY, textFieldWidth, kCommonHeightOfModal);
    _nameTextField = [[UITextField alloc] init];
    [self setTextField:textFieldRect TextField:_nameTextField Text:[super.editItem iGetName]];

    // ColorLabel生成
    int colorLabelY = nameTextFieldY + kCommonHeightOfModal + space + margin;
    CGRect colorLabelRect = CGRectMake(kCommonAdaptWidthOfModal, colorLabelY, kLabelWidthOfModal, kCommonHeightOfModal);
    [self setFieldLabel:colorLabelRect label:@"Set Color :"];

    // ColorPalette生成
    int colorPaletteY = colorLabelY + kCommonHeightOfModal + space;
    float width = self.frame.size.width - (kAdaptWidthOfModal * 2);
    float height = kViewHeightOfColorPalette;
    CGRect colorPaletteRect = CGRectMake(kCommonAdaptWidthOfModal, colorPaletteY, width, height);
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
