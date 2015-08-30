//
//  AccountTypeData.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

# import "DataInterface.h"

@interface AccountTypeData : NSObject<DataInterface>

@property(nonatomic) NSString  *dataId;      // ID
@property(nonatomic) NSString  *name;        // Account名
@property(nonatomic) NSString  *iconName;    // icon名
@property(nonatomic) NSInteger sort;         // Sort番号

- (id)initWithDictionary:(NSDictionary *)dataDict;
- (NSString *)iconName;

@end
