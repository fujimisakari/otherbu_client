//
//  OtherbuAPIClient.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "OtherbuAPIClient.h"
#import "AFHTTPSessionManager.h"

#ifdef DEBUG
    static NSString *const OtherbuAPIBaseURLString = @"http://dev.otherbu.com/";
#else
    static NSString *const OtherbuAPIBaseURLString = @"http://otherbu.com/";
#endif

@interface OtherbuAPIClient ()

// @property(nonatomic) AFHTTPSessionManager *sessionManager;

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
    // if (self) {
    //     NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //     self.sessionManager =
    //         [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:OtherbuAPIBaseURLString] sessionConfiguration:configuration];
    // }

    return self;
}

- (AFHTTPSessionManager *)makeSessionManager {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.HTTPAdditionalHeaders = @{@"Otherbu-Auth": [Helper getCertificationString],
                                            @"Accept": @"application/json"};
    AFHTTPSessionManager *sessionManager =
        [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:OtherbuAPIBaseURLString] sessionConfiguration:configuration];
    return sessionManager;
}

- (void)loginWithCompletion:(NSDictionary *)param
               requestBlock:(void (^)(int statusCode, NSDictionary *results, NSError *error))block {
    AFHTTPSessionManager *sessionManager = [self makeSessionManager];
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [sessionManager POST:@"/client_api/login/"
       parameters:param
        success:
             ^(NSURLSessionDataTask *task, id responseObject) {
                LOG(@"\n== Login Success ==\n");
                if (block) block((int)((NSHTTPURLResponse *)task.response).statusCode, responseObject, nil);
             }
        failure:
             ^(NSURLSessionDataTask *task, NSError *error) {
             LOG(@"\n== Login Erro ==\n");
             if (block) {
                 block((int)((NSHTTPURLResponse *)task.response).statusCode, nil, error);
             }
    }];
}

- (void)syncWithCompletion:(void (^)(int statusCode, NSDictionary *results, NSError *error))block {
    AFHTTPSessionManager *sessionManager = [self makeSessionManager];
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSMutableDictionary *param = [[DataManager sharedManager] getSyncData];
    [sessionManager POST:@"/client_api/sync/"
       parameters:param
        success:
             ^(NSURLSessionDataTask *task, id responseObject) {
                LOG(@"\n== Sync Success ==\n");
                if (block) block((int)((NSHTTPURLResponse *)task.response).statusCode, responseObject, nil);
             }
        failure:
             ^(NSURLSessionDataTask *task, NSError *error) {
             LOG(@"\n== Sync Erro ==\n");
             if (block) {
                 block((int)((NSHTTPURLResponse *)task.response).statusCode, nil, error);
             }
    }];
}

@end
