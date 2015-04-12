//
//  Page.h
//  Command
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "../DataInterface.h"

@class ColorData;

@interface PageData : NSObject<DataInterface>

@property(nonatomic) NSInteger dataId;          // ID
@property(nonatomic) NSInteger userId;          // ユーザーID
@property(nonatomic) NSString  *name;           // カテゴリ名
@property(nonatomic) NSString  *categoryIdsStr; // ページに含むカテゴリ
@property(nonatomic) NSString  *angleIdsStr;    // ページに含むカテゴリ位置
@property(nonatomic) NSString  *sortIdsStr;     // ページに含むカテゴリ順番
@property(nonatomic) NSInteger sortId;          // 表示順
@property(nonatomic) NSInteger colorId;         // カラーID

- (id)initWithDictionary:(NSDictionary *)dataDict;

- (NSMutableArray *)getCategoryList;
- (NSMutableArray *)getCategoryListByTag:(NSInteger)tag;
- (NSMutableDictionary *)getCategoryListOfAngle;
- (void)updatePageData:(CategoryData *)category isCheckMark:(BOOL)isCheckMark;
- (ColorData *)color;

@end
