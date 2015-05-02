//
//  ColorData.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "ColorData.h"

@implementation ColorData

//--------------------------------------------------------------//
#pragma mark -- initialize --
//--------------------------------------------------------------//

- (id)initWithDictionary:(NSDictionary *)dataDict {
    self = [super init];
    if (self) {
        self.dataId = [dataDict[@"id"] stringValue];
        self.name = dataDict[@"name"];
        self.fontColor = dataDict[@"font_color"];
        self.iconColor = dataDict[@"icon_color"];
        self.sort = [dataDict[@"sort"] integerValue];
        self.colorCode1 = dataDict[@"color_code1"];
        self.colorCode2 = dataDict[@"color_code2"];
        self.colorCode3 = dataDict[@"color_code3"];
        self.thumbnailColorCode = dataDict[@"thumbnail_color_code"];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"dataId=%@, name=%@ fontColor=%@, iconColor=%@, sort=%ld, colorCode1=%@, colorCode2=%@, "
                                       "colorCode3=%@, thumbnailColorCode=%@",
                                      _dataId, _name, _fontColor, _iconColor, _sort, _colorCode1, _colorCode2, _colorCode3,
                                      _thumbnailColorCode];
}

//--------------------------------------------------------------//
#pragma mark -- Public Method --
//--------------------------------------------------------------//

- (NSArray *)getGradientColorList {
    // グラデーション用のカラーリストを取得
    UIColor *color1 = [UIColor colorWithHex:[UIColor removeSharp:_colorCode1]];
    UIColor *color2 = [UIColor colorWithHex:[UIColor removeSharp:_colorCode2]];
    UIColor *color3 = [UIColor colorWithHex:[UIColor removeSharp:_colorCode3]];
    NSArray *gradientColorList = @[(id)color1.CGColor, (id)color2.CGColor, (id)color3.CGColor];
    return gradientColorList;
}

- (UIColor *)getBackGroundColor {
    // テーブルの背景色を取得
    return [UIColor colorWithHex:[UIColor removeSharp:_colorCode3]];
}

- (UIColor *)getSectionHeaderFontColor {
    // セクション用のフォントカラーを取得
    return [UIColor colorWithHex:[UIColor removeSharp:_fontColor]];
}

- (UIColor *)getFooterColorOfGradient {
    // グラデーションの末尾のカラーを取得
    return [UIColor colorWithHex:[UIColor removeSharp:_colorCode3]];
}

- (UIColor *)getThumbnailColor {
    // サムネ用のカラーを取得
    return [UIColor colorWithHex:[UIColor removeSharp:_thumbnailColorCode]];
}


//--------------------------------------------------------------//
#pragma mark -- Data Intaface --
//--------------------------------------------------------------//

- (NSString *)iGetTitleName {
    return nil;
}

- (NSString *)iGetName {
    return self.name;
}

- (NSInteger)iGetSortId {
    return self.sort;
}

@end
