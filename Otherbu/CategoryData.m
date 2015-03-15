//
//  Category.m
//  Command
//
//  Created by fujimisakari on 2015/02/11.
//  Copyright (c) 2015年 fujimisakari. All rights reserved.
//

#import "CategoryData.h"
#import "DataManager.h"
#import "BookmarkData.h"

@implementation CategoryData

- (id)initWithDictionary:(NSDictionary *)dataDict {
    self = [super init];
    if (self) {
        self.dataId = [dataDict[@"id"] integerValue];
        self.userId = [dataDict[@"user_id"] integerValue];
        self.name = dataDict[@"name"];
        self.angle = [dataDict[@"angle"] integerValue];
        self.sort = [dataDict[@"sort"] integerValue];
        self.colorId = [dataDict[@"color_id"] integerValue];
        self.isOpenSection = [dataDict[@"tag_open"] boolValue];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"dataId=%ld, userId=%ld name=%@ angle=%ld, sort=%ld, colorId=%ld, isOpenSection=%d", _dataId,
                                      _userId, _name, _angle, _sort, _colorId, _isOpenSection];
}

- (NSArray *)getBookmarkList {
    // ブックマークリストを生成
    NSMutableArray *tmpResultList = [[NSMutableArray alloc] init];
    DataManager *dataManager = [DataManager sharedManager];
    for (BookmarkData *bookmarkObj in [dataManager.bookmarkDict objectEnumerator]) {
        if (bookmarkObj.categoryId == (int)_dataId) {
            [tmpResultList addObject:bookmarkObj];
        }
    }

    // ブックマークリストをソート
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sort" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObject:sortDescriptor];
    NSArray *resultList = [tmpResultList sortedArrayUsingDescriptors:sortArray];
    return resultList;
}

- (ColorData *)color {
    NSNumber *number = [[NSNumber alloc] initWithInt:(int)_colorId];
    return [[DataManager sharedManager] getColor:number];
}

@end
