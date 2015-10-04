//
//  SNSProcess.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

@interface SNSProcess : NSObject

+ (void)login:(UINavigationController *)nav View:(UIView *)view TypeName:(NSString *)typeName Callback:(void (^)(int statusCode, NSError *error))block;
+ (void)logout:(NSString *)typeName;
+ (void)linkShare:(NSString *)typeName WebView:(UIWebView *)webView ViewController:(UIViewController *)viewController;

@end
