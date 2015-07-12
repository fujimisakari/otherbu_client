//
//  Category.m
//  Command
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "CategoryData.h"
#import "BookmarkData.h"

@implementation CategoryData

//--------------------------------------------------------------//
#pragma mark -- initialize --
//--------------------------------------------------------------//

- (id)initWithDictionary:(NSDictionary *)dataDict {
    self = [super init];
    if (self) {
        _dataId = [dataDict[@"id"] stringValue];
        _name = dataDict[@"name"];
        _angle = [dataDict[@"angle"] integerValue];
        _sort = [dataDict[@"sort"] integerValue];
        _colorId = [dataDict[@"color_id"] stringValue];
        _isOpenSection = [dataDict[@"tag_open"] boolValue];
    }
    return self;
}

- (void)updateWithDictionary:(NSDictionary *)dataDict {
    _dataId = [dataDict[@"id"] stringValue];
    _name = dataDict[@"name"];
    _angle = [dataDict[@"angle"] integerValue];
    _sort = [dataDict[@"sort"] integerValue];
    _colorId = [dataDict[@"color_id"] stringValue];
    _isOpenSection = [dataDict[@"tag_open"] boolValue];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"dataId=%@, name=%@, angle=%ld, sort=%ld, colorId=%@, isOpenSection=%d, updatedAt=%@", _dataId,
                                      _name, _angle, _sort, _colorId, _isOpenSection, _updatedAt];
}

//--------------------------------------------------------------//
#pragma mark -- Public Method --
//--------------------------------------------------------------//

- (NSMutableArray *)getBookmarkList {
    // ブックマークリストを生成
    NSMutableArray *itemList = [[NSMutableArray alloc] init];
    DataManager *dataManager = [DataManager sharedManager];
    for (BookmarkData *bookmark in [dataManager.bookmarkDict objectEnumerator]) {
        if ([bookmark.categoryId isEqualToString:_dataId]) {
            [itemList addObject:bookmark];
        }
    }
    // sort番号で昇順ソート
    NSArray *tmpResultList = [Helper doSortArrayWithKey:@"sort" Array:itemList];
    NSMutableArray *resultList = [tmpResultList mutableCopy];
    return resultList;
}

- (ColorData *)color {
    return [[DataManager sharedManager] getColor:_colorId];
}

//--------------------------------------------------------------//
#pragma mark -- Data Intaface --
//--------------------------------------------------------------//

- (BOOL)isCreateMode {
    return (self.dataId == nil) ? YES : NO;
}

- (void)addNewData {
    _dataId = [Helper generateId];
    _angle = LEFT;
    _sort = [DataManager sharedManager].categoryDict.count + 1;
    _isOpenSection = NO;
    [[DataManager sharedManager] addCategory:self];
}

- (NSInteger)iGetMenuId {
    return MENU_CATEGORY;
}

- (NSString *)iGetTitleName {
    return kMenuCategoryName;
}

- (NSString *)iGetName {
    return _name;
}

- (void)iSetName:(NSString *)name {
    _name = name;
}

- (NSString *)iGetColorId {
    return _colorId;
}

- (void)iSetColorId:(NSString *)colorId {
    _colorId = colorId;
}

- (void)iUpdateAt {
    _updatedAt = [[NSDate alloc] init];
}

//--------------------------------------------------------------//
#pragma mark -- Serialize --
//--------------------------------------------------------------//

- (id)initWithCoder:(NSCoder *)decoder {
    // インスタンス変数をデコードする
    self = [super init];
    if (!self) {
        return nil;
    }

    _dataId = [decoder decodeObjectForKey:@"dataId"];
    _name = [decoder decodeObjectForKey:@"name"];
    _angle = [decoder decodeIntegerForKey:@"angle"];
    _sort = [decoder decodeIntegerForKey:@"sort"];
    _colorId = [decoder decodeObjectForKey:@"colorId"];
    _isOpenSection = [decoder decodeBoolForKey:@"isOpenSection"];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    // インスタンス変数をエンコードする
    [encoder encodeObject:_dataId forKey:@"dataId"];
    [encoder encodeObject:_name forKey:@"name"];
    [encoder encodeInteger:_angle forKey:@"angle"];
    [encoder encodeInteger:_sort forKey:@"sort"];
    [encoder encodeObject:_colorId forKey:@"colorId"];
    [encoder encodeBool:_isOpenSection forKey:@"isOpenSection"];
}

//--------------------------------------------------------------//
#pragma mark -- Sync --
//--------------------------------------------------------------//

- (NSDictionary *)iSyncData {
    NSMutableDictionary *syncData = [[NSMutableDictionary alloc] init];
    syncData[@"id"] = _dataId;
    syncData[@"name"] = _name;
    syncData[@"angle"] = [Helper getNumberByInt:(int)_angle];
    syncData[@"sort"] = [Helper getNumberByInt:(int)_sort];
    syncData[@"color_id"] = _colorId;
    syncData[@"tag_open"] = [Helper getNumberByInt:(int)_isOpenSection];
    syncData[@"updated_at"] = [Helper convertDateToString:_updatedAt];
    return syncData;
}

@end
