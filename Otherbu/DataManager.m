//
//  DataManager.m
//  Command
//
//  Created by fujimisakari on 2015/02/13.
//  Copyright (c) 2015年 fujimisakari. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

static DataManager *intance = nil;

+ (DataManager *)getInstance {
    if (!intance) {
        intance = [[DataManager alloc] init];
    }
    return intance;
}

- (id)init {
    self = [super init];
    if (self) {
        self.pageDict = [@{} mutableCopy];
        self.categoryDict = [@{} mutableCopy];
        self.bookmarkDict = [@{} mutableCopy];
    }
    return self;
}

- (void)insertData:(NSDictionary *)jsonData {
    NSArray *pageList = [jsonData objectForKey:@"page_list"];
    NSArray *categoryList = [jsonData objectForKey:@"category_list"];
    NSArray *bookmarkList = [jsonData objectForKey:@"bookmark_list"];

    for (NSDictionary *pageDict in pageList) {
        PageData *data = [[PageData alloc] initWithDictionary:pageDict];
        [_pageDict setObject:data forKey:pageDict[@"id"]];
    }

    for (NSDictionary *categoryDict in categoryList) {
        CategoryData *data = [[CategoryData alloc] initWithDictionary:categoryDict];
        [_categoryDict setObject:data forKey:categoryDict[@"id"]];
    }

    for (NSDictionary *bookmarkDict in bookmarkList) {
        BookmarkData *data = [[BookmarkData alloc] initWithDictionary:bookmarkDict];
        [_bookmarkDict setObject:data forKey:bookmarkDict[@"id"]];
    }
}

- (PageData *)getPage:(NSNumber *)dataId {
    return _pageDict[dataId];
}

- (CategoryData *)getCategory:(NSNumber *)dataId {
    return _categoryDict[dataId];
}

- (BookmarkData *)getBookmark:(NSNumber *)dataId {
    return _bookmarkDict[dataId];
}

@end
