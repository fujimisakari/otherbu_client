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
        self.dataId = [[NSUUID UUID] UUIDString];
        self.pageId = 0;
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dataDict {
    self = [super init];
    if (self) {
        self.dataId = dataDict[@"id"];
        self.type = dataDict[@"type"];
        self.typeId = dataDict[@"typeId"];
        self.pageId = [dataDict[@"pageId"] integerValue];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"dataId=%@, type=%@ typeId=%@ page=%ld", _dataId, _type, _typeId, _pageId];
}

//--------------------------------------------------------------//
#pragma mark -- Public Method --
//--------------------------------------------------------------//

- (PageData *)page {
    NSNumber *number = [[NSNumber alloc] initWithInt:(int)_pageId];
    return [[DataManager sharedManager] getPage:number];
}

@end
