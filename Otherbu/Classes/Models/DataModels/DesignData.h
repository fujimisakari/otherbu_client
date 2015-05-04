//
//  DesignData.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

@interface DesignData : NSObject<NSCoding>

@property(nonatomic) NSString *tableBackGroundColor;  // Tableセル背景
@property(nonatomic) NSString *bookmarkColor;         // Bookmarkカラー
@property(nonatomic) NSString *urlColor;              // URLカラー
@property(nonatomic) NSString *backgroundPicture;     // URLカラー

+ (DesignData *)shared;

- (void)updateWithDictionary:(NSDictionary *)dataDict;

- (UIColor *)getTableBackGroundColor;
- (UIColor *)getbookmarkColor;
- (UIColor *)getUrlColor;

- (void)updateTableBackGroundColor:(NSString *)colorCode;
- (void)updatetbookmarkNameColor:(NSString *)colorCode;
- (void)updatetbookmarkUrlColor:(NSString *)colorCode;
- (void)updatetBackgroundPicture:(NSString *)fileName;

@end
