//
//  SNSProcess.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

@interface SNSProcess : NSObject

+ (void)login:(UINavigationController *)nav TypeName:(NSString *)typeName Callback:(void (^)(int statusCode, NSError *error))block;
+ (void)logout:(NSString *)typeName;

@end
