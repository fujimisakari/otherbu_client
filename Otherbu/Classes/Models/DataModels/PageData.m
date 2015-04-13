//
//  Page.m
//  Command
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "PageData.h"
#import "CategoryData.h"

@implementation PageData

//--------------------------------------------------------------//
#pragma mark -- initialize --
//--------------------------------------------------------------//

- (id)initWithDictionary:(NSDictionary *)dataDict {
    self = [super init];
    if (self) {
        self.dataId = [dataDict[@"id"] integerValue];
        self.userId = [dataDict[@"user_id"] integerValue];
        self.name = dataDict[@"name"];
        self.categoryIdsStr = dataDict[@"category_ids_str"];
        self.angleIdsStr = dataDict[@"angle_ids_str"];
        self.sortIdsStr = dataDict[@"sort_ids_str"];

        self.sortId = [DataManager sharedManager].pageDict.count;

        if ([dataDict[@"id"] integerValue] == 16) {
            self.colorId = 9;
         } else if ([dataDict[@"id"] integerValue] == 18) {
            self.colorId = 13;
         } else if ([dataDict[@"id"] integerValue] == 19) {
            self.colorId = 3;
         } else if ([dataDict[@"id"] integerValue] == 1) {
            self.colorId = 14;
         } else if ([dataDict[@"id"] integerValue] == 20) {
            self.colorId = 8;
        } else if ([dataDict[@"id"] integerValue] == 17) {
            self.colorId = 6;
        } else if ([dataDict[@"id"] integerValue] == 16) {
            self.colorId = 5;
         } else {
            self.colorId = 7;
        }
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"dataId=%ld, userId=%ld name=%@ categoryIdsStr=%@, angleIdsStr=%@, sortIdsStr=%@", _dataId, _userId,
                                      _name, _categoryIdsStr, _angleIdsStr, _sortIdsStr];
}

//--------------------------------------------------------------//
#pragma mark -- Public Method --
//--------------------------------------------------------------//

- (NSMutableArray *)getCategoryList {
    DataManager *dataManager = [DataManager sharedManager];
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
    // アングル別のカテゴリー一覧を取得
    DataManager *dataManager = [DataManager sharedManager];

    // アングル別のカテゴリリストを生成
    NSMutableDictionary *angleDict = [self _getMapByArg:_angleIdsStr];
    NSMutableDictionary *tmpResultDict = [@{[NSNumber numberWithInt : LEFT] : [[NSMutableArray alloc] init],
                                            [NSNumber numberWithInt:CENTER] : [[NSMutableArray alloc] init],
                                            [NSNumber numberWithInt:RIGHT] : [[NSMutableArray alloc] init]
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
    NSMutableDictionary *sortDict = [self _getMapByArg:_sortIdsStr];
    for (NSNumber *angleId in tmpResultDict) {
        //sortIdが0 or 1 始まりのため、 firstCategoryDataは0始まりだった時の先頭categoryを保持してる
        CategoryData *firstCategoryData = nil;
        NSMutableArray *array = [NSMutableArray arrayWithArray:tmpResultDict[angleId]];
        // NSLog(@"middarray  %@", array);
        for (CategoryData *category in tmpResultDict[angleId]) {
            NSNumber *categoryId = [[NSNumber alloc] initWithInt:(int)category.dataId];
            NSNumber *sortId = sortDict[categoryId];
            int idx = (int)[sortId integerValue] - 1;
            if (idx >= 0) {
                // NSLog(@"category.name, %@", category.name);
                array[idx] = category;
            } else {
                firstCategoryData = category;
            }
        }
        // firstCategoryDataを先頭に置き替える
        if (firstCategoryData) {
            NSMutableArray *tmpArray = [NSMutableArray arrayWithObject:firstCategoryData];
            [array removeLastObject];
            for (CategoryData *category in array) {
                [tmpArray addObject:(id)category];
            }
            array = tmpArray;
        }
        // NSLog(@"array %ld", array.count);
        resultDict[angleId] = array;
    }
    return resultDict;
}

- (NSMutableDictionary *)_getMapByArg:(NSString *)strData {
    // 引数の文字列をパースしてdictionaryリストを生成する
    NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] init];
    NSArray *list_ = [strData componentsSeparatedByString:@","];
    for (id data in list_) {
        NSArray *aList = [(NSString *)data componentsSeparatedByString:@":"];
        NSNumber *categoryId = [[NSNumber alloc] initWithInt:[aList[0] intValue]];
        NSNumber *argId = [[NSNumber alloc] initWithInt:[aList[1] intValue]];
        [resultDict setObject:argId forKey:categoryId];
    }
    return resultDict;
}

- (void)updatePageData:(CategoryData *)category isCheckMark:(BOOL)isCheckMark {
    // ページ情報を編集時の処理
    NSNumber *categoryId = [[NSNumber alloc] initWithInt:(int)category.dataId];
    NSMutableArray *categoryIdList = (NSMutableArray *)[_categoryIdsStr componentsSeparatedByString:@","];
    NSMutableDictionary *angleDict = [self _getMapByArg:_angleIdsStr];
    NSMutableDictionary *sortDict = [self _getMapByArg:_sortIdsStr];
    BOOL isExistCategory = [categoryIdList containsObject:[categoryId stringValue]];

    if (isCheckMark) {
        // チェックした時
        if (!isExistCategory) {
            NSNumber *angleLeft = [[NSNumber alloc] initWithInt:LEFT];
            [categoryIdList addObject:[categoryId stringValue]];
            angleDict[categoryId] = angleLeft;
            int count = [Helper getSameCountByDict:angleDict TargetValue:angleLeft];
            sortDict[categoryId] = [NSString stringWithFormat:@"%d", count];
        }
    } else {
        // チェックを外した時
        if (isExistCategory) {
            [categoryIdList removeObject:[categoryId stringValue]];
            [angleDict removeObjectForKey:categoryId];
            [sortDict removeObjectForKey:categoryId];
        }
    }

    // PageDataの更新
    NSMutableArray *sortList = [[NSMutableArray alloc] init];
    NSMutableArray *angleList = [[NSMutableArray alloc] init];
    NSArray *updateData = @[@{@"dict": sortDict,  @"array": sortList},
                            @{@"dict": angleDict, @"array": angleList}];
    for (NSDictionary *data in updateData) {
        for (id cateogryId in data[@"dict"]) {
            NSString *insertData = [NSString stringWithFormat:@"%@:%@", cateogryId, data[@"dict"][cateogryId]];
            [data[@"array"] addObject:insertData];
        }
    }
    self.categoryIdsStr = [categoryIdList componentsJoinedByString:@","];
    self.sortIdsStr = [sortList componentsJoinedByString:@","];
    self.angleIdsStr = [angleList componentsJoinedByString:@","];
}

- (ColorData *)color {
    NSNumber *number = [[NSNumber alloc] initWithInt:(int)_colorId];
    return [[DataManager sharedManager] getColor:number];
}

//--------------------------------------------------------------//
#pragma mark -- Data Intaface --
//--------------------------------------------------------------//

- (NSInteger)iGetMenuId {
    return MENU_PAGE;
}

- (NSString *)iGetTitleName {
    return kMenuPageName;
}

- (NSString *)iGetName {
    return self.name;
}

- (void)iSetName:(NSString *)name {
    self.name = name;
}

- (NSInteger)iGetColorId {
    return self.colorId;
}

- (void)iSetColorId:(NSInteger)colorId {
    self.colorId = colorId;
}

@end
