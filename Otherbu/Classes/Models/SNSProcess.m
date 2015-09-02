//
//  SNSProcess.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "FBSDKCoreKit.h"
#import "FBSDKLoginKit.h"
#import "OtherbuAPIClient.h"
#import "UserData.h"
#import "AccountTypeData.h"

@implementation SNSProcess

//--------------------------------------------------------------//
#pragma mark -- SNS Login --
//--------------------------------------------------------------//

+ (void)login:(UINavigationController *)nav
     TypeName:(NSString *)typeName
     Callback:(void (^)(int statusCode, NSError *error))block {
    if ([typeName isEqualToString:[[DataManager sharedManager] getTwitterAccountType].name]) {
        [SNSProcess _loginByTwitter:nav Callback:block];
    } else if ([typeName isEqualToString:[[DataManager sharedManager] getFacebookAccountType].name]) {
        [SNSProcess _loginByFacebook:nav Callback:block];
    }
}

+ (void)_loginByTwitter:(UINavigationController *)nav Callback:(void (^)(int statusCode, NSError *error))block {
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (error) {
            LOG(@"Twitter Process error");
            block(4011, error);
        } else if (session) {
            LOG(@"Twitter Logged in");
            [[[Twitter sharedInstance] APIClient] loadUserWithID:session.userID completion:^(TWTRUser *twUser, NSError *twError) {
                 if (twError) {
                     block(4011, twError);
                 } else {
                     NSString *typeName = [[DataManager sharedManager] getTwitterAccountType].name;
                     NSDictionary *param = @{
                       @"name" : session.userName,
                       @"type_id" : session.userID,
                       @"auth_type" : typeName,
                       @"profile_image_url" : twUser.profileImageURL
                     };
                     UserData *user = [[DataManager sharedManager] getUser];
                     [user Login:session.userName Type:typeName TypeId:session.userID];
                     [self _getUserAccount:nav User:user RequestParam:param Callback:block];
                 }
            }];
        } else {
            LOG(@"Twitter Cancelled");
        }
    }];
}

+ (void)_loginByFacebook:(UINavigationController *)nav Callback:(void (^)(int statusCode, NSError *error))block {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions: @[@"public_profile"]
                            handler: ^(FBSDKLoginManagerLoginResult *loginResult, NSError *error) {
        if (error) {
            LOG(@"Facebook Process error");
            block(4012, error);
        } else if (loginResult.isCancelled) {
            LOG(@"Facebook Cancelled");
        } else {
            LOG(@"Facebook Logged in");
            if ([FBSDKAccessToken currentAccessToken]) {
               [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
                startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id graphResult, NSError *graphError) {
                   if (error) {
                       block(4012, graphError);
                   } else {
                       NSMutableDictionary *result = (NSMutableDictionary *)graphResult;
                       NSString *typeName = [[DataManager sharedManager] getFacebookAccountType].name;
                       NSDictionary *param = @{
                         @"name" : result[@"name"],
                         @"type_id" : result[@"id"],
                         @"auth_type" : typeName,
                       };
                       UserData *user = [[DataManager sharedManager] getUser];
                       [user Login:result[@"name"] Type:typeName TypeId:result[@"id"]];
                       [self _getUserAccount:nav User:user RequestParam:param Callback:block];
                   }
               }];
            }
        }
    }];
}

+ (void)_getUserAccount:(UINavigationController *)nav
                   User:(UserData *)user
           RequestParam:(NSDictionary *)param
               Callback:(void (^)(int statusCode, NSError *error))block {
    [[OtherbuAPIClient sharedClient]
        loginWithCompletion:param
        requestBlock:^(int statusCode, NSDictionary *results, NSError *error) {
        if (results) {
            // データ更新
            NSDictionary *userData = [results objectForKey:@"user_data"];
            LOG(@"== response Data ==\n%@\n", userData);
            [user updateWithDictionary:userData];
            [[DataManager sharedManager] save:SAVE_USER];
            [nav popViewControllerAnimated:YES];
        }
        if (error) block(statusCode, error);
    }];
}

//--------------------------------------------------------------//
#pragma mark -- SNS Logout --
//--------------------------------------------------------------//

+ (void)logout:(NSString *)typeName {
    if ([typeName isEqualToString:[[DataManager sharedManager] getTwitterAccountType].name]) {
        [SNSProcess _logoutByTwitter];
    } else if ([typeName isEqualToString:[[DataManager sharedManager] getFacebookAccountType].name]) {
        [SNSProcess _logoutByFacebook];
    }

    UserData *user = [[DataManager sharedManager] getUser];
    [user Logout];
    [[DataManager sharedManager] save:SAVE_USER];
}

+ (void)_logoutByTwitter {
    [[Twitter sharedInstance] logOut];
}

+ (void)_logoutByFacebook {
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logOut];
}

@end
