//
//  CellDesignView.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "CellDesignView.h"
#import "DesignData.h"

@interface CellDesignView () {
    UIView *_cellBackgroundView;
}

@end

@implementation CellDesignView

// サンプル用の文字列
NSString *const kBookmarkName = @"OtherBu";
NSString *const kBookmarkUrl = @"http://otherbu.com";

- (void)setup {
    _backgroundColor = [[DesignData shared] getTableBackGroundColor];
    _nameColor = [[DesignData shared] getbookmarkColor];
    _urlColor = [[DesignData shared] getUrlColor];

    // 背景設定
    [self _setBackground];

    // ブックマーク名設定
    [self _setBookmarkName];

    // ブックマークURL設定
    [self _setBookmarkUrl];
}

- (void)_setBackground {
    int margin = 60;
    CGRect rec = CGRectMake(kOffsetXOfTableCell, margin, self.frame.size.width, kCellHeightOfSetting);
    _cellBackgroundView = [[UIView alloc] initWithFrame:rec];
    _cellBackgroundView.backgroundColor = _backgroundColor;
    // 角丸にする
    _cellBackgroundView.layer.cornerRadius = 10.0f;
    _cellBackgroundView.layer.masksToBounds = YES;
    // 枠線
    _cellBackgroundView.layer.borderWidth = 2.0f;
    _cellBackgroundView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [self addSubview:_cellBackgroundView];
}

- (void)_setBookmarkName {
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 3, self.frame.size.width, 30)];
    textLabel.text = kBookmarkName;
    textLabel.textColor = _nameColor;
    textLabel.font = [UIFont fontWithName:kDefaultFont size:kFontSizeOfBookmark];
    [_cellBackgroundView addSubview:textLabel];
}

- (void)_setBookmarkUrl {
    UILabel *detailTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 28, self.frame.size.width, 15)];
    detailTextLabel.text = kBookmarkUrl;
    detailTextLabel.textColor = _urlColor;
    detailTextLabel.font = [UIFont fontWithName:kDefaultFont size:kFontSizeOfUrl];
    [_cellBackgroundView addSubview:detailTextLabel];
}

@end
