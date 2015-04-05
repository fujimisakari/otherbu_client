//
//  EditModalView.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "EditModalView.h"

@interface EditModalView () {
    UICollectionView *_collectionView;
}

@end

@implementation EditModalView

//--------------------------------------------------------------//
#pragma mark -- initialize --
//--------------------------------------------------------------//

- (id)initWithFrame:(CGRect)rect {
    self = [super initWithFrame:rect];
    if (self) {
        float width = rect.size.width - (kAdaptWidthOfEditModal * 2);
        float height = rect.size.height - (kAdaptHeightOfEditModal * 2);
        CGRect _rect = CGRectMake(0, 0, width, height);
        self.frame = _rect;
    }
    return self;
}

- (UICollectionView *)getCollectionView {
    return _collectionView;
}

- (void)setup {
    // 画面の中心に表示されるようにする
    self.center = self.superview.center;

    // 背景色
    self.backgroundColor = UIColor.blackColor;

    // 角丸にする
    self.layer.cornerRadius = 10.0f;
    self.layer.masksToBounds = YES;

    // 枠線
    self.layer.borderWidth = kBorderWidthOfEditModal;
    self.layer.borderColor = [[UIColor colorWithHex:kBorderColorOfInEditModal] CGColor];

    // ラベル、フィールド、カラーパレッド生成
    [self _bulkCreate];

    // ボタン生成
    [self _createButton];
}

//--------------------------------------------------------------//
#pragma mark -- Create Methods --
//--------------------------------------------------------------//

- (void)_bulkCreate {
    int space = 10;
    int startY = 10;
    int totalTitleHeight = startY + kCommonHeightOfEditModal + space;
    int totalButtonHeight = space + kCommonHeightOfEditModal + space;
    int availableHeight = self.frame.size.height - (totalTitleHeight + totalButtonHeight);
    int restHeight = availableHeight - (kViewHeightOfColorPalette + kCommonHeightOfEditModal + kCommonHeightOfEditModal);
    int margin = restHeight / 2;

    // TitleLabel生成
    CGRect titleRect = CGRectMake(0, startY + 10, self.frame.size.width, kCommonHeightOfEditModal);
    [self _setTitleLabel:titleRect];

    // NameLabel生成
    int textFieldLabelY = totalTitleHeight + margin / 3;
    CGRect textFieldLabelRect = CGRectMake(kCommonAdaptWidthOfEditModal, textFieldLabelY, kLabelWidthOfEditModal, kCommonHeightOfEditModal);
    [self _setFieldLabel:textFieldLabelRect label:@"Name :"];

    // TextField生成
    int textFieldY = textFieldLabelY + kCommonHeightOfEditModal + space;
    float fwidth = self.frame.size.width - (kAdaptButtonWidthOfEditModal * 2);
    CGRect textFieldRect = CGRectMake(kAdaptWidthOfEditModal, textFieldY, fwidth, kCommonHeightOfEditModal);
    [self _setTextField:textFieldRect];

    // ColorLabel生成
    int colorLabelY = textFieldY + margin + space;
    CGRect colorLabelRect = CGRectMake(kCommonAdaptWidthOfEditModal, colorLabelY, kLabelWidthOfEditModal, kCommonHeightOfEditModal);
    [self _setFieldLabel:colorLabelRect label:@"Set Color :"];

    // ColorPalette生成
    float width = self.frame.size.width - (kAdaptWidthOfEditModal * 2);
    float height = kViewHeightOfColorPalette;
    int colorPaletteY = colorLabelY + kCommonHeightOfEditModal;
    CGRect colorPaletteRect = CGRectMake(kCommonAdaptWidthOfEditModal, colorPaletteY, width, height);
    [self _setColorPalette:colorPaletteRect];
}

- (void)_createButton {
    int y = self.frame.size.height - (kCommonHeightOfEditModal + kAdaptButtonHeightOfEditModal);

    // キャンセルボタン
    int cancel_x = self.superview.center.x - (kButtonWidthOfEditModal + kCommonAdaptWidthOfEditModal + kAdaptWidthOfEditModal);
    CGRect cancel_rect = CGRectMake(cancel_x, y, kButtonWidthOfEditModal, kCommonHeightOfEditModal);
    [self _setButton:cancel_rect label:kCancelButtonOfEditModal action:@selector(_didPressCancelButton:)];

    // 更新ボタン
    int update_x = self.superview.center.x + kCommonAdaptWidthOfEditModal - kAdaptWidthOfEditModal;
    CGRect update_rect = CGRectMake(update_x, y, kButtonWidthOfEditModal, kCommonHeightOfEditModal);
    [self _setButton:update_rect label:kUpdateButtonOfEditModal action:@selector(_didPressUpdateButton:)];
}

//--------------------------------------------------------------//
#pragma mark-- Set Method--
//--------------------------------------------------------------//

- (void)_setTitleLabel:(CGRect)rect {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = rect;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor lightGrayColor];
    titleLabel.font = [UIFont fontWithName:kDefaultFont size:kTitleFontSizeOfEditModal];
    titleLabel.text = [NSString stringWithFormat:@"%@ %@", [_editItem iGetTitleName], @"Edit"];
    [self addSubview:titleLabel];
}

- (void)_setFieldLabel:(CGRect)rect label:(NSString *)labelName {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = rect;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor lightGrayColor];
    titleLabel.font = [UIFont fontWithName:kDefaultFont size:kLabelFontSizeOfEditModal];
    titleLabel.text = labelName;
    [self addSubview:titleLabel];
}

- (void)_setTextField:(CGRect)rect {
    UITextField *textField = [[UITextField alloc] init];
    textField.frame = rect;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.backgroundColor = [UIColor colorWithHex:kTextFieldColorOfEditModal];
    textField.textColor = [UIColor whiteColor];
    textField.text = [_editItem iGetName];
    [self addSubview:textField];
}

- (void)_setButton:(CGRect)rect label:(NSString *)title action:(SEL)action {
    UIButton *button = [[UIButton alloc] initWithFrame:rect];
    button.backgroundColor = [UIColor clearColor];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];      // ボタンの色
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];  // ボタン押下時
    [button.layer setCornerRadius:10.0];
    [button.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [button.layer setBorderWidth:1.0];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

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

//--------------------------------------------------------------//
#pragma mark -- Tapped Action Methods --
//--------------------------------------------------------------//

- (void)_didPressCancelButton:(UIButton *)sender {
    [self.delegate didPressCancelButton];
}

- (void)_didPressUpdateButton:(UIButton *)sender {
    [self.delegate didPressUpdateButton];
}

@end
