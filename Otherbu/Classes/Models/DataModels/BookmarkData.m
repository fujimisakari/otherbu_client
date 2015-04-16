//
//  Bookmark.m
//  Command
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "BookmarkData.h"

@implementation BookmarkData

//--------------------------------------------------------------//
#pragma mark -- initialize --
//--------------------------------------------------------------//

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
    return [NSString stringWithFormat:@"dataId=%ld, userId=%ld categoryId=%ld name=%@, url=%@, sort=%ld", _dataId, _userId, _categoryId,
                                      _name, _url, _sort];
}

//--------------------------------------------------------------//
#pragma mark -- Public Method --
//--------------------------------------------------------------//

- (CategoryData *)category {
    NSNumber *number = [[NSNumber alloc] initWithInt:(int)_categoryId];
    return [[DataManager sharedManager] getCategory:number];
}

//--------------------------------------------------------------//
#pragma mark -- Data Intaface --
//--------------------------------------------------------------//

- (NSInteger)iGetMenuId {
    return MENU_BOOKMARK;
}

- (NSString *)iGetTitleName {
    return kMenuBookmarkName;
}

- (NSString *)iGetName {
    return self.name;
}

- (void)iSetName:(NSString *)name {
    self.name = name;
}

- (NSString *)iGetUrl {
    return self.url;
}

- (void)iSetUrl:(NSString *)url {
    self.url = url;
}

- (NSInteger)iGetCategoryId {
    return self.categoryId;
}

- (void)iSetCategoryId:(NSInteger)categoryId {
    self.categoryId = categoryId;
}

@end
