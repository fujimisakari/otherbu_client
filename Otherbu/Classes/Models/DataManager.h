//
//  DataManager.h
//  Command
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "DataInterface.h"

@class UserData, PageData, CategoryData, BookmarkData, ColorData, DesignData, SearchData, AuthTypeData;

@interface DataManager : NSObject

@property(nonatomic) NSMutableDictionary *pageDict;
@property(nonatomic) NSMutableDictionary *categoryDict;
@property(nonatomic) NSMutableDictionary *bookmarkDict;
@property(nonatomic) NSMutableDictionary *colorDict;
@property(nonatomic) NSMutableDictionary *colorDictOfBookmarkBG;
@property(nonatomic) NSMutableDictionary *searchDict;
@property(nonatomic) NSMutableDictionary *authTypeDict;

+ (DataManager *)sharedManager;
- (void)dataFormat;

// アカンウトタイプを設定
- (void)loadAuthType;
- (void)setSelectAuthType:(NSString *)typeName;

// 単体でデータ取得
- (UserData *)getUser;
- (PageData *)getPage:(NSString *)dataId;
- (CategoryData *)getCategory:(NSString *)dataId;
- (BookmarkData *)getBookmark:(NSString *)dataId;
- (ColorData *)getColor:(NSString *)dataId;
- (ColorData *)getBookmarkBGColor:(NSString *)dataId;
- (DesignData *)getDesign;
- (SearchData *)getSearch:(NSString *)dataId;
- (AuthTypeData *)getAuthType:(NSString *)dataId;
- (AuthTypeData *)getTwitterAuthType;
- (AuthTypeData *)getFacebookAuthType;

// データ一覧を取得
- (NSMutableArray *)getCategoryList;
- (NSMutableArray *)getPageList;
- (NSMutableArray *)getPageListForMainScene;
- (NSArray *)getColorList;
- (NSArray *)getBookmarkBGColorList;
- (NSArray *)getSearchList;
- (NSArray *)getAuthTypeList;

// データの追加
- (void)addCategory:(CategoryData *)data;
- (void)addBookmark:(BookmarkData *)data;
- (void)addPage:(PageData *)data;

// データの削除
- (void)deleteBookmarkData:(BookmarkData *)deleteBookmark;
- (void)bulkDeleteBookmarkData:(NSArray *)deleteBookmarkList;
- (void)deleteCategoryData:(CategoryData *)deleteCategory;
- (void)deletePageData:(PageData *)deletePage;

// データの永続化
- (void)load;
- (void)save:(int)saveIdx;

// 同期用のデータ更新
- (NSMutableDictionary *)getSyncData;
- (void)updateSyncData:(id<DataInterface>)data DataType:(int)dataType Action:(NSString *)action;

// webへ同期
- (void)syncToWebWithBlock:(void (^)(int statusCode, NSError *error))block;

@end
