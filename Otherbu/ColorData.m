//
//  ColorData.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "ColorData.h"
#import "DataManager.h"

@implementation ColorData

//--------------------------------------------------------------//
#pragma mark -- initialize --
//--------------------------------------------------------------//

- (id)initWithDictionary:(NSDictionary *)dataDict {
    self = [super init];
    if (self) {
        self.dataId = [dataDict[@"id"] integerValue];
        self.name = dataDict[@"name"];
        self.font_color = dataDict[@"font_color"];
        self.icon_color = dataDict[@"icon_color"];
        self.sort = [dataDict[@"sort"] integerValue];
        self.color_code1 = dataDict[@"color_code1"];
        self.color_code2 = dataDict[@"color_code2"];
        self.color_code3 = dataDict[@"color_code3"];
        self.thumbnail_color_code = dataDict[@"thumbnail_color_code"];
    }
    return self;
}

//--------------------------------------------------------------//
#pragma mark -- Get Object By ForeignKey --
//--------------------------------------------------------------//

// todo 関数名替える

- (NSArray *)getGradientColorList {
    // グラデーション用のカラーリストを取得
    UIColor *color1 = [UIColor colorWithHex:[UIColor removeSharp:_color_code1]];
    UIColor *color2 = [UIColor colorWithHex:[UIColor removeSharp:_color_code2]];
    UIColor *color3 = [UIColor colorWithHex:[UIColor removeSharp:_color_code3]];
    NSArray *gradientColorList = @[ (id)color1.CGColor, (id)color2.CGColor, (id)color3.CGColor ];
    return gradientColorList;
}

- (UIColor *)getBackGroundColor {
    // テーブルの背景色を取得
    return [UIColor colorWithHex:[UIColor removeSharp:_color_code3]];
}

- (UIColor *)getSectionHeaderFontColor {
    // セクション用のフォントカラーを取得
    return [UIColor colorWithHex:[UIColor removeSharp:_font_color]];
}

- (UIColor *)getColorWithNumber:(int)number {
    UIColor *color;
    switch (number) {
        case 0:
            color = [UIColor colorWithHex:[UIColor removeSharp:_font_color]];
        case 1:
            color = [UIColor colorWithHex:[UIColor removeSharp:_color_code1]];
            break;
        case 2:
            color = [UIColor colorWithHex:[UIColor removeSharp:_color_code2]];
            break;
        case 3:
            color = [UIColor colorWithHex:[UIColor removeSharp:_color_code3]];
            break;
    }
    return color;
}

@end
