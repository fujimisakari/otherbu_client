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
    UILabel *_bookmarkName;
    UILabel *_bookmarkUrl;
}

@end

@implementation CellDesignView

// サンプル用の文字列
NSString *const kBookmarkName = @"OtherBu";
NSString *const kBookmarkUrl = @"http://otherbu.com";

- (void)setup {
    // 背景設定
    [self _setBackground];

    // ブックマーク名設定
    [self _setBookmarkName];

    // ブックマークURL設定
    [self _setBookmarkUrl];
}

//--------------------------------------------------------------//
#pragma mark -- Set Method --
//--------------------------------------------------------------//

- (void)_setBackground {
    int margin = 60;
    CGRect rec = CGRectMake(kOffsetXOfTableCell, margin, self.frame.size.width, kCellHeightOfSetting);
    _cellBackgroundView = [[UIView alloc] initWithFrame:rec];
    _cellBackgroundView.backgroundColor = [[[DataManager sharedManager] getDesign] getTableBackGroundColor];
    // 角丸にする
    _cellBackgroundView.layer.cornerRadius = 10.0f;
    _cellBackgroundView.layer.masksToBounds = YES;
    // 枠線
    _cellBackgroundView.layer.borderWidth = 2.0f;
    _cellBackgroundView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [self addSubview:_cellBackgroundView];
}

- (void)_setBookmarkName {
    _bookmarkName = [[UILabel alloc] initWithFrame:CGRectMake(15, 3, self.frame.size.width, 30)];
    _bookmarkName.text = kBookmarkName;
    _bookmarkName.textColor = [[[DataManager sharedManager] getDesign] getbookmarkColor];
    _bookmarkName.font = [UIFont fontWithName:kDefaultFont size:kFontSizeOfBookmark];
    [_cellBackgroundView addSubview:_bookmarkName];
}

- (void)_setBookmarkUrl {
    _bookmarkUrl = [[UILabel alloc] initWithFrame:CGRectMake(15, 28, self.frame.size.width, 15)];
    _bookmarkUrl.text = kBookmarkUrl;
    _bookmarkUrl.textColor = [[[DataManager sharedManager] getDesign] getUrlColor];
    _bookmarkUrl.font = [UIFont fontWithName:kDefaultFont size:kFontSizeOfUrl];
    [_cellBackgroundView addSubview:_bookmarkUrl];
}

//--------------------------------------------------------------//
#pragma mark -- Public Method --
//--------------------------------------------------------------//

- (void)setBackgroundColor:(UIColor *)color {
    _cellBackgroundView.backgroundColor = color;
}

- (void)setBookmarkNameColor:(UIColor *)color {
    _bookmarkName.textColor = color;
}

- (void)setBookmarkUrlColor:(UIColor *)color {
    _bookmarkUrl.textColor = color;
}

@end
