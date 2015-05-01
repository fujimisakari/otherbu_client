//
//  SearchData.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "SearchData.h"

@implementation SearchData

//--------------------------------------------------------------//
#pragma mark -- initialize --
//--------------------------------------------------------------//

- (id)initWithDictionary:(NSDictionary *)dataDict {
    self = [super init];
    if (self) {
        self.dataId = dataDict[@"dataId"];
        self.name = dataDict[@"name"];
        self.url = dataDict[@"url"];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"dataId=%@, name=%@, url=%@", _dataId, _name, _url];
}

//--------------------------------------------------------------//
#pragma mark -- Data Intaface --
//--------------------------------------------------------------//

- (NSInteger)iGetMenuId {
    return MENU_SEARCH;
}

- (NSString *)iGetTitleName {
    return kMenuSearchName;
}

- (NSString *)iGetName {
    return self.name;
}

- (NSString *)iGetUrl {
    return self.url;
}

@end
