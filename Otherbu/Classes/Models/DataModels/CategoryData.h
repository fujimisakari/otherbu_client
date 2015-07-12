//
//  Category.h
//  Command
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

# import "DataInterface.h"

@class ColorData;

@interface CategoryData : NSObject<DataInterface, NSCoding>

@property(nonatomic) NSString  *dataId;       // ID
@property(nonatomic) NSString  *name;         // カテゴリ名
@property(nonatomic) NSInteger angle;         // 位置
@property(nonatomic) NSInteger sort;          // Sort番号
@property(nonatomic) NSString  *colorId;      // カテゴリカラーID
@property(nonatomic) BOOL      isOpenSection; // 初期開放
@property(nonatomic) NSDate    *updatedAt;    // 更新時間

- (id)initWithDictionary:(NSDictionary *)dataDict;
- (void)updateWithDictionary:(NSDictionary *)dataDict;

- (NSMutableArray *)getBookmarkList;
- (ColorData *)color;

@end
