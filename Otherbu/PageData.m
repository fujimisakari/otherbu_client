//
//  Page.m
//  Command
//
//  Created by fujimisakari on 2015/02/11.
//  Copyright (c) 2015年 fujimisakari. All rights reserved.
//

#import "PageData.h"

@implementation PageData

- (id)initWithDictionary:(NSDictionary *)dataDict {
    self = [super init];
    if (self) {
        self.dataId = [dataDict[@"id"] integerValue];
        self.userId = [dataDict[@"user_id"] integerValue];
        self.name = dataDict[@"name"];
        self.categoryIdsStr = dataDict[@"category_ids_str"];
        self.angleIdsStr = dataDict[@"angle_ids_str"];
        self.sortIdsStr = dataDict[@"sort_ids_str"];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"dataId=%ld, userId=%ld name=%@ categoryIdsStr=%@, angleIdsStr=%@, sortIdsStr=%@", _dataId, _userId,
                                      _name, _categoryIdsStr, _angleIdsStr, _sortIdsStr];
}

- (NSMutableArray *)getCategoryList {
    DataManager *dataManager = [DataManager getInstance];
    NSMutableArray *resultList = [[NSMutableArray alloc] init];

    NSArray *categoryIdList = [_categoryIdsStr componentsSeparatedByString:@","];
    for (id categoryId in categoryIdList) {
        NSNumber *number = [[NSNumber alloc] initWithInt:[categoryId intValue]];
        CategoryData *data = [dataManager getCategory:number];
        if (data) {
            [resultList addObject:data];
        }
    }
    return resultList;
}

- (NSMutableDictionary *)getCategoryListOfAngle {
    DataManager *dataManager = [DataManager getInstance];

    // アングル別のカテゴリリストを生成
    NSMutableDictionary *angleDict = [self getMapByArg:_angleIdsStr];
    NSMutableDictionary *tmpResultDict = [@{[NSNumber numberWithInt: LEFT]: [[NSMutableArray alloc] init],
                                            [NSNumber numberWithInt: CENTER]: [[NSMutableArray alloc] init],
                                            [NSNumber numberWithInt: RIGHT]: [[NSMutableArray alloc] init]
                                          } mutableCopy];
    for (NSNumber *categoryId in angleDict) {
        CategoryData *data = [dataManager getCategory:categoryId];
        if (data) {
            NSNumber *angleId = angleDict[categoryId];
            [tmpResultDict[angleId] addObject:data];
        }
    }

    // アングル別のカテゴリリストをソートする
    NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *sortDict = [self getMapByArg:_sortIdsStr];
    for (NSNumber *angleId in tmpResultDict) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:tmpResultDict[angleId]];
        for (CategoryData *category in tmpResultDict[angleId]) {
            NSNumber *categoryId = [[NSNumber alloc] initWithInt:(int)category.dataId];
            NSNumber *sortId = sortDict[categoryId];
            int idx = (int)[sortId integerValue] - 1;
            array[idx] = category;
        }
        resultDict[angleId] = array;
    }
    return resultDict;
}

- (NSMutableDictionary *)getMapByArg:(NSString *)strData {
    NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] init];
    NSArray *list_ = [strData componentsSeparatedByString:@","];
    for (id data in list_) {
        // NSString *data_ = (NSString *)data;
        NSArray *aList = [(NSString *)data componentsSeparatedByString:@":"];
        NSNumber *categoryId = [[NSNumber alloc] initWithInt:[aList[0] intValue]];
        NSNumber *argId = [[NSNumber alloc] initWithInt:[aList[1] intValue]];
        [resultDict setObject:argId forKey:categoryId];
    }
    return resultDict;
}

@end