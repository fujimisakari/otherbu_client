//
//  SearchData.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

# import "DataInterface.h"

@interface SearchData : NSObject<DataInterface>

@property(nonatomic) NSString  *dataId;      // ID
@property(nonatomic) NSString  *name;        // Bookmark名
@property(nonatomic) NSString  *url;         // URL
@property(nonatomic) NSInteger sort;         // Sort番号

- (id)initWithDictionary:(NSDictionary *)dataDict;

@end
