//
//  SearchData.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "AccountTypeData.h"

@implementation AccountTypeData

//--------------------------------------------------------------//
#pragma mark -- initialize --
//--------------------------------------------------------------//

- (id)initWithDictionary:(NSDictionary *)dataDict {
    self = [super init];
    if (self) {
        _dataId = dataDict[@"dataId"];
        _name = dataDict[@"name"];
        _sort = [dataDict[@"sort"] integerValue];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"dataId=%@, name=%@, sort=%ld", _dataId, _name, _sort];
}

//--------------------------------------------------------------//
#pragma mark -- Login Action Methods --
//--------------------------------------------------------------//

- (void)login {
    if ([self.name isEqualToString:@"Twitter"]) {
        [SNSProcess loginByTwitter];
    } else if ([self.name isEqualToString:@"Facebook"]) {
        [SNSProcess loginByFacebook];
    }
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
