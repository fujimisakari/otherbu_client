//
//  Device.m
//  Otherbu
//
//  Created by fujimisakari.
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "Device.h"

@implementation Device

+ (NSString *)iOSDevice {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        CGFloat scale = [UIScreen mainScreen].scale;
        result = CGSizeMake(result.width * scale, result.height * scale);
        switch ((int)result.height) {
            case 960:
                return @"iPhone4";
            case 1136:
                return @"iPhone5";
            case 1334:
                return @"iPhone6";
            case 2208:
                return @"iPhone6 Plus";
            default:
                return @"unknown";
        }
    } else {
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
            return @"iPad Retina";
        } else {
            return @"iPad";
        }
    }
}

+ (BOOL)isiPhone6Plus {
    return ([[Device iOSDevice] isEqualToString:@"iPhone6Plus"]);
}

+ (BOOL)isiPhone6 {
    return ([[Device iOSDevice] isEqualToString:@"iPhone6"]);
}

+ (BOOL)isiPhone5 {
    return ([[Device iOSDevice] isEqualToString:@"iPhone5"]);
}

+ (BOOL)isiPhone4 {
    return ([[Device iOSDevice] isEqualToString:@"iPhone4"]);
}

+ (BOOL)isIpad {
    return ([[Device iOSDevice] isEqualToString:@"iPad"]);
}

+ (BOOL)isIpadRetina {
    return ([[Device iOSDevice] isEqualToString:@"iPad Retina"]);
}

@end
