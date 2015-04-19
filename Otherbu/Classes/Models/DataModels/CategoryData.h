//
//  Category.h
//  Command
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

# import "DataInterface.h"

@class ColorData;

@interface CategoryData : NSObject<DataInterface>

@property(nonatomic) NSString  *dataId;       // ID
@property(nonatomic) NSInteger userId;        // ユーザーID
@property(nonatomic) NSString  *name;         // カテゴリ名
@property(nonatomic) NSInteger angle;         // 位置
@property(nonatomic) NSInteger sort;          // Sort番号
@property(nonatomic) NSString  *colorId;      // カテゴリカラーID
@property(nonatomic) BOOL      isOpenSection; // 初期開放

- (id)initWithDictionary:(NSDictionary *)dataDict;

- (NSMutableArray *)getBookmarkList;
- (ColorData *)color;

@end
