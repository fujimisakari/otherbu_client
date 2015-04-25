//
//  Bookmark.m
//  Command
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "BookmarkData.h"
#import "CategoryData.h"

@implementation BookmarkData

//--------------------------------------------------------------//
#pragma mark -- initialize --
//--------------------------------------------------------------//

- (id)initWithDictionary:(NSDictionary *)dataDict {
    self = [super init];
    if (self) {
        self.dataId = [dataDict[@"id"] stringValue];
        self.userId = [dataDict[@"user_id"] integerValue];
        self.categoryId = [dataDict[@"category_id"] stringValue];
        self.name = dataDict[@"name"];
        self.url = dataDict[@"url"];
        self.sort = [dataDict[@"sort"] integerValue];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"dataId=%@, userId=%ld categoryId=%@ name=%@, url=%@, sort=%ld", _dataId, _userId, _categoryId,
                                      _name, _url, _sort];
}

//--------------------------------------------------------------//
#pragma mark -- Public Method --
//--------------------------------------------------------------//

- (CategoryData *)category {
    return [[DataManager sharedManager] getCategory:_categoryId];
}

//--------------------------------------------------------------//
#pragma mark -- Data Intaface --
//--------------------------------------------------------------//

- (BOOL)isCreateMode {
    return (self.dataId == nil) ? YES : NO;
}

- (void)addNewData {
    self.dataId = [Helper generateId];
    self.sort = [[self category] getBookmarkList].count + 1;
    [[DataManager sharedManager] addBookmark:self];
}

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

- (NSString *)iGetCategoryId {
    return self.categoryId;
}

- (void)iSetCategoryId:(NSString *)categoryId {
    self.categoryId = categoryId;
}

@end
