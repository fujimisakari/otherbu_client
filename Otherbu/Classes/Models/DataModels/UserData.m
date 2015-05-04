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
    return [NSString stringWithFormat:@"dataId=%@, type=%@, typeId=%@, page=%@, searchId=%@", _dataId, _type, _typeId, _pageId, _searchId];
}

//--------------------------------------------------------------//
#pragma mark -- Public Method --
//--------------------------------------------------------------//

- (PageData *)page {
    return [[DataManager sharedManager] getPage:_pageId];
}

- (SearchData *)search {
    return [[DataManager sharedManager] getSearch:_searchId];
}

- (void)updatePage:(NSString *)dataId {
    self.pageId = dataId;
}

- (void)updateSearch:(NSString *)dataId {
    self.searchId = dataId;
}

//--------------------------------------------------------------//
#pragma mark -- 永続化 --
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

@end
