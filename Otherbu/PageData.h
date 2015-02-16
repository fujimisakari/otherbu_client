//
//  Page.h
//  Command
//
//  Created by fujimisakari on 2015/02/11.
//  Copyright (c) 2015年 fujimisakari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"

@interface PageData : NSObject

typedef enum {
    LEFT = 1,
    CENTER,
    RIGHT,
} AngleType;

@property(nonatomic) NSInteger dataId;          // ID
@property(nonatomic) NSInteger userId;          // ユーザーID
@property(nonatomic) NSString *name;            // カテゴリ名
@property(nonatomic) NSString *categoryIdsStr;  // ページに含むカテゴリ
@property(nonatomic) NSString *angleIdsStr;     // ページに含むカテゴリ位置
@property(nonatomic) NSString *sortIdsStr;      // ページに含むカテゴリ順番

- (id)initWithDictionary:(NSDictionary *)dataDict;

- (NSMutableArray *)getCategoryList;
- (NSMutableDictionary *)getCategoryListOfAngle;

@end
