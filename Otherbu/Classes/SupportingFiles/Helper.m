//
//  Helper.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "Helper.h"
#import "DesignData.h"

@implementation Helper

+ (NSString *)generateId {
    return [[NSUUID UUID] UUIDString];
}

+ (NSNumber *)getNumberByInt:(int)value {
    return [[NSNumber alloc] initWithInt:value];
}

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

+ (NSArray *)doSortArrayWithKey:(NSString *)key Array:(NSArray *)itemList {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObject:sortDescriptor];
    NSArray *resultList = [itemList sortedArrayUsingDescriptors:sortArray];
    return resultList;
}

+ (void)setupBackgroundImage:(CGRect)rect TargetView:(UIView *)view {
    // 背景画像を設定
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    NSString *imageName = [[[DataManager sharedManager] getDesign] getbackgroundPicturePath];
    [[UIImage imageNamed:imageName] drawInRect:view.bounds];
    UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CALayer *layer = [CALayer layer];
    layer.contents = (id)backgroundImage.CGImage;
    layer.frame = rect;
    layer.zPosition = -1.0;
    [view.layer addSublayer:layer];
}

@end
