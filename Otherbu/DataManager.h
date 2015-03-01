//
//  DataManager.h
//  Command
//
//  Created by fujimisakari on 2015/02/13.
//  Copyright (c) 2015年 fujimisakari. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PageData, CategoryData, BookmarkData, ColorData;

@interface DataManager : NSObject

typedef NS_ENUM(NSUInteger, SelectType) {
    PAGE,
    CATEGORY,
    BOOKMARK,
    Color,
};

@property(nonatomic) NSMutableDictionary *pageDict;
@property(nonatomic) NSMutableDictionary *categoryDict;
@property(nonatomic) NSMutableDictionary *bookmarkDict;
@property(nonatomic) NSMutableDictionary *colorDict;

+ (DataManager *)sharedManager;

- (void)reloadDataWithBlock:(void (^)(NSError *error))block;

- (PageData *)getPage:(NSNumber *)dataId;
- (CategoryData *)getCategory:(NSNumber *)dataId;
- (BookmarkData *)getBookmark:(NSNumber *)dataId;
- (ColorData *)getColor:(NSNumber *)dataId;

@end
