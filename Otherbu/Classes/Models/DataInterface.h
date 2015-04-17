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

- (void)iSetName:(NSString *)name;

- (NSString *)iGetUrl;
- (void)iSetUrl:(NSString *)url;

- (NSInteger)iGetCategoryId;
- (void)iSetCategoryId:(NSInteger)categoryId;

- (NSInteger)iGetColorId;
- (void)iSetColorId:(NSInteger)colorId;

- (void)iGetSortIdOfInt;
- (void)iGetSortIdOfString;

@end
