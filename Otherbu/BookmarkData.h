//
//  Bookmark.h
//  Command
//
//  Created by fujimisakari on 2015/02/11.
//  Copyright (c) 2015年 fujimisakari. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CategoryData;

@interface BookmarkData : NSObject

@property(nonatomic) NSInteger dataId;      // ID
@property(nonatomic) NSInteger userId;      // ユーザーID
@property(nonatomic) NSInteger categoryId;  // カテゴリID
@property(nonatomic) NSString *name;        // Bookmark名
@property(nonatomic) NSString *url;         // URL
@property(nonatomic) NSInteger sort;        // Sort番号

- (id)initWithDictionary:(NSDictionary *)dataDict;

- (CategoryData *)category;

@end
