//
//  Helper.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

@interface Helper : NSObject

+ (int) getSameCountByDict:(NSDictionary *)dict TargetValue:(NSNumber *)value;
+ (void)setupBackgroundImage:(CGRect)rect TargetView:(UIView *)view;

@end
