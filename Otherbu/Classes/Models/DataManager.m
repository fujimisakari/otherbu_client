//
//  DataManager.m
//  Command
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "DataManager.h"
#import "OtherbuAPIClient.h"
#import "DataModels/UserData.h"
#import "DataModels/BookmarkData.h"
#import "DataModels/CategoryData.h"
#import "DataModels/PageData.h"
#import "DataModels/ColorData.h"
#import "DataModels/DesignData.h"

@interface DataManager ()

@property(nonatomic) UserData *user;
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
        self.user = [UserData shared];
        self.pageDict = [@{} mutableCopy];
        self.categoryDict = [@{} mutableCopy];
        self.bookmarkDict = [@{} mutableCopy];
        self.colorDict = [@{} mutableCopy];
        self.design = [DesignData shared];
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

//--------------------------------------------------------------//
#pragma mark -- get Method --
//--------------------------------------------------------------//

- (UserData *)getUser {
    return _user;
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

//--------------------------------------------------------------//
#pragma mark -- get List Method --
//--------------------------------------------------------------//

- (NSMutableArray *)getCategoryList {
    NSMutableArray *itemList = [NSMutableArray array];
    for (NSNumber *key in self.categoryDict) {
        [itemList addObject:[self getCategory:key]];
    }

    // カテゴリ名で昇順ソート
    NSArray *tmpResultList = [Helper doSortArrayWithKey:@"name" Array:itemList];
    NSMutableArray *resultList = [tmpResultList mutableCopy];
    return resultList;
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

- (NSArray *)getColorList {
    NSMutableArray *itemList = [NSMutableArray array];
    for (NSNumber *key in self.colorDict) {
        [itemList addObject:[self getColor:key]];
    }

    // sort番号で昇順ソート
    NSArray *resultList = [Helper doSortArrayWithKey:@"sort" Array:itemList];
    return resultList;
}

//--------------------------------------------------------------//
#pragma mark -- delete Method --
//--------------------------------------------------------------//

- (void)_bulkDeleteBookmarkData:(CategoryData *)category {
    // カテゴリに設定されているブックマークデータを削除
    NSArray *deleteBookmarkList = [category getBookmarkList];
    NSMutableDictionary *newBookmarkDict = [[NSMutableDictionary alloc] init];
    for (BookmarkData *bookmark in [_bookmarkDict objectEnumerator]) {
        NSUInteger index = [deleteBookmarkList indexOfObject:bookmark];
        if (index == NSNotFound) {
            [newBookmarkDict setObject:bookmark forKey:[[NSNumber alloc] initWithInt:(int)bookmark.dataId]];
        } else {
            // todo
            // datamanageに削除済みを登録する
        }
    }
    _bookmarkDict = newBookmarkDict;
}

- (NSMutableArray *)deleteCategoryData:(NSMutableArray *)categoryList DeleteIndex:(NSInteger)idx {
    // カテゴリデータの削除

    // カテゴリに設定されているブックマークデータを削除
    CategoryData *category = categoryList[idx];
    [self _bulkDeleteBookmarkData:category];

    // todo ページデータの更新

    // カテゴリデータを削除
    [categoryList removeObjectAtIndex:idx];
    NSMutableDictionary *newCategoryDict = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < categoryList.count; i++) {
        CategoryData *_category = categoryList[i];
        [newCategoryDict setObject:_category forKey:[[NSNumber alloc] initWithInt:(int)_category.dataId]];
    }
    self.categoryDict = newCategoryDict;

    // todo
    // datamanageに削除済みを登録する

    return categoryList;
}

- (NSMutableArray *)deletePageData:(NSMutableArray *)pageList DeleteIndex:(NSInteger)idx {
    // ページデータの削除
    [pageList removeObjectAtIndex:idx];

    NSMutableDictionary *newPageDict = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < pageList.count; i++) {
        PageData *page = pageList[i];
        page.sortId = i;
        [newPageDict setObject:page forKey:[[NSNumber alloc] initWithInt:(int)page.dataId]];
    }
    self.pageDict = newPageDict;

    // todo
    // datamanageに削除済みを登録する
    // userが保持してるpage_idをどうにかする
    return pageList;
}

//--------------------------------------------------------------//
#pragma mark -- Private Method --
//--------------------------------------------------------------//

- (void)_insertData:(NSDictionary *)jsonData {
    NSDictionary *user = [jsonData objectForKey:@"user"];
    NSArray *pageList = [jsonData objectForKey:@"page_list"];
    NSArray *categoryList = [jsonData objectForKey:@"category_list"];
    NSArray *bookmarkList = [jsonData objectForKey:@"bookmark_list"];
    NSArray *colorList = [jsonData objectForKey:@"color_list"];
    NSDictionary *design = [jsonData objectForKey:@"design"];

    [_user updateWithDictionary:user];

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

    [_design updateWithDictionary:design];
}

@end
