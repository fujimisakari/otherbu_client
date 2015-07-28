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
        self.sessionManager =
            [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:OtherbuAPIBaseURLString] sessionConfiguration:configuration];
    }

    return self;
}

- (void)syncWithCompletion:(void (^)(int statusCode, NSDictionary *results, NSError *error))block {
    self.sessionManager.session.configuration.HTTPAdditionalHeaders = @{@"Otherbu-Auth": [Helper getCertificationString],
                                                                        @"Accept" : @"application/json"};
    NSMutableDictionary *param = [[DataManager sharedManager] getSyncData];
    _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.sessionManager POST:@"/client_api/sync/"
       parameters:param
        success:
             ^(NSURLSessionDataTask *task, id responseObject) {
                LOG(@"\n== Success ==\n");
                if (block) block((int)((NSHTTPURLResponse *)task.response).statusCode, responseObject, nil);
             }
        failure:
             ^(NSURLSessionDataTask *task, NSError *error) {
             LOG(@"\n== Erro ==\n");
             if (block) {
                 block((int)((NSHTTPURLResponse *)task.response).statusCode, nil, error);
             }
    }];
}

@end
