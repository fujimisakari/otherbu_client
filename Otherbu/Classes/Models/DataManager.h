//
//  DataManager.h
//  Command
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

@class UserData, PageData, CategoryData, BookmarkData, ColorData, DesignData;

@interface DataManager : NSObject

@property(nonatomic) NSMutableDictionary *pageDict;
@property(nonatomic) NSMutableDictionary *categoryDict;
@property(nonatomic) NSMutableDictionary *bookmarkDict;
@property(nonatomic) NSMutableDictionary *colorDict;

+ (DataManager *)sharedManager;

- (void)reloadDataWithBlock:(void (^)(NSError *error))block;

- (UserData *)getUser;
- (PageData *)getPage:(NSNumber *)dataId;
- (CategoryData *)getCategory:(NSNumber *)dataId;
- (BookmarkData *)getBookmark:(NSNumber *)dataId;
- (ColorData *)getColor:(NSNumber *)dataId;
- (DesignData *)getDesign;
- (NSMutableArray *)getCategoryList;
- (NSMutableArray *)getPageList;
- (NSArray *)getColorList;

- (NSMutableArray *)deleteCategoryData:(NSMutableArray *)categoryList DeleteIndex:(NSInteger)idx;
- (NSMutableArray *)deletePageData:(NSMutableArray *)pageList DeleteIndex:(NSInteger)idx;

@end
