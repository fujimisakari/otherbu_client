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
        _tableBackGroundColor = @"#1e1e1e";
        _bookmarkColor = @"#ffffff";
        _urlColor = @"#808080";
        _backgroundPicture = kDefaultImageName;
    }
    return self;
}

- (void)updateWithDictionary:(NSDictionary *)dataDict {
    _tableBackGroundColor = dataDict[@"category_back_color"];
    _bookmarkColor = dataDict[@"link_color"];
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
    _tableBackGroundColor = colorCode;
}

- (void)updatetbookmarkNameColor:(NSString *)colorCode {
    // ブックマークのフォントカラーを更新
    _bookmarkColor = colorCode;
}

- (void)updatetbookmarkUrlColor:(NSString *)colorCode {
    // ブックマークURLのフォントカラーを更新
    _urlColor = colorCode;
}

- (void)updatetBackgroundPicture:(NSString *)fileName {
    // 背景画像のファイル名を更新
    _backgroundPicture = fileName;
}

//--------------------------------------------------------------//
#pragma mark -- 永続化 --
//--------------------------------------------------------------//

- (id)initWithCoder:(NSCoder *)decoder {
    // インスタンス変数をデコードする
    self = [super init];
    if (!self) {
        return nil;
    }

    _tableBackGroundColor = [decoder decodeObjectForKey:@"tableBackGroundColor"];
    _bookmarkColor = [decoder decodeObjectForKey:@"bookmarkColor"];
    _urlColor = [decoder decodeObjectForKey:@"urlColor"];
    _backgroundPicture = [decoder decodeObjectForKey:@"backgroundPicture"];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    // インスタンス変数をエンコードする
    [encoder encodeObject:_tableBackGroundColor forKey:@"tableBackGroundColor"];
    [encoder encodeObject:_bookmarkColor forKey:@"bookmarkColor"];
    [encoder encodeObject:_urlColor forKey:@"urlColor"];
    [encoder encodeObject:_backgroundPicture forKey:@"backgroundPicture"];
}

@end
