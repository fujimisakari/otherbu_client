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
        self.dataId = [dataDict[@"id"] stringValue];
        self.userId = [dataDict[@"user_id"] integerValue];
        self.name = dataDict[@"name"];
        self.categoryIdsStr = dataDict[@"category_ids_str"];
        self.angleIdsStr = dataDict[@"angle_ids_str"];
        self.sortIdsStr = dataDict[@"sort_ids_str"];
        self.sortId = [DataManager sharedManager].pageDict.count;

        if ([self.dataId isEqualToString:@"16"]) {
            self.colorId = @"9";
        } else if ([self.dataId isEqualToString:@"18"]) {
            self.colorId = @"13";
        } else if ([self.dataId isEqualToString:@"19"]) {
            self.colorId = @"3";
        } else if ([self.dataId isEqualToString:@"1"]) {
            self.colorId = @"14";
        } else if ([self.dataId isEqualToString:@"20"]) {
            self.colorId = @"8";
        } else if ([self.dataId isEqualToString:@"17"]) {
            self.colorId = @"6";
        } else if ([self.dataId isEqualToString:@"17"]) {
            self.colorId = @"5";
        } else {
            self.colorId = @"7";
        }
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"dataId=%@, userId=%ld name=%@ categoryIdsStr=%@, angleIdsStr=%@, sortIdsStr=%@, sortId=%ld",
                                      _dataId, _userId, _name, _categoryIdsStr, _angleIdsStr, _sortIdsStr, _sortId];
}

//--------------------------------------------------------------//
#pragma mark -- Public Method --
//--------------------------------------------------------------//

- (NSMutableArray *)getCategoryList {
    DataManager *dataManager = [DataManager sharedManager];
    NSMutableArray *resultList = [[NSMutableArray alloc] init];

    NSArray *categoryIdList = [_categoryIdsStr componentsSeparatedByString:@","];
    for (NSString *categoryId in categoryIdList) {
        CategoryData *data = [dataManager getCategory:categoryId];
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
    for (NSString *categoryId in angleDict) {
        CategoryData *data = [dataManager getCategory:categoryId];
        if (data) {
            NSNumber *angleId = angleDict[categoryId];
            [tmpResultDict[angleId] addObject:data];
        }
    }
    // アングル別のカテゴリリストをソートする(バブルソート)
    NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *sortDict = [self _getMapByArg:_sortIdsStr];
    for (NSNumber *angleId in tmpResultDict) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:tmpResultDict[angleId]];
        NSMutableArray *sortArray = [self _doCategorySort:array SortDict:sortDict];
        resultDict[angleId] = sortArray;
    }
    return resultDict;
}

- (NSMutableDictionary *)_getMapByArg:(NSString *)strData {
    // 引数の文字列をパースしてdictionaryリストを生成する
    NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] init];
    NSArray *_list = [strData componentsSeparatedByString:@","];
    for (NSString *data in _list) {
        NSArray *aList = [data componentsSeparatedByString:@":"];
        NSString *categoryId = aList[0];
        NSNumber *argId = [Helper getNumberByInt:[aList[1] intValue]];
        [resultDict setObject:argId forKey:categoryId];
    }
    return resultDict;
}

- (NSMutableArray *)_doCategorySort:(NSMutableArray *)array SortDict:(NSMutableDictionary *)sortDict {
    // sortIdsStrは、歯抜けの連番になってる場合があるので、0〜の連番になるようにする

    // 最後の要素を除いて、すべての要素を並べ替えます
    for (int i = 0; i < (int)array.count - 1; i++) {
        // 下から上に順番に比較します
        for (int j = (int)array.count - 1; j > i; j--) {
            CategoryData *currentCategory = array[j];
            int currentSortId = [(NSString *)sortDict[currentCategory.dataId] intValue];

            CategoryData *nextCategory = array[(int)j - 1];
            int nextSortId = [(NSString *)sortDict[nextCategory.dataId] intValue];

            // 上の方が大きいときは互いに入れ替えます
            if (currentSortId < nextSortId) {
                array[j] = nextCategory;
                array[(int)j - 1] = currentCategory;
            }
        }
    }
    return array;
}

- (void)updatePageData:(CategoryData *)category isCheckMark:(BOOL)isCheckMark {
    NSLog(@"updatePageData(befor): %@", self);
    // ページ情報を編集時の処理
    NSString *categoryId = category.dataId;
    NSMutableArray *categoryIdList = (NSMutableArray *)[_categoryIdsStr componentsSeparatedByString:@","];
    NSMutableDictionary *angleDict = [self _getMapByArg:_angleIdsStr];
    NSMutableDictionary *sortDict = [self _getMapByArg:_sortIdsStr];
    BOOL isExistCategory = [categoryIdList containsObject:categoryId];

    if (isCheckMark) {
        // チェックした時
        if (!isExistCategory) {
            NSNumber *angleLeft = [[NSNumber alloc] initWithInt:LEFT];
            [categoryIdList addObject:categoryId];
            angleDict[categoryId] = angleLeft;
            int count = [Helper getSameCountByDict:angleDict TargetValue:angleLeft];
            sortDict[categoryId] = [NSString stringWithFormat:@"%d", count];
        }
    } else {
        // チェックを外した時
        if (isExistCategory) {
            [categoryIdList removeObject:categoryId];
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
        for (NSString *cateogryId in data[@"dict"]) {
            NSString *insertData = [NSString stringWithFormat:@"%@:%@", cateogryId, data[@"dict"][cateogryId]];
            [data[@"array"] addObject:insertData];
        }
    }
    self.categoryIdsStr = [categoryIdList componentsJoinedByString:@","];
    self.sortIdsStr = [sortList componentsJoinedByString:@","];
    self.angleIdsStr = [angleList componentsJoinedByString:@","];
    NSLog(@"updatePageData(after): %@", self);
}

- (void)updatePageDataBySwap:(NSMutableDictionary *)categoryListOfAngle {
    NSLog(@"updatePageDataBySwap(befor): %@", self);
    // カテゴリの入れ替えでページ情報更新
    NSMutableArray *categoryIdList = [[NSMutableArray alloc] init];
    NSMutableArray *sortList = [[NSMutableArray alloc] init];
    NSMutableArray *angleList = [[NSMutableArray alloc] init];

    for (int i = 1; i < LastAngle; ++i) {
        NSNumber *angleId = [Helper getNumberByInt:i];
        NSMutableArray *categoryArray = categoryListOfAngle[angleId];
        for (int idx = 0; idx < categoryArray.count; ++idx) {
            CategoryData *category = categoryArray[idx];
            int sortId = idx + 1;
            [categoryIdList addObject:category.dataId];
            [sortList addObject:[NSString stringWithFormat:@"%@:%d", category.dataId, sortId]];
            [angleList addObject:[NSString stringWithFormat:@"%@:%@", category.dataId, angleId]];
        }
    }

    self.categoryIdsStr = [categoryIdList componentsJoinedByString:@","];
    self.sortIdsStr = [sortList componentsJoinedByString:@","];
    self.angleIdsStr = [angleList componentsJoinedByString:@","];
    NSLog(@"updatePageDataBySwap(after): %@", self);
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
    self.dataId = [Helper generateId];
    self.sortId = [DataManager sharedManager].pageDict.count + 1;
    [[DataManager sharedManager] addPage:self];
}

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

- (NSString *)iGetColorId {
    return self.colorId;
}

- (void)iSetColorId:(NSString *)colorId {
    self.colorId = colorId;
}

@end
