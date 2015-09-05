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
#import "AuthTypeData.h"
#import "SelectAuthTypeData.h"

@interface DataManager () {
    SelectAuthTypeData *_selectAuthType;
    UserData *_user;
    DesignData *_design;
    NSMutableDictionary *_syncData;
}

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
        [self dataFormat];
    }
    return self;
}

- (void)dataFormat {
    _selectAuthType = [[SelectAuthTypeData alloc] init];
    _user = [[UserData alloc] init];
    _design = [[DesignData alloc] init];
    _categoryDict = [@{} mutableCopy];
    _bookmarkDict = [@{} mutableCopy];
    _pageDict = [@{} mutableCopy];

    _colorDict = [@{} mutableCopy];
    for (NSDictionary *colorDict in [MasterData initColorData]) {
        ColorData *data = [[ColorData alloc] initWithDictionary:colorDict];
        [_colorDict setObject:data forKey:data.dataId];
    }

    _colorDictOfBookmarkBG = [@{} mutableCopy];
    for (NSDictionary *colorDict in [MasterData initBookmarkBGColorData]) {
        ColorData *data = [[ColorData alloc] initWithDictionary:colorDict];
        [_colorDictOfBookmarkBG setObject:data forKey:data.dataId];
    }

    _searchDict = [@{} mutableCopy];
    for (NSDictionary *searchDict in [MasterData initSearchData]) {
        SearchData *data = [[SearchData alloc] initWithDictionary:searchDict];
        [_searchDict setObject:data forKey:data.dataId];
    }

    _authTypeDict = [@{} mutableCopy];
    for (NSDictionary *authTypeDict in [MasterData initAuthTypeData]) {
        AuthTypeData *data = [[AuthTypeData alloc] initWithDictionary:authTypeDict];
        [_authTypeDict setObject:data forKey:data.dataId];
    }

    _syncData = [self _restSyncData];
}

//--------------------------------------------------------------//
#pragma mark -- Public Method --
//--------------------------------------------------------------//

- (void)setSelectAuthType:(NSString *)typeName {
    _selectAuthType.name = typeName;
    [self saveAuthType];
}

- (void)syncToWebWithBlock:(void (^)(int statusCode, NSError *error))block {
    [[OtherbuAPIClient sharedClient]
        syncWithCompletion:^(int statusCode, NSDictionary *results, NSError *error) {
        if (results) {
            // インサート処理
            [self _updateResponseData:results];

            // 同期したデータを保存する
            for (int idx = 0; idx < LastSave; ++idx) {
                [self save:idx];
            }

            // 同期用のデータをリセット
            _syncData = [self _restSyncData];
            [self save:SAVE_SYNC];
        }
        if (block) block(statusCode, error);
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

- (ColorData *)getBookmarkBGColor:(NSString *)dataId {
    return _colorDictOfBookmarkBG[dataId];
}

- (DesignData *)getDesign {
    return _design;
}

- (SearchData *)getSearch:(NSString *)dataId {
    return _searchDict[dataId];
}

- (AuthTypeData *)getAuthType:(NSString *)dataId {
    return _authTypeDict[dataId];
}

- (AuthTypeData *)getTwitterAuthType {
    return _authTypeDict[@"1"];
}

- (AuthTypeData *)getFacebookAuthType {
    return _authTypeDict[@"2"];
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
    page.dataId = kDefaultPageDataId;
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
    for (NSString *key in _pageDict) {
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
    for (NSString *key in _colorDict) {
        [itemList addObject:[self getColor:key]];
    }

    // sort番号で昇順ソート
    NSArray *resultList = [Helper doSortArrayWithKey:@"sort" Array:itemList];
    return resultList;
}

- (NSArray *)getBookmarkBGColorList {
    NSMutableArray *itemList = [NSMutableArray array];
    for (NSString *key in _colorDictOfBookmarkBG) {
        [itemList addObject:[self getBookmarkBGColor:key]];
    }

    // sort番号で昇順ソート
    NSArray *resultList = [Helper doSortArrayWithKey:@"sort" Array:itemList];
    return resultList;
}

- (NSArray *)getSearchList {
    NSMutableArray *itemList = [NSMutableArray array];
    for (NSString *key in _searchDict) {
        [itemList addObject:_searchDict[key]];
    }
    // sort番号で昇順ソート
    NSArray *resultList = [Helper doSortArrayWithKey:@"sort" Array:itemList];
    return resultList;
}

- (NSArray *)getAuthTypeList {
    NSMutableArray *itemList = [NSMutableArray array];
    for (NSString *key in _authTypeDict) {
        [itemList addObject:_authTypeDict[key]];
    }
    // sort番号で昇順ソート
    NSArray *resultList = [Helper doSortArrayWithKey:@"sort" Array:itemList];
    return resultList;
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

- (void)deleteBookmarkData:(BookmarkData *)deleteBookmark {
    // ブックマークデータの削除
    NSMutableDictionary *newBookmarkDict = [[NSMutableDictionary alloc] init];
    for (BookmarkData *bookmark in [_bookmarkDict objectEnumerator]) {
        if (![bookmark isEqual:deleteBookmark]) {
            [newBookmarkDict setObject:bookmark forKey:bookmark.dataId];
        }
    }
    _bookmarkDict = newBookmarkDict;
}

- (void)bulkDeleteBookmarkData:(NSArray *)deleteBookmarkList {
    // ブックマークデータを一括削除
    NSMutableDictionary *newBookmarkDict = [[NSMutableDictionary alloc] init];
    for (BookmarkData *bookmark in [_bookmarkDict objectEnumerator]) {
        NSUInteger index = [deleteBookmarkList indexOfObject:bookmark];
        if (index == NSNotFound) {
            [newBookmarkDict setObject:bookmark forKey:bookmark.dataId];
        }
    }
    _bookmarkDict = newBookmarkDict;
}

- (void)deleteCategoryData:(CategoryData *)deleteCategory {
    // カテゴリデータの削除
    NSMutableDictionary *newCategoryDict = [[NSMutableDictionary alloc] init];
    for (CategoryData *category in [_categoryDict objectEnumerator]) {
        if (![category isEqual:deleteCategory]) {
            [newCategoryDict setObject:category forKey:category.dataId];
        }
    }
    _categoryDict = newCategoryDict;
}

- (void)deletePageData:(PageData *)deletePage {
    // ページデータの削除
    NSMutableDictionary *newPageDict = [[NSMutableDictionary alloc] init];
    for (PageData *page in [_pageDict objectEnumerator]) {
        if (![page isEqual:deletePage]) {
            [newPageDict setObject:page forKey:page.dataId];
        }
    }
    _pageDict = newPageDict;
}

//--------------------------------------------------------------//
#pragma mark -- Private Method --
//--------------------------------------------------------------//

- (void)_updateResponseData:(NSDictionary *)jsonData {
    // webから取得したjsonDataの反映
    LOG(@"== %@ response Data ==\n%@\n", _selectAuthType.name, jsonData);

    // 追加、更新
    NSDictionary *user = [[jsonData objectForKey:@"update_data"] objectForKey:@"User"];
    if ([user count] > 0) {
        [_user updateWithDictionary:user];
    }

    NSDictionary *design = [[jsonData objectForKey:@"update_data"] objectForKey:@"Design"];
    if ([design count] > 0) {
        [_design updateWithDictionary:design];
    }

    NSDictionary *updatePageList = [[jsonData objectForKey:@"update_data"] objectForKey:@"Page"];
    for (NSString *key in updatePageList) {
        PageData *data;
        if (_pageDict[key]) {
            [_pageDict[key] updateWithDictionary:updatePageList[key]];
            data = _pageDict[key];
            [_pageDict removeObjectForKey:key];
        } else {
            data = [[PageData alloc] initWithDictionary:updatePageList[key]];
        }
        [_pageDict setObject:data forKey:data.dataId];
    }

    NSDictionary *updateCategoryList = [[jsonData objectForKey:@"update_data"] objectForKey:@"Category"];
    for (NSString *key in updateCategoryList) {
        CategoryData *data;
        if (_categoryDict[key]) {
            [_categoryDict[key] updateWithDictionary:updateCategoryList[key]];
            data = _categoryDict[key];
            [_categoryDict removeObjectForKey:key];
        } else {
            data = [[CategoryData alloc] initWithDictionary:updateCategoryList[key]];
        }
        [_categoryDict setObject:data forKey:data.dataId];
    }

    NSDictionary *updateBookmarkList = [[jsonData objectForKey:@"update_data"] objectForKey:@"Bookmark"];
    for (NSString *key in updateBookmarkList) {
        BookmarkData *data;
        if (_bookmarkDict[key]) {
            [_bookmarkDict[key] updateWithDictionary:updateBookmarkList[key]];
            data = _bookmarkDict[key];
            [_bookmarkDict removeObjectForKey:key];
        } else {
            data = [[BookmarkData alloc] initWithDictionary:updateBookmarkList[key]];
        }
        [_bookmarkDict setObject:data forKey:data.dataId];
    }

    // 削除
    [self _deleteData:_pageDict SyncData:[[jsonData objectForKey:@"delete_data"] objectForKey:@"Page"]];
    [self _deleteData:_categoryDict SyncData:[[jsonData objectForKey:@"delete_data"] objectForKey:@"Category"]];
    [self _deleteData:_bookmarkDict SyncData:[[jsonData objectForKey:@"delete_data"] objectForKey:@"Bookmark"]];
}

- (void)_deleteData:(NSMutableDictionary *)currentData SyncData:(NSArray *)deleleData {
    // サーバー側で行った削除の反映
    for (NSString *deleteId in deleleData) {
        [currentData removeObjectForKey:deleteId];
    }
}

- (void)_insertData:(NSDictionary *)jsonData {
    // webから取得したjsonDataを格納
    NSDictionary *user = [jsonData objectForKey:@"user"];
    NSArray *pageList = [jsonData objectForKey:@"page_list"];
    NSArray *categoryList = [jsonData objectForKey:@"category_list"];
    NSArray *bookmarkList = [jsonData objectForKey:@"bookmark_list"];
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

    [_design updateWithDictionary:design];
}

//--------------------------------------------------------------//
#pragma mark-- Serialize --
//--------------------------------------------------------------//

- (NSString *)_userDirPath:(NSString *)directory {
    // ドキュメントPathを取得する
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([paths count] < 1) {
        return nil;
    }
    NSString *documentPath = [paths objectAtIndex:0];

    // .UserDataディレクトリを作成する
    documentPath = [documentPath stringByAppendingPathComponent:directory];
    return documentPath;
}

- (NSString *)_datafilePath:(NSString *)fileName {
    // データファイルまでのPathを作成する
    NSString *fullName = [NSString stringWithFormat:@"%@.dat", fileName];
    NSString *path = [[self _userDirPath:@".UserData"] stringByAppendingPathComponent:fullName];
    return path;
}

- (void)loadAuthType {
    NSString *filePath = [self _datafilePath:kSaveAuthTypeFileName];
    if (!filePath || ![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return;
    }
    id loadData = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (!loadData) {
        return;
    }
    _selectAuthType = (SelectAuthTypeData *)loadData;
    LOG(@"== loadType ==\n%@\n", _selectAuthType.name);
}

- (void)saveAuthType {

    NSFileManager *fileMgr = [NSFileManager defaultManager];

    // .UserDataディレクトリを作成する
    NSString *DirName = [NSString stringWithFormat:@"%@", @".UserData"];
    NSString *userDirPath = [self _userDirPath:DirName];
    if (![fileMgr fileExistsAtPath:userDirPath]) {
        NSError *error;
        [fileMgr createDirectoryAtPath:userDirPath withIntermediateDirectories:YES attributes:nil error:&error];
    }

    // ファイルパスを取得する
    NSString *filePath = [self _datafilePath:kSaveAuthTypeFileName];
    LOG(@"== Save SelectAuth Data ==\n%@\n", _selectAuthType.name);
    [NSKeyedArchiver archiveRootObject:_selectAuthType toFile:filePath];
}


- (void)load {
    LOG(@"== %@ load ==\n", _selectAuthType.name);

    for (int idx = 0; idx < LastSave; ++idx) {
        // ファイルパスを取得する
        NSString *fileName = [NSString stringWithFormat:@"%@/%@", _selectAuthType.name, kSaveFileNameList[idx]];
        NSString *filePath = [self _datafilePath:fileName];
        if (!filePath || ![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            continue;
        }

        // データを読み込む
        id loadData = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        if (!loadData) {
            continue;
        }

        switch (idx) {
            case SAVE_USER: {
                LOG(@"== load Uer Data ==\n%@\n", (UserData *)loadData);
                _user = (UserData *)loadData;
                break;
            };
            case SAVE_DESIGN: {
                LOG(@"== load Design Data ==\n%@\n", (DesignData *)loadData);
                _design = (DesignData *)loadData;
                break;
            };
            case SAVE_BOOKMARK: {
                LOG(@"== load Bookmark Data ==\n%@\n", (NSMutableDictionary *)loadData);
                _bookmarkDict = (NSMutableDictionary *)loadData;
                break;
            };
            case SAVE_CATEGORY: {
                LOG(@"== load Category Data ==\n%@\n", (NSMutableDictionary *)loadData);
                _categoryDict = (NSMutableDictionary *)loadData;
                break;
            };
            case SAVE_PAGE: {
                LOG(@"== load Page Data ==\n%@\n", (NSMutableDictionary *)loadData);
                _pageDict = (NSMutableDictionary *)loadData;
                break;
            };
            case SAVE_SYNC: {
                LOG(@"== load Sync Data ==\n%@\n", (NSMutableDictionary *)loadData);
                _syncData = (NSMutableDictionary *)loadData;
                break;
            };
        }
    }
}

- (void)save:(int)saveIdx {

    NSFileManager *fileMgr = [NSFileManager defaultManager];

    // .UserDataディレクトリを作成する
    NSString *DirName = [NSString stringWithFormat:@"%@/%@", @".UserData", _selectAuthType.name];
    NSString *userDirPath = [self _userDirPath:DirName];
    if (![fileMgr fileExistsAtPath:userDirPath]) {
        NSError *error;
        [fileMgr createDirectoryAtPath:userDirPath withIntermediateDirectories:YES attributes:nil error:&error];
    }

    // ファイルパスを取得する
    NSString *fileName = [NSString stringWithFormat:@"%@/%@", _selectAuthType.name, kSaveFileNameList[saveIdx]];
    NSString *filePath = [self _datafilePath:fileName];

    // Dataを保存する
    switch (saveIdx) {
        case SAVE_USER: {
            LOG(@"== %@ Save Uer Data ==\n%@\n", _selectAuthType.name, _user);
            [NSKeyedArchiver archiveRootObject:_user toFile:filePath];
            break;
        };
        case SAVE_DESIGN: {
            LOG(@"== %@ Save Design Data ==\n%@\n", _selectAuthType.name, _design);
            [NSKeyedArchiver archiveRootObject:_design toFile:filePath];
            break;
        };
        case SAVE_BOOKMARK: {
            LOG(@"== %@ Save Bookmark Data ==\n%@\n", _selectAuthType.name, _bookmarkDict);
            [NSKeyedArchiver archiveRootObject:_bookmarkDict toFile:filePath];
            break;
        };
        case SAVE_CATEGORY: {
            LOG(@"== %@ Save Category Data ==\n%@\n", _selectAuthType.name, _categoryDict);
            [NSKeyedArchiver archiveRootObject:_categoryDict toFile:filePath];
            break;
        };
        case SAVE_PAGE: {
            LOG(@"== %@ Save Page Data ==\n%@\n", _selectAuthType.name, _pageDict);
            [NSKeyedArchiver archiveRootObject:_pageDict toFile:filePath];
            break;
        };
        case SAVE_SYNC: {
            LOG(@"== %@ Save Sync Data ==\n%@\n", _selectAuthType.name, _syncData);
            [NSKeyedArchiver archiveRootObject:_syncData toFile:filePath];
            break;
        };
    }
}

//--------------------------------------------------------------//
#pragma mark-- Sync --
//--------------------------------------------------------------//

- (NSMutableDictionary *)_restSyncData {
    // 同期用のデータDictionaryを生成
    NSMutableDictionary * (^block)(void) = ^() {
        NSMutableDictionary *baseData = [@{
                                             @"insert" : [[NSMutableDictionary alloc] init],
                                             @"update" : [[NSMutableDictionary alloc] init],
                                             @"delete" : [[NSMutableDictionary alloc] init]
                                         } mutableCopy];
        return baseData;
    };

    NSMutableDictionary *syncData = [@{
                                         kSaveFileNameList[SAVE_USER] : [[NSMutableArray alloc] init],
                                         kSaveFileNameList[SAVE_DESIGN] : [[NSMutableArray alloc] init],
                                         kSaveFileNameList[SAVE_BOOKMARK] : block(),
                                         kSaveFileNameList[SAVE_CATEGORY] : block(),
                                         kSaveFileNameList[SAVE_PAGE] : block()
                                     } mutableCopy];
    return syncData;
}

- (NSMutableDictionary *)getSyncData {
    // userDataのIDは同期時に必ず必要なため、更新がなくても含める
    NSDictionary *userData = _syncData[kSaveFileNameList[SAVE_USER]];
    if ([userData count] == 0) {
        NSMutableDictionary *userSyncData = [[NSMutableDictionary alloc] init];
        userSyncData[@"id"] = _user.dataId;
        _syncData[kSaveFileNameList[SAVE_USER]] = userSyncData;
    } else {
        _syncData[kSaveFileNameList[SAVE_USER]][@"id"] = _user.dataId;
    }
    return _syncData;
}

- (void)updateSyncData:(id<DataInterface>)data DataType:(int)dataType Action:(NSString *)action {
    // データ更新時間をセット
    [data iUpdateAt];

    // 同期用のデータを取得
    NSMutableDictionary *syncData = [data iSyncData];

    // 同期用のデータを更新
    switch (dataType) {
        case SAVE_USER:
            _syncData[kSaveFileNameList[SAVE_USER]] = syncData;
            break;
        case SAVE_DESIGN:
            _syncData[kSaveFileNameList[SAVE_DESIGN]] = syncData;
            break;
        case SAVE_BOOKMARK:
            _syncData[kSaveFileNameList[SAVE_BOOKMARK]][action][syncData[@"id"]] = syncData;
            break;
        case SAVE_CATEGORY:
            _syncData[kSaveFileNameList[SAVE_CATEGORY]][action][syncData[@"id"]] = syncData;
            break;
        case SAVE_PAGE:
            _syncData[kSaveFileNameList[SAVE_PAGE]][action][syncData[@"id"]] = syncData;
            break;
    }

    [self save:SAVE_SYNC];
}

@end
