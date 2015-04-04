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
- (void)iSetName:(NSString *)name;

@optional

- (NSInteger)iGetColorId;
- (void)iSetColorId:(NSInteger)colorId;

@end
