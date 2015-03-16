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

- (id)initWithDictionary:(NSDictionary *)dataDict {
    self = [super init];
    if (self) {
        self.tableBackGroundColor = dataDict[@"category_back_color"];
        self.bookmarkColor = dataDict[@"link_color"];
        self.urlColor = @"#808080";
    }
    return self;
}

- (UIColor *)getTableBackGroundColor {
    return [UIColor colorWithHex:[UIColor removeSharp:_tableBackGroundColor]];
}

- (UIColor *)getbookmarkColor {
    return [UIColor colorWithHex:[UIColor removeSharp:_bookmarkColor]];
}

- (UIColor *)getUrlColor {
    return [UIColor colorWithHex:[UIColor removeSharp:_urlColor]];
}

@end
