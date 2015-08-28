//
//  SNSProcess.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

@interface SNSProcess : NSObject

+ (void)loginByFacebook;
+ (void)logoutByFacebook;
+ (void)loginByTwitter;
+ (void)logoutByTwitter;

@end
