//
//  UserData.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "UserData.h"

@implementation UserData

//--------------------------------------------------------------//
#pragma mark -- initialize --
//--------------------------------------------------------------//

- (id)init {
    self = [super init];
    if (self) {
        _dataId = [Helper generateId];
        _pageId = kDefaultPageDataId;
        _searchId = kDefaultSearchDataId;
    }
    return self;
}

- (void)updateWithDictionary:(NSDictionary *)dataDict {
    _dataId = [dataDict[@"id"] stringValue];
    _type = dataDict[@"type"];
    _typeId = dataDict[@"type_id"];
    _pageId = [dataDict[@"page_id"] stringValue];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"dataId=%@, type=%@, typeId=%@, page=%@, searchId=%@, updatedAt=%@", _dataId, _type, _typeId,
                                      _pageId, _searchId, _updatedAt];
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

- (SearchData *)search {
    return [[DataManager sharedManager] getSearch:_searchId];
}

- (void)updatePage:(NSString *)dataId {
    _pageId = dataId;
}

- (void)updateSearch:(NSString *)dataId {
    _searchId = dataId;
}

- (BOOL)isLogin {
    return (_dataId) ? YES : NO;
}

- (void)iUpdateAt {
    _updatedAt = [[NSDate alloc] init];
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
    _type = [decoder decodeObjectForKey:@"type"];
    _typeId = [decoder decodeObjectForKey:@"typeId"];
    _pageId = [decoder decodeObjectForKey:@"pageId"];
    _searchId = [decoder decodeObjectForKey:@"searchId"];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    // インスタンス変数をエンコードする
    [encoder encodeObject:_dataId forKey:@"dataId"];
    [encoder encodeObject:_type forKey:@"type"];
    [encoder encodeObject:_typeId forKey:@"typeId"];
    [encoder encodeObject:_pageId forKey:@"pageId"];
    [encoder encodeObject:_searchId forKey:@"searchId"];
}

//--------------------------------------------------------------//
#pragma mark -- Sync --
//--------------------------------------------------------------//

- (NSDictionary *)iSyncData {
    NSMutableDictionary *syncData = [[NSMutableDictionary alloc] init];
    syncData[@"dataId"] = (_dataId) ? _dataId : @"0";
    syncData[@"type"] = (_type) ? _type : @"";
    syncData[@"typeId"] = (_typeId) ? _typeId : @"";
    syncData[@"page_id"] = _pageId;
    syncData[@"updated_at"] = [Helper convertDateToString:_updatedAt];
    return syncData;
}

@end
