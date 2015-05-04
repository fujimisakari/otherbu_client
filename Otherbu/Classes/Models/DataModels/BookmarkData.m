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
        _dataId = [dataDict[@"id"] stringValue];
        _categoryId = [dataDict[@"category_id"] stringValue];
        _name = dataDict[@"name"];
        _url = dataDict[@"url"];
        _sort = [dataDict[@"sort"] integerValue];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"dataId=%@, categoryId=%@, name=%@, url=%@, sort=%ld", _dataId, _categoryId, _name, _url, _sort];
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
    return (_dataId == nil) ? YES : NO;
}

- (void)addNewData {
    _dataId = [Helper generateId];
    _sort = [[self category] getBookmarkList].count + 1;
    [[DataManager sharedManager] addBookmark:self];
}

- (NSInteger)iGetMenuId {
    return MENU_BOOKMARK;
}

- (NSString *)iGetTitleName {
    return kMenuBookmarkName;
}

- (NSString *)iGetName {
    return _name;
}

- (void)iSetName:(NSString *)name {
    _name = name;
}

- (NSString *)iGetUrl {
    return _url;
}

- (void)iSetUrl:(NSString *)url {
    _url = url;
}

- (NSString *)iGetCategoryId {
    return _categoryId;
}

- (void)iSetCategoryId:(NSString *)categoryId {
    _categoryId = categoryId;
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
    _categoryId = [decoder decodeObjectForKey:@"categoryId"];
    _name = [decoder decodeObjectForKey:@"name"];
    _url = [decoder decodeObjectForKey:@"url"];
    // _sort = [decoder decodeObjectForKey:@"sort"];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    // インスタンス変数をエンコードする
    [encoder encodeObject:_dataId forKey:@"dataId"];
    [encoder encodeObject:_categoryId forKey:@"categoryId"];
    [encoder encodeObject:_name forKey:@"name"];
    [encoder encodeObject:_url forKey:@"url"];
    // [encoder encodeObject:_sort forKey:@"sort"];
}

@end
