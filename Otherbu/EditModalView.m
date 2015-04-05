//
//  EditModalView.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "EditModalView.h"

@interface EditModalView () {
    NSString *_name;
    NSInteger _colorId;
}

@end

@implementation EditModalView

//--------------------------------------------------------------//
#pragma mark -- initialize --
//--------------------------------------------------------------//

+ (id)initWithFrame:(CGRect)rect {

    float width = rect.size.width - (kAdaptWidthOfEditModal * 2);
    float height = rect.size.height - (kAdaptHeightOfEditModal * 2);
    CGRect _rect = CGRectMake(0, 0, width, height);
    EditModalView *editModal = [[EditModalView alloc] initWithFrame:_rect];

    return editModal;
}

- (void)setup {
    // setup initialize value
    _name = [_editItem iGetName];
    _colorId = [_editItem iGetColorId];

    // 画面の中心に表示されるようにする
    self.center = self.superview.center;

    // 背景色
    self.backgroundColor = UIColor.blackColor;

    // 角丸にする
    self.layer.cornerRadius = 10.0f;
    self.layer.masksToBounds = YES;

    // 枠線
    self.layer.borderWidth = 2.0f;
    self.layer.borderColor = [[UIColor blueColor] CGColor];

    // TitleLabel生成
    [self setTitleLabel];

    // Name編集フィールド生成
    CGRect textFieldRect = CGRectMake(20, 65, 150.0f, 30.0f);
    [self setFieldLabel:textFieldRect label:@"Name :"];
    [self setTextField];

    // Color選択View生成
    CGRect ColorRect = CGRectMake(20, 150, 150.0f, 30.0f);
    [self setFieldLabel:ColorRect label:@"Set Color :"];

    // キャンセルボタン
    int cancel_x = self.superview.center.x - (kButtonWidthOfEditModal + 20 + 20);
    int y = self.frame.size.height - (kButtonHeightOfEditModal + kAdaptButtonHeightOfEditModal);
    CGRect cancel_rect = CGRectMake(cancel_x, y, kButtonWidthOfEditModal, kButtonHeightOfEditModal);
    [self setButton:cancel_rect label:kCancelButtonOfEditModal action:@selector(_didPressCancelButton:)];

    // 更新ボタン
    int update_x = self.superview.center.x + 20 - 20;
    CGRect update_rect = CGRectMake(update_x, y, kButtonWidthOfEditModal, kButtonHeightOfEditModal);
    [self setButton:update_rect label:kUpdateButtonOfEditModal action:@selector(_didPressUpdateButton:)];
}

//--------------------------------------------------------------//
#pragma mark -- Set Method --
//--------------------------------------------------------------//

- (void)setTitleLabel {
    UILabel *titleLabel = [[UILabel alloc] init];
    CGRect rect = CGRectMake(28, 20, 150.0f, 30.0f);
    titleLabel.frame = rect;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:kDefaultFont size:kFontSizeOfSectionTitle];
    titleLabel.shadowColor = [UIColor grayColor];
    titleLabel.shadowOffset = CGSizeMake(1, 1);
    titleLabel.text = [NSString stringWithFormat:@"%@ %@", [_editItem iGetTitleName], @"Edit"];
    [self addSubview:titleLabel];
}

- (void)setFieldLabel:(CGRect)rect label:(NSString *)labelName {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = rect;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:kDefaultFont size:kFontSizeOfSectionTitle];
    titleLabel.shadowColor = [UIColor grayColor];
    titleLabel.shadowOffset = CGSizeMake(1, 1);
    titleLabel.text = labelName;
    [self addSubview:titleLabel];
}

- (void)setTextField {
    UITextField *textField = [[UITextField alloc] init];
    float fwidth = self.frame.size.width - (kAdaptButtonWidthOfEditModal * 2);
    textField.frame = CGRectMake(20, 100, fwidth, 30);
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.backgroundColor = [UIColor grayColor];
    textField.textColor = [UIColor whiteColor];
    textField.text = [_editItem iGetName];
    [self addSubview:textField];
}

- (void)setButton:(CGRect)rect label:(NSString *)title action:(SEL)action {
    UIButton *button = [[UIButton alloc] initWithFrame:rect];
    button.backgroundColor = [UIColor clearColor];
    [button setTitle:title forState:UIControlStateNormal];
    // ボタンの色
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    // ボタン押下時
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    // 枠線
    [button.layer setCornerRadius:10.0];
    [button.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [button.layer setBorderWidth:1.0];
    // イベントセット
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
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
