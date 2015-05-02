//
//  DesignData.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "DesignData.h"

@implementation DesignData

//--------------------------------------------------------------//
#pragma mark -- initialize --
//--------------------------------------------------------------//

static DesignData *intance = nil;

+ (DesignData *)shared {
    if (!intance) {
        intance = [[DesignData alloc] init];
    }
    return intance;
}

- (id)init {
    self = [super init];
    if (self) {
        self.tableBackGroundColor = @"#1e1e1e";
        self.bookmarkColor = @"#ffffff";
        self.urlColor = @"#808080";
    }
    return self;
}

- (void)updateWithDictionary:(NSDictionary *)dataDict {
    self.tableBackGroundColor = dataDict[@"category_back_color"];
    self.bookmarkColor = dataDict[@"link_color"];
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

- (void)updateTableBackGroundColor:(NSString *)colorCode {
    // テーブル背景色を取得
    self.tableBackGroundColor = colorCode;
}

- (void)updatetbookmarkColor:(NSString *)colorCode {
    // ブックマークのフォントカラーを取得
    self.bookmarkColor = colorCode;
}

@end
