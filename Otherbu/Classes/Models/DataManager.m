//
//  DataManager.m
//  Command
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "DataManager.h"
#import "OtherbuAPIClient.h"
#import "UserData.h"
#import "BookmarkData.h"
#import "CategoryData.h"
#import "PageData.h"
#import "ColorData.h"
#import "DesignData.h"
#import "SearchData.h"

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
        self.searchDict = [@{} mutableCopy];

        for (NSDictionary *colorDict in [MasterData initColorData]) {
            ColorData *data = [[ColorData alloc] initWithDictionary:colorDict];
            [_colorDict setObject:data forKey:data.dataId];
        }

        for (NSDictionary *searchDict in [MasterData initSearchData]) {
            SearchData *data = [[SearchData alloc] initWithDictionary:searchDict];
            [_searchDict setObject:data forKey:data.dataId];
        }
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

- (PageData *)getPage:(NSString *)dataId {
    PageData *data = ([dataId isEqualToString:kDefaultPageDataId]) ? [self _getPageOfAllCategory] : _pageDict[dataId];
    return data;
}

- (CategoryData *)getCategory:(NSString *)dataId {
    return _categoryDict[dataId];
}

- (BookmarkData *)getBookmark:(NSString *)dataId {
    return _bookmarkDict[dataId];
}

- (ColorData *)getColor:(NSString *)dataId {
    return _colorDict[dataId];
}

- (DesignData *)getDesign {
    return _design;
}

- (SearchData *)getSearch:(NSString *)dataId {
    return _searchDict[dataId];
}

- (PageData *)_getPageOfAllCategory {
    NSMutableArray *categoryIdList = [[NSMutableArray alloc] init];
    NSMutableArray *angleIdList = [[NSMutableArray alloc] init];
    NSMutableArray *sortIdList = [[NSMutableArray alloc] init];

    for (CategoryData *category in [_categoryDict objectEnumerator]) {
        [categoryIdList addObject:category.dataId];
        [angleIdList addObject:[NSString stringWithFormat:@"%@:%ld", category.dataId, category.angle]];
        [sortIdList addObject:[NSString stringWithFormat:@"%@:%ld", category.dataId, category.sort]];
    }

    PageData *page = [[PageData alloc] init];
    page.dataId = @"AllCategory";
    page.name = @"ALL";
    page.categoryIdsStr = [categoryIdList componentsJoinedByString:@","];
    page.angleIdsStr = [angleIdList componentsJoinedByString:@","];
    page.sortIdsStr = [sortIdList componentsJoinedByString:@","];
    page.sortId = _pageDict.count;
    page.colorId = @"1";

    return page;
}

//--------------------------------------------------------------//
#pragma mark -- get List Method --
//--------------------------------------------------------------//

- (NSMutableArray *)getCategoryList {
    NSMutableArray *itemList = [NSMutableArray array];
    for (NSString *key in self.categoryDict) {
        [itemList addObject:[self getCategory:key]];
    }

    // カテゴリ名で昇順ソート
    NSArray *tmpResultList = [Helper doSortArrayWithKey:@"name" Array:itemList];
    NSMutableArray *resultList = [tmpResultList mutableCopy];
    return resultList;
}

- (NSMutableArray *)getPageList {
    NSMutableArray *itemList = [NSMutableArray array];
    for (NSString *key in self.pageDict) {
        [itemList addObject:[self getPage:key]];
    }
    // sort番号で昇順ソート
    NSArray *_resultList = [Helper doSortArrayWithKey:@"sortId" Array:itemList];
    NSMutableArray *resultList = [_resultList mutableCopy];
    return resultList;
}

- (NSMutableArray *)getPageListForMainScene {
    NSMutableArray *pageList = [self getPageList];
    [pageList addObject:[self _getPageOfAllCategory]];
    return pageList;
}

- (NSArray *)getColorList {
    NSMutableArray *itemList = [NSMutableArray array];
    for (NSString *key in self.colorDict) {
        [itemList addObject:[self getColor:key]];
    }

    // sort番号で昇順ソート
    NSArray *resultList = [Helper doSortArrayWithKey:@"sort" Array:itemList];
    return resultList;
}

- (NSMutableArray *)getSearchList {
    NSMutableArray *itemList = [NSMutableArray array];
    for (NSString *key in self.searchDict) {
        [itemList addObject:self.searchDict[key]];
    }
    return itemList;
}

//--------------------------------------------------------------//
#pragma mark -- Add Method --
//--------------------------------------------------------------//

- (void)addCategory:(CategoryData *)data {
    LOG(@"== add Category ==\n%@\n", data);
    [_categoryDict setObject:data forKey:data.dataId];
}

- (void)addBookmark:(BookmarkData *)data {
    LOG(@"== add Bookmark ==\n%@\n", data);
    [_bookmarkDict setObject:data forKey:data.dataId];
}

- (void)addPage:(PageData *)data {
    LOG(@"== add Page ==\n%@\n", data);
    [_pageDict setObject:data forKey:data.dataId];
}


//--------------------------------------------------------------//
#pragma mark -- delete Method --
//--------------------------------------------------------------//

- (NSMutableArray *)deleteBookmarkData:(NSMutableArray *)bookmarkList DeleteIndex:(NSInteger)idx {
    // ブックマークデータの削除
    BookmarkData *deleteBookmark = (BookmarkData *)bookmarkList[idx];
    NSMutableDictionary *newBookmarkDict = [[NSMutableDictionary alloc] init];
    for (BookmarkData *bookmark in [_bookmarkDict objectEnumerator]) {
        if ([bookmark isEqual:deleteBookmark]) {
            // todo
            // datamanageに削除済みを登録する
        } else {
            [newBookmarkDict setObject:bookmark forKey:bookmark.dataId];
        }
    }
    self.bookmarkDict = newBookmarkDict;

    [bookmarkList removeObjectAtIndex:idx];

    return bookmarkList;
}

- (void)_bulkDeleteBookmarkData:(CategoryData *)category {
    // カテゴリに設定されているブックマークデータを削除
    NSArray *deleteBookmarkList = [category getBookmarkList];
    NSMutableDictionary *newBookmarkDict = [[NSMutableDictionary alloc] init];
    for (BookmarkData *bookmark in [_bookmarkDict objectEnumerator]) {
        NSUInteger index = [deleteBookmarkList indexOfObject:bookmark];
        if (index == NSNotFound) {
            [newBookmarkDict setObject:bookmark forKey:bookmark.dataId];
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
    CategoryData *deleteCategory = categoryList[idx];
    [self _bulkDeleteBookmarkData:deleteCategory];

    // ページデータの更新
    for (PageData *page in [_pageDict objectEnumerator]) {
        [page updatePageData:deleteCategory isCheckMark:NO];
    }

    // カテゴリデータを削除
    NSMutableDictionary *newCategoryDict = [[NSMutableDictionary alloc] init];
    for (CategoryData *category in [_categoryDict objectEnumerator]) {
        if ([category isEqual:deleteCategory]) {
            // todo
            // datamanageに削除済みを登録する
        } else {
            [newCategoryDict setObject:category forKey:category.dataId];
        }
    }
    self.categoryDict = newCategoryDict;

    [categoryList removeObjectAtIndex:idx];

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
    // webから取得したjsonDataを格納
    NSDictionary *user = [jsonData objectForKey:@"user"];
    NSArray *pageList = [jsonData objectForKey:@"page_list"];
    NSArray *categoryList = [jsonData objectForKey:@"category_list"];
    NSArray *bookmarkList = [jsonData objectForKey:@"bookmark_list"];
    // NSArray *colorList = [jsonData objectForKey:@"color_list"];
    NSDictionary *design = [jsonData objectForKey:@"design"];

    [_user updateWithDictionary:user];

    for (NSDictionary *pageDict in pageList) {
        PageData *data = [[PageData alloc] initWithDictionary:pageDict];
        [_pageDict setObject:data forKey:[pageDict[@"id"] stringValue]];
    }

    for (NSDictionary *categoryDict in categoryList) {
        CategoryData *data = [[CategoryData alloc] initWithDictionary:categoryDict];
        [_categoryDict setObject:data forKey:[categoryDict[@"id"] stringValue]];
    }

    for (NSDictionary *bookmarkDict in bookmarkList) {
        BookmarkData *data = [[BookmarkData alloc] initWithDictionary:bookmarkDict];
        [_bookmarkDict setObject:data forKey:[bookmarkDict[@"id"] stringValue]];
    }

    // for (NSDictionary *colorDict in colorList) {
    //     ColorData *data = [[ColorData alloc] initWithDictionary:colorDict];
    //     [_colorDict setObject:data forKey:[colorDict[@"id"] stringValue]];
    // }

    [_design updateWithDictionary:design];
}

@end
