//
//  Helper.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

@interface Helper : NSObject

+ (NSString *)generateId;
+ (NSNumber *)getNumberByInt:(int)value;
+ (int) getSameCountByDict:(NSDictionary *)dict TargetValue:(NSNumber *)value;
+ (NSArray *)doSortArrayWithKey:(NSString *)key Array:(NSArray *)array;
+ (void)setupBackgroundImage:(CGRect)rect TargetView:(UIView *)view;

@end
