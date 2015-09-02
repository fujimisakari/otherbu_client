//
//  OtherbuAPIClient.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

@interface OtherbuAPIClient : NSObject

+ (instancetype)sharedClient;
- (void)loginWithCompletion:(NSDictionary *)param requestBlock:(void (^)(int statusCode, NSDictionary *results, NSError *error))block ;
- (void)syncWithCompletion:(void (^)(int statusCode, NSDictionary *results, NSError *error))block;

@end
