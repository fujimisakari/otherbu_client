//
//  SNSProcess.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "FBSDKCoreKit.h"
#import "FBSDKLoginKit.h"

@implementation SNSProcess

+ (void)loginByFacebook {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions: @[@"public_profile"]
                            handler: ^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            NSLog(@"Process error");
        } else if (result.isCancelled) {
            NSLog(@"Cancelled");
        } else {
            NSLog(@"Logged in");
        }
    }];
}

+ (void)loginByTwitter {
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (error) {
            NSLog(@"Process error");
        } else if (session) {
            NSLog(@"Logged in");
        } else {
            NSLog(@"Cancelled");
        }
    }];
}

@end
