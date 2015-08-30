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

//--------------------------------------------------------------//
#pragma mark -- SNS Login --
//--------------------------------------------------------------//

+ (void)login:(UINavigationController *)nav TypeName:(NSString *)typeName {
    if ([typeName isEqualToString:@"Twitter"]) {
        [SNSProcess _loginByTwitter:nav];
    } else if ([typeName isEqualToString:@"Facebook"]) {
        [SNSProcess _loginByFacebook:nav];
    }
}

+ (void)_loginByTwitter:(UINavigationController *)nav {
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (error) {
            LOG(@"Twitter Process error");
        } else if (session) {
            LOG(@"Twitter Logged in");
            UserData *user = [[DataManager sharedManager] getUser];
            [user Login:session.userName
                   Type:[[DataManager sharedManager] getAccountType:@"1"].name
                 TypeId:session.userID];
            [nav popViewControllerAnimated:YES];
        } else {
            LOG(@"Twitter Cancelled");
        }
    }];
}

+ (void)_loginByFacebook:(UINavigationController *)nav {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions: @[@"public_profile"]
                            handler: ^(FBSDKLoginManagerLoginResult *loginResult, NSError *error) {
        if (error) {
            LOG(@"Facebook Process error");
        } else if (loginResult.isCancelled) {
            LOG(@"Facebook Cancelled");
        } else {
            LOG(@"Facebook Logged in");
            if ([FBSDKAccessToken currentAccessToken]) {
               [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
                startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id graphResult, NSError *error) {
                   if (!error) {
                       LOG(@"fetched user:%@", graphResult);
                       UserData *user = [[DataManager sharedManager] getUser];
                       NSMutableDictionary *result = (NSMutableDictionary *)graphResult;
                       [user Login:result[@"name"]
                              Type:[[DataManager sharedManager] getAccountType:@"2"].name
                            TypeId:result[@"id"]];
                       [nav popViewControllerAnimated:YES];
                   }
               }];
            }
        }
    }];
}

//--------------------------------------------------------------//
#pragma mark -- SNS Logout --
//--------------------------------------------------------------//

+ (void)logout:(NSString *)typeName {
    if ([typeName isEqualToString:@"Twitter"]) {
        [SNSProcess _logoutByTwitter];
    } else if ([typeName isEqualToString:@"Facebook"]) {
        [SNSProcess _logoutByFacebook];
    }

    UserData *user = [[DataManager sharedManager] getUser];
    [user Logout];
}

+ (void)_logoutByTwitter {
    [[Twitter sharedInstance] logOut];
}


+ (void)_logoutByFacebook {
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logOut];
}

@end
