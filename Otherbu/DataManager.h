//
//  DataManager.h
//  Command
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

@class PageData, CategoryData, BookmarkData, ColorData, DesignData;

@interface DataManager : NSObject

@property(nonatomic) NSMutableDictionary *pageDict;
@property(nonatomic) NSMutableDictionary *categoryDict;
@property(nonatomic) NSMutableDictionary *bookmarkDict;
@property(nonatomic) NSMutableDictionary *colorDict;

+ (DataManager *)sharedManager;

- (void)reloadDataWithBlock:(void (^)(NSError *error))block;
- (PageData *)getPage:(NSNumber *)dataId;
- (CategoryData *)getCategory:(NSNumber *)dataId;
- (BookmarkData *)getBookmark:(NSNumber *)dataId;
- (ColorData *)getColor:(NSNumber *)dataId;
- (DesignData *)getDesign;
- (NSMutableArray *)getCategoryList;
- (NSMutableArray *)getPageList;
- (NSMutableArray *)getColorList;

@end
