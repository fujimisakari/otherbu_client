//
//  SettingTableViewCell.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "SettingTableViewCell.h"

@implementation SettingTableViewCell

//--------------------------------------------------------------//
#pragma mark -- OverRide UITableViewCell --
//--------------------------------------------------------------//

- (void)layoutSubviews {
    // セル内のアイコンやラベルのレイアウト設定
    [super layoutSubviews];

    self.textLabel.frame = CGRectMake(self.textLabel.frame.origin.x, kCellItemMarginOfSetting, self.textLabel.frame.size.width,
                                      self.textLabel.frame.size.height);

    self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y + kCellItemMarginOfSetting,
                                      self.imageView.frame.size.width, self.imageView.frame.size.height);

    self.accessoryView.frame = CGRectMake(self.accessoryView.frame.origin.x, self.accessoryView.frame.origin.y + kCellItemMarginOfSetting,
                                          self.accessoryView.frame.size.width, self.accessoryView.frame.size.height);

    // Cell削除ボタンを差し替える
    CGRect (^subviewFomatter)(UIView *) = ^CGRect(UIView * subview) {
        int addMargin = 5;  // 位置調整
        return CGRectMake(subview.frame.origin.x, subview.frame.origin.y + kCellItemMarginOfSetting + addMargin, subview.frame.size.width,
                          subview.frame.size.height - kCellItemMarginOfSetting - addMargin);
    };
    for (UIView *subview in self.subviews) {
        // for ios8
        if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"]) {
            subview.frame = subviewFomatter(subview);
            [self bringSubviewToFront:subview];
            return;
        }

        // for ios7
        for (UIView *_subview in subview.subviews) {
            if ([NSStringFromClass([_subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"]) {
                _subview.frame = subviewFomatter(_subview);
                [subview bringSubviewToFront:_subview];
                return;
            }
        }
    }
}

- (void)setAccessoryType:(UITableViewCellAccessoryType)newAccessoryType {
    // チェックマークはカスタム画像を利用する
    [super setAccessoryType:newAccessoryType];

    switch (newAccessoryType) {
        case UITableViewCellAccessoryCheckmark:
            self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kCheckMarkIcon]];
            break;
        case UITableViewCellAccessoryNone:
            self.accessoryView = nil;
            break;
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    // ナビゲーションバーから画面遷移で戻るときはアニメーションを行わない
    if (selected) {
        [super setSelected:selected animated:animated];
    } else {
        [super setSelected:selected animated:NO];
    }
}

//--------------------------------------------------------------//
#pragma mark -- Set Methods --
//--------------------------------------------------------------//

- (void)setup {
    // Cellの矢印アクセサリーへはカスタム画像を設定する
    UIImageView *righttArrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kRighttArrowIcon]];
    self.accessoryView = righttArrowImageView;

    // Cellが用意しているUIViewは使用せず、willDisplayCellでCustomUIVeiwを挿入する
    for (UIView *view in self.contentView.subviews) {
        if ([[[view class] description] isEqualToString:@"UIView"]) {
            [view removeFromSuperview];
        }
    }
}

- (void)setBackground:(CGRect)rect {
    // セルの背景設定(半透明で間隔が空いたセル成)

    // 既存Cellの背景は使用せず透明にする
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];

    // 通常時のセル背景
    UIColor *color = [UIColor colorWithWhite:1.0 alpha:0.8];
    UIView *whiteRoundedCornerView = [self _createWhiteRoundedCornerView:rect Color:color];
    [self.contentView addSubview:whiteRoundedCornerView];
    [self.contentView sendSubviewToBack:whiteRoundedCornerView];

    // タップ時のセル背景
    UIColor *backColor = [UIColor colorWithWhite:0.9 alpha:0.8];
    UIView *backWhiteRoundedCornerView = [self _createWhiteRoundedCornerView:rect Color:backColor];
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor clearColor];
    [backgroundView addSubview:backWhiteRoundedCornerView];
    [backgroundView sendSubviewToBack:backWhiteRoundedCornerView];
    self.selectedBackgroundView = backgroundView;
}

- (UIView *)_createWhiteRoundedCornerView:(CGRect)rect Color:(UIColor *)color {
    // セルの背景Viewを生成
    UIView *whiteRoundedCornerView = [[UIView alloc] initWithFrame:rect];
    whiteRoundedCornerView.backgroundColor = color;
    whiteRoundedCornerView.layer.masksToBounds = NO;
    whiteRoundedCornerView.layer.cornerRadius = 3.0;
    // whiteRoundedCornerView.layer.shadowOffset = CGSizeMake(-1, 1);
    // whiteRoundedCornerView.layer.shadowOpacity = 0.5;
    return whiteRoundedCornerView;
}


@end
