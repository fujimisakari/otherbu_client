//
//  DataInterface.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

@protocol DataInterface <NSObject>

@required

- (NSString *)iGetTitleName;
- (NSString *)iGetName;

@optional

- (NSInteger)iGetMenuId;

- (BOOL)isCreateMode;

- (void)iSetName:(NSString *)name;

- (NSString *)iGetUrl;
- (void)iSetUrl:(NSString *)url;

- (NSString *)iGetCategoryId;
- (void)iSetCategoryId:(NSString *)categoryId;

- (NSString *)iGetColorId;
- (void)iSetColorId:(NSString *)colorId;

- (void)iGetSortIdOfInt;
- (void)iGetSortIdOfString;

@end
