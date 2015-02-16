//
//  DataManager.h
//  Command
//
//  Created by fujimisakari on 2015/02/13.
//  Copyright (c) 2015年 fujimisakari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookmarkData.h"
#import "CategoryData.h"
#import "PageData.h"

@class PageData, CategoryData, BookmarkData;

@interface DataManager : NSObject

typedef enum {
    PAGE,
    CATEGORY,
    BOOKMARK,
} SelectType;

@property(nonatomic) NSMutableDictionary *pageDict;
@property(nonatomic) NSMutableDictionary *categoryDict;
@property(nonatomic) NSMutableDictionary *bookmarkDict;

+ (DataManager *)getInstance;

- (void)insertData:(NSDictionary *)jsonData;

- (PageData *)getPage:(NSNumber *)dataId;
- (CategoryData *)getCategory:(NSNumber *)dataId;
- (BookmarkData *)getBookmark:(NSNumber *)dataId;

@end
