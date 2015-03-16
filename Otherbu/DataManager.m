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

static DataManager *intance = nil;

+ (DataManager *)sharedManager {
    if (!intance) {
        intance = [[DataManager alloc] init];
    }
    return intance;
}

#pragma mark - Initialization

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

#pragma mark - Public Methods

- (void)reloadDataWithBlock:(void (^)(NSError *error))block {
    [[OtherbuAPIClient sharedClient]
        getBookmarksWithCompletion:^(NSDictionary *results, NSError *error) {
        if (results) {
            [self insertData:results];
            // NSArray *bookmarksJSON = results[@"bookmarks"];
            // self.bookmarks = [self parseBookmarks:bookmarksJSON];
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

#pragma mark - Private Methods

- (void)insertData:(NSDictionary *)jsonData {
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
