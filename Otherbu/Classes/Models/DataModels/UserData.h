//
//  UserData.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

@interface UserData : NSObject

@property(nonatomic) NSString *dataId;  // ID
@property(nonatomic) NSString *type;    // FaceBook or Twitter
@property(nonatomic) NSString *typeId;  // type ID
@property(nonatomic) NSInteger pageId;  // page ID

- (id)init;
- (id)initWithDictionary:(NSDictionary *)dataDict;

- (PageData *)page;

@end
