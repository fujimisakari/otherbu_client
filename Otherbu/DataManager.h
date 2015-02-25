//
//  DataManager.h
//  Command
//
//  Created by fujimisakari on 2015/02/13.
//  Copyright (c) 2015年 fujimisakari. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PageData, CategoryData, BookmarkData;

@interface DataManager : NSObject

typedef NS_ENUM(NSUInteger, SelectType) {
    PAGE,
    CATEGORY,
    BOOKMARK,
};

@property(nonatomic) NSMutableDictionary *pageDict;
@property(nonatomic) NSMutableDictionary *categoryDict;
@property(nonatomic) NSMutableDictionary *bookmarkDict;

+ (DataManager *)sharedManager;

- (void)insertData:(NSDictionary *)jsonData;
- (void)reloadDataWithBlock:(void (^)(NSError *error))block;

- (PageData *)getPage:(NSNumber *)dataId;
- (CategoryData *)getCategory:(NSNumber *)dataId;
- (BookmarkData *)getBookmark:(NSNumber *)dataId;

@end
