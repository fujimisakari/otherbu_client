//
//  OtherbuAPIClient.h
//  Otherbu
//
//  Created by fujimisakari on 2015/02/20.
//  Copyright (c) 2015年 fujimisakari. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface OtherbuAPIClient : NSObject

+ (instancetype)sharedClient;
- (void)getBookmarksWithCompletion:(void (^)(NSDictionary *results, NSError *error))block;

@end
