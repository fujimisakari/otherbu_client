//
//  ColorData.m
//  Otherbu
//
//  Created by fujimisakari on 2015/03/01.
//  Copyright (c) 2015年 fujimisakari. All rights reserved.
//

#import "ColorData.h"
#import "DataManager.h"
#import "UIColor+Hex.h"

@implementation ColorData

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

- (NSArray *)getGradientColorList {

    NSString *(^removeSharp)(NSString *) = ^NSString *(NSString *hexColorCode) {
        // hexColorCodeの先頭の#を削除
        NSMutableString *str = [NSMutableString stringWithString:hexColorCode];
        [str deleteCharactersInRange:NSMakeRange(0, 1)];
        return str;
    };

    UIColor *color1 = [UIColor colorWithHex:removeSharp(_color_code1)];
    UIColor *color2 = [UIColor colorWithHex:removeSharp(_color_code2)];
    UIColor *color3 = [UIColor colorWithHex:removeSharp(_color_code3)];
    NSArray *gradientColorList = @[ (id)color1.CGColor, (id)color2.CGColor, (id)color3.CGColor ];
    return gradientColorList;
}

@end
