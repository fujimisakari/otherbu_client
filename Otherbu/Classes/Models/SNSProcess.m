//
//  SNSProcess.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "FBSDKCoreKit.h"
#import "FBSDKLoginKit.h"
#import "UserData.h"
#import "AccountTypeData.h"

@implementation SNSProcess

+ (void)loginByFacebook {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions: @[@"public_profile"]
                            handler: ^(FBSDKLoginManagerLoginResult *loginResult, NSError *error) {
        if (error) {
            LOG(@"Process error");
        } else if (loginResult.isCancelled) {
            LOG(@"Cancelled");
        } else {
            LOG(@"Logged in");
            if ([FBSDKAccessToken currentAccessToken]) {
               [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
                startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id graphResult, NSError *error) {
                   if (!error) {
                       LOG(@"fetched user:%@", graphResult);
                       UserData *user = [[DataManager sharedManager] getUser];
                       NSMutableDictionary *result = (NSMutableDictionary *)graphResult;
                       [user Login:result[@"name"]
                              Type:[[DataManager sharedManager] getAccountType:@"2"].name
                            TypeId:result[@"id"]
                             Token:loginResult.token.tokenString];
                   }
               }];
            }
        }
    }];
}

+ (void)logoutByFacebook {
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logOut];
}

+ (void)loginByTwitter {
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (error) {
            LOG(@"Process error");
        } else if (session) {
            LOG(@"Logged in");
        } else {
            LOG(@"Cancelled");
        }
    }];
}

+ (void)logoutByTwitter {
    [[Twitter sharedInstance] logOut];
}

@end
