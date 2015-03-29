//
//  Helper.m
//  Otherbu
//
//  Created by fujimisakari on 2015/03/30.
//  Copyright (c) 2015年 fujimisakari. All rights reserved.
//

#import "Helper.h"

@implementation Helper

+ (int) getSameCountByDict:(NSDictionary *)dict TargetValue:(NSNumber *)value {
    int count = 0;
    for (id key in dict) {
        if (dict[key] == value) {
            ++count;
        }
    }
    return count;
}

@end
