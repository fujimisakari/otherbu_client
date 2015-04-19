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
        self.dataId = [dataDict[@"id"] stringValue];
        self.userId = [dataDict[@"user_id"] integerValue];
        self.name = dataDict[@"name"];
        self.angle = [dataDict[@"angle"] integerValue];
        self.sort = [dataDict[@"sort"] integerValue];
        self.colorId = [dataDict[@"color_id"] stringValue];
        self.isOpenSection = [dataDict[@"tag_open"] boolValue];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"dataId=%@, userId=%ld name=%@ angle=%ld, sort=%ld, colorId=%@, isOpenSection=%d", _dataId, _userId,
                                      _name, _angle, _sort, _colorId, _isOpenSection];
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
    return (self.dataId) ? YES : NO;
}

- (NSInteger)iGetMenuId {
    return MENU_CATEGORY;
}

- (NSString *)iGetTitleName {
    return kMenuCategoryName;
}

- (NSString *)iGetName {
    return self.name;
}

- (void)iSetName:(NSString *)name {
    self.name = name;
}

- (NSString *)iGetColorId {
    return self.colorId;
}

- (void)iSetColorId:(NSString *)colorId {
    self.colorId = colorId;
}

@end
