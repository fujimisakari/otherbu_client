//
//  SearchData.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "AuthTypeData.h"

@implementation AuthTypeData

//--------------------------------------------------------------//
#pragma mark -- initialize --
//--------------------------------------------------------------//

- (id)initWithDictionary:(NSDictionary *)dataDict {
    self = [super init];
    if (self) {
        _dataId = dataDict[@"dataId"];
        _name = dataDict[@"name"];
        _iconName = dataDict[@"iconName"];
        _sort = [dataDict[@"sort"] integerValue];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"dataId=%@, name=%@, iconName=%@, sort=%ld", _dataId, _name, _iconName, _sort];
}

//--------------------------------------------------------------//
#pragma mark -- Data Intaface --
//--------------------------------------------------------------//

- (NSInteger)iGetMenuId {
    return MENU_LOGIN;
}

- (NSString *)iGetTitleName {
    return kMenuLoginName;
}

- (NSString *)iGetName {
    return _name;
}

@end
