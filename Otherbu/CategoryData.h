//
//  Category.h
//  Command
//
//  Created by fujimisakari on 2015/02/11.
//  Copyright (c) 2015年 fujimisakari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"

@interface CategoryData : NSObject

@property(nonatomic) NSInteger dataId;   // ID
@property(nonatomic) NSInteger userId;   // ユーザーID
@property(nonatomic) NSString *name;     // Bookmark名
@property(nonatomic) NSInteger angle;    // 位置
@property(nonatomic) NSInteger sort;     // Sort番号
@property(nonatomic) NSInteger colorId;  // カテゴリカラーID
@property(nonatomic) NSInteger tagOpen;  // 初期開放

- (id)initWithDictionary:(NSDictionary *)dataDict;
- (NSArray *)getBookmarkList;

@end
