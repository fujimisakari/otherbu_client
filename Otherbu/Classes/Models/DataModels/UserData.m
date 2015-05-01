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

static UserData *intance = nil;

+ (UserData *)shared {
    if (!intance) {
        intance = [[UserData alloc] init];
    }
    return intance;
}

- (id)init {
    self = [super init];
    if (self) {
        self.dataId = [Helper generateId];
        self.pageId = kDefaultPageDataId;
        self.searchId = kDefaultSearchDataId;
    }
    return self;
}

- (void)updateWithDictionary:(NSDictionary *)dataDict {
    self.dataId = [dataDict[@"id"] stringValue];
    self.type = dataDict[@"type"];
    self.typeId = dataDict[@"type_id"];
    self.pageId = [dataDict[@"page_id"] stringValue];
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

@end
