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

- (NSInteger)iGetColorId;
- (void)iSetColorId:(NSInteger)colorId;

- (void)iGetSortIdOfInt;
- (void)iGetSortIdOfString;

@end
