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
        self.dataId = [[NSUUID UUID] UUIDString];
        self.pageId = 0;
    }
    return self;
}

- (void)updateWithDictionary:(NSDictionary *)dataDict {
    self.dataId = dataDict[@"id"];
    self.type = dataDict[@"type"];
    self.typeId = dataDict[@"type_id"];
    self.pageId = [dataDict[@"page_id"] integerValue];
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

- (void)updatePage:(NSInteger)pageId {
    self.pageId = pageId;
}


@end
