//
//  UserData.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

@interface UserData : NSObject<NSCoding>

@property(nonatomic) NSString *dataId;   // ID
@property(nonatomic) NSString *type;     // FaceBook or Twitter
@property(nonatomic) NSString *typeId;   // typeのユニークID
@property(nonatomic) NSString *pageId;   // 現在ページ
@property(nonatomic) NSString *searchId; // 検索サイト

- (id)init;
- (void)updateWithDictionary:(NSDictionary *)dataDict;

- (PageData *)page;
- (SearchData *)search;
- (void)updatePage:(NSString *)dataId;
- (void)updateSearch:(NSString *)dataId;

@end
