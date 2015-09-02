//
//  UserData.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "UserData.h"
#import "AccountTypeData.h"

@implementation UserData

//--------------------------------------------------------------//
#pragma mark -- initialize --
//--------------------------------------------------------------//

- (id)init {
    self = [super init];
    if (self) {
        _dataId = kDefaultUserDataId;
        _pageId = kDefaultPageDataId;
        _searchId = kDefaultSearchDataId;
    }
    return self;
}

- (void)updateWithDictionary:(NSDictionary *)dataDict {
    _dataId = [dataDict[@"id"] stringValue];
    _pageId = [dataDict[@"page_id"] stringValue];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"dataId=%@, name=%@, type=%@, typeId=%@, page=%@, searchId=%@, updatedAt=%@",
                     _dataId, _name, _type, _typeId, _pageId, _searchId, _updatedAt];
}

//--------------------------------------------------------------//
#pragma mark -- Public Method --
//--------------------------------------------------------------//

- (PageData *)page {
    PageData *page = [[DataManager sharedManager] getPage:_pageId];
    if (!page) {
        page = [[DataManager sharedManager] getPage:kDefaultPageDataId];
        _pageId = kDefaultPageDataId;
        [[DataManager sharedManager] save:SAVE_USER];
    }
    return page;
}

- (AccountTypeData *)accountType {
    for (AccountTypeData *accountType in [[DataManager sharedManager] getAccountTypeList]) {
        if ([accountType.name isEqualToString:self.type]) {
            return accountType;
        }
    }
    return nil;
}

- (SearchData *)search {
    return [[DataManager sharedManager] getSearch:_searchId];
}

- (void)updatePage:(NSString *)dataId {
    _pageId = dataId;
}

- (void)updateSearch:(NSString *)dataId {
    _searchId = dataId;
}

- (void)iUpdateAt {
    _updatedAt = [[NSDate alloc] init];
}

- (void)Login:(NSString *)name Type:(NSString *)type TypeId:(NSString *)typeId {
    LOG(@"Login - %@", type);
    _name = name;
    _type = type;
    _typeId = typeId;
}

- (void)Logout {
    LOG(@"Logout - %@", _type);
    _dataId = @"0";
    _name = @"";
    _type = nil;
    _typeId = nil;
}

- (BOOL)isLogin {
    return (![_dataId isEqualToString:@"0"] && _type && _typeId) ? YES : NO;
}

//--------------------------------------------------------------//
#pragma mark -- Serialize --
//--------------------------------------------------------------//

- (id)initWithCoder:(NSCoder *)decoder {
    // インスタンス変数をデコードする
    self = [super init];
    if (!self) {
        return nil;
    }

    _dataId = [decoder decodeObjectForKey:@"dataId"];
    _name = [decoder decodeObjectForKey:@"name"];
    _type = [decoder decodeObjectForKey:@"type"];
    _typeId = [decoder decodeObjectForKey:@"typeId"];
    _pageId = [decoder decodeObjectForKey:@"pageId"];
    _searchId = [decoder decodeObjectForKey:@"searchId"];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    // インスタンス変数をエンコードする
    [encoder encodeObject:_dataId forKey:@"dataId"];
    [encoder encodeObject:_name forKey:@"name"];
    [encoder encodeObject:_type forKey:@"type"];
    [encoder encodeObject:_typeId forKey:@"typeId"];
    [encoder encodeObject:_pageId forKey:@"pageId"];
    [encoder encodeObject:_searchId forKey:@"searchId"];
}

//--------------------------------------------------------------//
#pragma mark -- Sync --
//--------------------------------------------------------------//

- (NSDictionary *)iSyncData {
    // 同期Userデータ生成
    NSMutableDictionary *syncData = [[NSMutableDictionary alloc] init];
    syncData[@"id"] = _dataId;
    syncData[@"page_id"] = _pageId;
    syncData[@"updated_at"] = [Helper convertDateToString:_updatedAt];
    return syncData;
}

@end
