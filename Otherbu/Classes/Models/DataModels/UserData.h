//
//  UserData.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "DataInterface.h"

@interface UserData : NSObject<DataInterface, NSCoding>

@property(nonatomic) NSString *dataId;    // ID
@property(nonatomic) NSString *name;      // アカンウトのユーザー名
@property(nonatomic) NSString *type;      // FaceBook or Twitter
@property(nonatomic) NSString *typeId;    // typeのユニークID
@property(nonatomic) NSString *pageId;    // 現在ページ
@property(nonatomic) NSString *searchId;  // 検索サイト
@property(nonatomic) NSDate   *updatedAt; // 更新時間

- (id)init;
- (void)updateWithDictionary:(NSDictionary *)dataDict;

- (PageData *)page;
- (AccountTypeData *)accountType;
- (SearchData *)search;
- (void)updatePage:(NSString *)dataId;
- (void)updateSearch:(NSString *)dataId;

- (void)Login:(NSString *)name Type:(NSString *)type TypeId:(NSString *)typeId;
- (void)Logout;
- (BOOL)isLogin;

@end
