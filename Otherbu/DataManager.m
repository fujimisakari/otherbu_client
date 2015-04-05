//
//  DataManager.m
//  Command
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "DataManager.h"
#import "BookmarkData.h"
#import "CategoryData.h"
#import "PageData.h"
#import "ColorData.h"
#import "DesignData.h"
#import "OtherbuAPIClient.h"

@interface DataManager ()

@property(nonatomic) DesignData *design;

@end

@implementation DataManager

//--------------------------------------------------------------//
#pragma mark -- initialize --
//--------------------------------------------------------------//

static DataManager *intance = nil;

+ (DataManager *)sharedManager {
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
        self.colorDict = [@{} mutableCopy];
        self.design = nil;
    }
    return self;
}

//--------------------------------------------------------------//
#pragma mark -- Public Method --
//--------------------------------------------------------------//

- (void)reloadDataWithBlock:(void (^)(NSError *error))block {
    [[OtherbuAPIClient sharedClient]
        getBookmarksWithCompletion:^(NSDictionary *results, NSError *error) {
        if (results) {
            [self _insertData:results];
        }
        if (block) block(error);
    }
     ];
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

- (ColorData *)getColor:(NSNumber *)dataId {
    return _colorDict[dataId];
}

- (DesignData *)getDesign {
    return _design;
}

- (NSMutableArray *)getCategoryList {
    NSMutableArray *itemList = [NSMutableArray array];
    for (NSNumber *key in self.categoryDict) {
        [itemList addObject:[self getCategory:key]];
    }
    return itemList;
}

- (NSMutableArray *)getPageList {
    NSMutableArray *itemList = [NSMutableArray array];
    for (NSNumber *key in self.pageDict) {
        [itemList addObject:[self getPage:key]];
    }

    for (NSNumber *key in self.pageDict) {
        PageData *page = [self getPage:key];
        itemList[page.sortId] = page;
    }
    return itemList;
}

- (NSMutableArray *)getColorList {
    NSMutableArray *itemList = [NSMutableArray array];
    for (NSNumber *key in self.colorDict) {
        [itemList addObject:[self getColor:key]];
    }

    // リストをソート
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sort" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObject:sortDescriptor];
    NSArray *resultList = [itemList sortedArrayUsingDescriptors:sortArray];
    return resultList;
}

//--------------------------------------------------------------//
#pragma mark -- Private Method --
//--------------------------------------------------------------//

- (void)_insertData:(NSDictionary *)jsonData {
    NSArray *pageList = [jsonData objectForKey:@"page_list"];
    NSArray *categoryList = [jsonData objectForKey:@"category_list"];
    NSArray *bookmarkList = [jsonData objectForKey:@"bookmark_list"];
    NSArray *colorList = [jsonData objectForKey:@"color_list"];
    NSDictionary *design = [jsonData objectForKey:@"design"];

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

    for (NSDictionary *colorDict in colorList) {
        ColorData *data = [[ColorData alloc] initWithDictionary:colorDict];
        [_colorDict setObject:data forKey:colorDict[@"id"]];
    }

    _design = [[DesignData alloc] initWithDictionary:design];
}

@end
