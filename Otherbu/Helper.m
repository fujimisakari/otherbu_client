//
//  Helper.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "Helper.h"

@implementation Helper

+ (int)getSameCountByDict:(NSDictionary *)dict TargetValue:(NSNumber *)value {
    // DictからValueが同じ数を取得
    int count = 0;
    for (id key in dict) {
        if (dict[key] == value) {
            ++count;
        }
    }
    return count;
}

+ (void)setupBackgroundImage:(CGRect)rect TargetView:(UIView *)view {
    // 背景画像を設定
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    [[UIImage imageNamed:kDefaultImageName] drawInRect:view.bounds];
    UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CALayer *layer = [CALayer layer];
    layer.contents = (id)backgroundImage.CGImage;
    layer.frame = rect;
    layer.zPosition = -1.0;
    [view.layer addSublayer:layer];
}

@end
