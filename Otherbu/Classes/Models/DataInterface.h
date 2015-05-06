//
//  DataInterface.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

@protocol DataInterface <NSObject>

@optional

- (NSString *)iGetTitleName;

- (NSInteger)iGetMenuId;

- (BOOL)isCreateMode;

- (void)addNewData;

- (NSString *)iGetName;
- (void)iSetName:(NSString *)name;

- (NSString *)iGetUrl;
- (void)iSetUrl:(NSString *)url;

- (NSString *)iGetCategoryId;
- (void)iSetCategoryId:(NSString *)categoryId;

- (NSString *)iGetColorId;
- (void)iSetColorId:(NSString *)colorId;

- (void)iGetSortIdOfInt;
- (void)iGetSortIdOfString;

- (void)iUpdateAt;
- (NSMutableDictionary *)iSyncData;

@end
