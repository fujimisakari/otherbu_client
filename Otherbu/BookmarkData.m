//
//  Bookmark.m
//  Command
//
//  Created by fujimisakari on 2015/02/11.
//  Copyright (c) 2015年 fujimisakari. All rights reserved.
//

#import "BookmarkData.h"

@implementation BookmarkData

- (id)initWithDictionary:(NSDictionary *)dataDict {
    self = [super init];
    if (self) {
        self.dataId = [dataDict[@"id"] integerValue];
        self.userId = [dataDict[@"user_id"] integerValue];
        self.categoryId = [dataDict[@"category_id"] integerValue];
        self.name = dataDict[@"name"];
        self.url = dataDict[@"url"];
        self.sort = [dataDict[@"sort"] integerValue];
    }
    return self;
}

- (NSString *)description {
    return [NSString
        stringWithFormat:@"dataId=%ld, userId=%ld categoryId=%ld name=%@, url=%@, sort=%ld", _dataId, _userId, _categoryId, _name, _url, _sort];
}

- (CategoryData *)category {
    NSNumber *number = [[NSNumber alloc] initWithInt:(int)_categoryId];
    return [[DataManager sharedManager] getCategory:number];
}

@end
