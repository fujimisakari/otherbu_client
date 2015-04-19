//
//  ModalBaseView.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "ModalBaseView.h"

@interface ModalBaseView ()

@end

@implementation ModalBaseView

//--------------------------------------------------------------//
#pragma mark -- initialize --
//--------------------------------------------------------------//

- (id)initWithFrame:(CGRect)rect {
    self = [super initWithFrame:rect];
    if (self) {
        int adaptWidth;
        if ([Device isiPhone5] || [Device isiPhone4]) {
            adaptWidth = kAdaptHeightOfModal;
        } else {
            adaptWidth = kAdaptHeightOfModalForip6;
        }
        float width = rect.size.width - (kAdaptWidthOfModal * 2);
        float height = rect.size.height - (adaptWidth * 2);
        CGRect _rect = CGRectMake(0, 0, width, height);
        self.frame = _rect;
    }
    return self;
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
    self.layer.borderWidth = kBorderWidthOfModal;
    self.layer.borderColor = [[UIColor colorWithHex:kBorderColorOfModal] CGColor];

    // ラベル、フィールド、カラーパレッド生成
    [self _bulkCreate];

    // ボタン生成
    [self _createButton];
}

//--------------------------------------------------------------//
#pragma mark -- Create Methods --
//--------------------------------------------------------------//

- (void)_bulkCreate {
}

- (void)_createButton {
    int y = self.frame.size.height - (kCommonHeightOfModal + kAdaptButtonHeightOfModal);

    // キャンセルボタン
    int cancel_x = self.superview.center.x - (kButtonWidthOfModal + kCommonAdaptWidthOfModal + kAdaptWidthOfModal);
    CGRect cancel_rect = CGRectMake(cancel_x, y, kButtonWidthOfModal, kCommonHeightOfModal);
    [self setButton:cancel_rect label:kCancelButtonOfModal action:@selector(_didPressCancelButton:)];

    // 新規追加、更新ボタン
    int update_x = self.superview.center.x + kCommonAdaptWidthOfModal - kAdaptWidthOfModal;
    CGRect update_rect = CGRectMake(update_x, y, kButtonWidthOfModal, kCommonHeightOfModal);
    if ([_editItem isCreateMode]) {
        [self setButton:update_rect label:kCreateButtonOfModal action:@selector(_didPressUpdateButton:)];
    } else {
        [self setButton:update_rect label:kUpdateButtonOfModal action:@selector(_didPressUpdateButton:)];
    }
}

//--------------------------------------------------------------//
#pragma mark-- Set Method--
//--------------------------------------------------------------//

- (void)setTitleLabel:(CGRect)rect {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = rect;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor lightGrayColor];
    titleLabel.font = [UIFont fontWithName:kDefaultFont size:kTitleFontSizeOfModal];
    if ([_editItem isCreateMode]) {
        titleLabel.text = [NSString stringWithFormat:@"%@ %@", @"Create", [_editItem iGetTitleName]];
    } else {
        titleLabel.text = [NSString stringWithFormat:@"%@ %@", @"Edit", [_editItem iGetTitleName]];
    }
    [self addSubview:titleLabel];
}

- (void)setFieldLabel:(CGRect)rect label:(NSString *)labelName {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = rect;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor lightGrayColor];
    titleLabel.font = [UIFont fontWithName:kDefaultFont size:kLabelFontSizeOfModal];
    titleLabel.text = labelName;
    [self addSubview:titleLabel];
}

- (void)setTextField:(CGRect)rect TextField:(UITextField *)textField Text:(NSString *)text {
    textField.frame = rect;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.backgroundColor = [UIColor colorWithHex:kTextFieldColorOfModal];
    textField.textColor = [UIColor whiteColor];
    textField.text = text;
    [self addSubview:textField];
}

- (void)setButton:(CGRect)rect label:(NSString *)title action:(SEL)action {
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
