//
//  OtherbuAPIClient.m
//  Otherbu
//
//  Created by fujimisakari on 2015/02/20.
//  Copyright (c) 2015年 fujimisakari. All rights reserved.
//

#import "OtherbuAPIClient.h"

static NSString *const OtherbuAPIBaseURLString = @"http://dev.otherbu.com/";

@interface OtherbuAPIClient ()

@property(nonatomic) AFHTTPSessionManager *sessionManager;

@end

@implementation OtherbuAPIClient

+ (instancetype)sharedClient {
    static OtherbuAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ _sharedClient = [[self alloc] init]; });

    return _sharedClient;
}

- (id)init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.HTTPAdditionalHeaders = @{@"Accept" : @"application/json", };
        // self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:OtherbuAPIBaseURLString]];

        self.sessionManager =
            [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:OtherbuAPIBaseURLString] sessionConfiguration:configuration];
    }

    return self;
}

// + (NSURL *)loginURL
// {
//     return [[NSURL URLWithString:kIBKMInternBookmarkAPIBaseURLString] URLByAppendingPathComponent:@"login"];
// }

- (void)getBookmarksWithCompletion:(void (^)(NSDictionary *results, NSError *error))block {
    [self.sessionManager GET:@"/mock/"
       parameters:@{}
        success:
             ^(NSURLSessionDataTask *task, id responseObject) {
                if (block) block(responseObject, nil);
             }
        failure:
             ^(NSURLSessionDataTask * task, NSError * error) {
             if (block) {
                 block(nil, error);
             }
        // 401 が返ったときログインが必要.
        // if (((NSHTTPURLResponse *)task.response).statusCode == 401 && [self needsLogin]) {
        //     if (block) block(nil, nil);
        // }
        // else {
        //     if (block) block(nil, error);
        // }
    }];
}

// - (BOOL)needsLogin
// {
//     BOOL delegated = [self.delegate respondsToSelector:@selector(APIClientNeedsLogin:)];
//     if (delegated) {
//         [self.delegate APIClientNeedsLogin:self];
//     }
//     return delegated;
// }

@end
