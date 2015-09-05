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
#import "AuthTypeData.h"
#import "MBProgressHUD.h"

@implementation SNSProcess

//--------------------------------------------------------------//
#pragma mark -- SNS Login --
//--------------------------------------------------------------//

+ (void)login:(UINavigationController *)nav
         View:(UIView *)view
     TypeName:(NSString *)typeName
     Callback:(void (^)(int statusCode, NSError *error))block {
    if ([typeName isEqualToString:[[DataManager sharedManager] getTwitterAuthType].name]) {
        [SNSProcess _loginByTwitter:nav View:view Callback:block];
    } else if ([typeName isEqualToString:[[DataManager sharedManager] getFacebookAuthType].name]) {
        [SNSProcess _loginByFacebook:nav View:view Callback:block];
    }
}

+ (void)_loginByTwitter:(UINavigationController *)nav
                   View:(UIView *)view
               Callback:(void (^)(int statusCode, NSError *error))block {
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
                     NSString *typeName = [[DataManager sharedManager] getTwitterAuthType].name;
                     NSDictionary *param = @{
                       @"name" : session.userName,
                       @"type_id" : session.userID,
                       @"auth_type" : typeName,
                       @"profile_image_url" : twUser.profileImageURL
                     };
                     [MBProgressHUD showHUDAddedTo:view animated:YES];
                     [self _getUserAccount:nav View:view RequestParam:param Callback:block];
                 }
            }];
        } else {
            LOG(@"Twitter Cancelled");
        }
    }];
}

+ (void)_loginByFacebook:(UINavigationController *)nav
                    View:(UIView *)view
                Callback:(void (^)(int statusCode, NSError *error))block {
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
                       NSString *typeName = [[DataManager sharedManager] getFacebookAuthType].name;
                       NSDictionary *param = @{
                         @"name" : result[@"name"],
                         @"type_id" : result[@"id"],
                         @"auth_type" : typeName,
                       };
                       [MBProgressHUD showHUDAddedTo:view animated:YES];
                       [self _getUserAccount:nav View:view RequestParam:param Callback:block];
                   }
               }];
            }
        }
    }];
}

+ (void)_getUserAccount:(UINavigationController *)nav
                   View:(UIView *)view
           RequestParam:(NSDictionary *)param
               Callback:(void (^)(int statusCode, NSError *error))block {
    [[OtherbuAPIClient sharedClient]
        loginWithCompletion:param
        requestBlock:^(int statusCode, NSDictionary *results, NSError *error) {
        [MBProgressHUD hideHUDForView:view animated:YES];
        if (results) {
            // データ更新
            [[DataManager sharedManager] dataFormat];
            [[DataManager sharedManager] setSelectAuthType:param[@"auth_type"]];
            [[DataManager sharedManager] load];
            UserData *user = [[DataManager sharedManager] getUser];
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
    if ([typeName isEqualToString:[[DataManager sharedManager] getTwitterAuthType].name]) {
        [SNSProcess _logoutByTwitter];
    } else if ([typeName isEqualToString:[[DataManager sharedManager] getFacebookAuthType].name]) {
        [SNSProcess _logoutByFacebook];
    }

    // データを保存する
    for (int idx = 0; idx < LastSave; ++idx) {
        [[DataManager sharedManager] save:idx];
    }
    [[DataManager sharedManager] dataFormat];
    [[DataManager sharedManager] setSelectAuthType:kDefaultAuthType];
    [[DataManager sharedManager] load];
    LOG(@"== logout ==\n");
}

+ (void)_logoutByTwitter {
    [[Twitter sharedInstance] logOut];
}

+ (void)_logoutByFacebook {
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logOut];
}

@end
