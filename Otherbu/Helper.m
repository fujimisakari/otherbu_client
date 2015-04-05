//
//  Helper.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
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
