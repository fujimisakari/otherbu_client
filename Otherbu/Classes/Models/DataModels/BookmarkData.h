//
//  Bookmark.h
//  Command
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

# import "DataInterface.h"

@class CategoryData;

@interface BookmarkData : NSObject<DataInterface, NSCoding>

@property(nonatomic) NSString  *dataId;      // ID
@property(nonatomic) NSString  *categoryId;  // カテゴリID
@property(nonatomic) NSString  *name;        // Bookmark名
@property(nonatomic) NSString  *url;         // URL
@property(nonatomic) NSInteger sort;         // Sort番号
@property(nonatomic) NSDate    *updatedAt;   // 更新時間

- (id)initWithDictionary:(NSDictionary *)dataDict;
- (void)updateWithDictionary:(NSDictionary *)dataDict;

- (CategoryData *)category;

@end
