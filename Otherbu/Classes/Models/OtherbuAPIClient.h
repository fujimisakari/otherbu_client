//
//  OtherbuAPIClient.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface OtherbuAPIClient : NSObject

+ (instancetype)sharedClient;
- (void)getBookmarksWithCompletion:(void (^)(NSDictionary *results, NSError *error))block;

@end
