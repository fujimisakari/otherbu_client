//
//  SNSProcess.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "OtherbuAPIClient.h"
#import "UserData.h"
#import "AuthTypeData.h"
#import "CustomWebView.h"
#import "MBProgressHUD.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>

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
    ACAccountStore *accountStore = [ACAccountStore new];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];

    [accountStore
        requestAccessToAccountsWithType:accountType
                                options:nil
                             completion:^(BOOL granted, NSError *error) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    if (granted) {
                                        // ユーザーがTwitterアカウントへのアクセスを許可した
                                        NSArray *twitterAccounts = [accountStore accountsWithAccountType:accountType];
                                        if (twitterAccounts.count > 0) {
                                            // ログイン処理
                                            ACAccount *twitterAccount = [twitterAccounts lastObject];
                                            NSString *uid = [[twitterAccount valueForKey:@"properties"] objectForKey:@"user_id"];
                                            NSString *typeName = [[DataManager sharedManager] getTwitterAuthType].name;
                                            NSDictionary *param = @{
                                              @"name" : twitterAccount.userFullName,
                                              @"type_id" : uid,
                                              @"auth_type" : typeName,
                                              @"profile_image_url" : @""
                                            };
                                            [MBProgressHUD showHUDAddedTo:view animated:YES];
                                            [self _getUserAccount:nav View:view RequestParam:param Callback:block];
                                            LOG(@"Twitter Logged in");
                                        }
                                    } else {
                                        if([error code]== ACErrorAccountNotFound){
                                            //  iOSに登録されているTwitterアカウントがありません。
                                            block(4010, error);
                                        } else {
                                            // ユーザーが許可しない
                                            // 設定→Twitter→アカウントの使用許可するApp→YOUR_APPをオンにする必要がある
                                            block(4011, error);
                                        }
                                    }
                                });
                            }];
}

+ (void)_loginByFacebook:(UINavigationController *)nav
                    View:(UIView *)view
                Callback:(void (^)(int statusCode, NSError *error))block {

    ACAccountStore *accountStore = [ACAccountStore new];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    NSDictionary *options = @{ ACFacebookAppIdKey : kFacebookAppIdKey,
                               ACFacebookAudienceKey : kFacebookAudienceKey,
                               ACFacebookPermissionsKey : @[@"email"] };

    [accountStore
        requestAccessToAccountsWithType:accountType
                                options:options
                             completion:^(BOOL granted, NSError *error) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    if (granted) {
                                        // ユーザーがFacebookアカウントへのアクセスを許可した
                                        NSArray *facebookAccounts = [accountStore accountsWithAccountType:accountType];
                                        if (facebookAccounts.count > 0) {
                                            // ログイン処理
                                            ACAccount *facebookAccount = [facebookAccounts lastObject];
                                            NSString *uid = [[facebookAccount valueForKey:@"properties"] objectForKey:@"uid"];
                                            NSString *typeName = [[DataManager sharedManager] getFacebookAuthType].name;
                                            NSDictionary *param = @{
                                              @"name" : facebookAccount.userFullName,
                                              @"type_id" : uid,
                                              @"auth_type" : typeName,
                                            };
                                            [MBProgressHUD showHUDAddedTo:view animated:YES];
                                            [self _getUserAccount:nav View:view RequestParam:param Callback:block];
                                            LOG(@"Facebook Logged in");
                                        }
                                    } else {
                                        if([error code]== ACErrorAccountNotFound){
                                            //  iOSに登録されているFacebookアカウントがありません。
                                            block(4012, error);
                                        } else {
                                            // ユーザーが許可しない
                                            // 設定→Facebook→アカウントの使用許可するApp→YOUR_APPをオンにする必要がある
                                            block(4013, error);
                                        }
                                    }
                                });
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
    // データを保存する
    for (int idx = 0; idx < LastSave; ++idx) {
        [[DataManager sharedManager] save:idx];
    }
    [[DataManager sharedManager] dataFormat];
    [[DataManager sharedManager] setSelectAuthType:kDefaultAuthType];
    [[DataManager sharedManager] load];
    LOG(@"== logout ==\n");
}

//--------------------------------------------------------------//
#pragma mark -- SNS LinkShare --
//--------------------------------------------------------------//

+ (void)linkShare:(NSString *)typeName WebView:(UIWebView *)webView ViewController:(UIViewController *)viewController {
    if ([typeName isEqualToString:[[DataManager sharedManager] getTwitterAuthType].name]) {
        [SNSProcess _linkShareByTwitter:webView ViewController:viewController];
    } else if ([typeName isEqualToString:[[DataManager sharedManager] getFacebookAuthType].name]) {
        [SNSProcess _linkShareByFacebook:webView ViewController:viewController];
    }
}

+ (void)_linkShareByTwitter:(UIWebView *)webView ViewController:(UIViewController *)viewController {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        NSString *url = [webView stringByEvaluatingJavaScriptFromString:@"document.URL"];
        NSString *tweetText = [NSString stringWithFormat:@"%@ - %@", title, url];

        SLComposeViewController *composeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        void (^completion) (SLComposeViewControllerResult result) = ^(SLComposeViewControllerResult result) {
            [composeViewController dismissViewControllerAnimated:YES completion:nil];
        };
        [composeViewController setCompletionHandler:completion];
        [composeViewController setInitialText:tweetText];
        [viewController presentViewController:composeViewController animated:YES completion:Nil];
    }
}

+ (void)_linkShareByFacebook:(UIWebView *)webView ViewController:(UIViewController *)viewController {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        NSString *url = [webView stringByEvaluatingJavaScriptFromString:@"document.URL"];

        SLComposeViewController *composeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        void (^completion) (SLComposeViewControllerResult result) = ^(SLComposeViewControllerResult result) {
            [composeViewController dismissViewControllerAnimated:YES completion:nil];
        };
        [composeViewController setCompletionHandler:completion];
        [composeViewController addURL:[NSURL URLWithString:url]];
        [viewController presentViewController:composeViewController animated:YES completion:Nil];
    }
}

@end
