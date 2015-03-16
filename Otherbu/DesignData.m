//
//  DesignData.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "DesignData.h"
#import "UIColor+Hex.h"

@implementation DesignData

//--------------------------------------------------------------//
#pragma mark -- initialize --
//--------------------------------------------------------------//

- (id)initWithDictionary:(NSDictionary *)dataDict {
    self = [super init];
    if (self) {
        self.tableBackGroundColor = dataDict[@"category_back_color"];
        self.bookmarkColor = dataDict[@"link_color"];
        self.urlColor = @"#808080";
    }
    return self;
}

//--------------------------------------------------------------//
#pragma mark -- Public Method --
//--------------------------------------------------------------//

- (UIColor *)getTableBackGroundColor {
    // テーブル背景色を取得
    return [UIColor colorWithHex:[UIColor removeSharp:_tableBackGroundColor]];
}

- (UIColor *)getbookmarkColor {
    // ブックマークのフォントカラーを取得
    return [UIColor colorWithHex:[UIColor removeSharp:_bookmarkColor]];
}

- (UIColor *)getUrlColor {
    // URLのフォントカラーを取得
    return [UIColor colorWithHex:[UIColor removeSharp:_urlColor]];
}

@end
