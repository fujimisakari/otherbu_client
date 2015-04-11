//
//  DesignData.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

@interface DesignData : NSObject

@property(nonatomic) NSString *tableBackGroundColor;  // Tableセル背景
@property(nonatomic) NSString *bookmarkColor;         // Bookmarkカラー
@property(nonatomic) NSString *urlColor;              // URLカラー

- (id)initWithDictionary:(NSDictionary *)dataDict;

- (UIColor *)getTableBackGroundColor;
- (UIColor *)getbookmarkColor;
- (UIColor *)getUrlColor;

@end
