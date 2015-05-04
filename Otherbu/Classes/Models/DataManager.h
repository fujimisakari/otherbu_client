//
//  DataManager.h
//  Command
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

@class UserData, PageData, CategoryData, BookmarkData, ColorData, DesignData, SearchData;

@interface DataManager : NSObject

@property(nonatomic) NSMutableDictionary *pageDict;
@property(nonatomic) NSMutableDictionary *categoryDict;
@property(nonatomic) NSMutableDictionary *bookmarkDict;
@property(nonatomic) NSMutableDictionary *colorDict;
@property(nonatomic) NSMutableDictionary *searchDict;

+ (DataManager *)sharedManager;

- (void)reloadDataWithBlock:(void (^)(NSError *error))block;

// 単体でデータ取得
- (UserData *)getUser;
- (PageData *)getPage:(NSString *)dataId;
- (CategoryData *)getCategory:(NSString *)dataId;
- (BookmarkData *)getBookmark:(NSString *)dataId;
- (ColorData *)getColor:(NSString *)dataId;
- (DesignData *)getDesign;
- (SearchData *)getSearch:(NSString *)dataId;

// データ一覧を取得
- (NSMutableArray *)getCategoryList;
- (NSMutableArray *)getPageList;
- (NSMutableArray *)getPageListForMainScene;
- (NSArray *)getColorList;
- (NSMutableArray *)getSearchList;

// データの追加
- (void)addCategory:(CategoryData *)data;
- (void)addBookmark:(BookmarkData *)data;
- (void)addPage:(PageData *)data;

// データの削除
- (NSMutableArray *)deleteBookmarkData:(NSMutableArray *)bookmarkList DeleteIndex:(NSInteger)idx;
- (NSMutableArray *)deleteCategoryData:(NSMutableArray *)categoryList DeleteIndex:(NSInteger)idx;
- (NSMutableArray *)deletePageData:(NSMutableArray *)pageList DeleteIndex:(NSInteger)idx;

// データの永続化
- (void)load;
- (void)save:(int)saveIdx;

@end
