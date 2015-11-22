//
//  DesignData.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "DataInterface.h"

@interface DesignData : NSObject<DataInterface, NSCoding>

@property(nonatomic) NSString *tableBackGroundColor;  // Tableセル背景
@property(nonatomic) NSString *bookmarkColor;         // Bookmarkカラー
@property(nonatomic) NSString *urlColor;              // URLカラー
@property(nonatomic) CGFloat  alpha;                  // 透明度
@property(nonatomic) NSString *backgroundPicture;     // 背景画像名
@property(nonatomic) NSDate   *updatedAt;             // 更新時間

- (id)init;

- (void)updateWithDictionary:(NSDictionary *)dataDict;

- (UIColor *)getTableBackGroundColor;
- (UIColor *)getbookmarkColor;
- (UIColor *)getUrlColor;
- (NSString *)getbackgroundPicturePath;

- (void)updateTableBackGroundColor:(NSString *)colorCode;
- (void)updatetbookmarkNameColor:(NSString *)colorCode;
- (void)updatetbookmarkUrlColor:(NSString *)colorCode;
- (void)updatetBackgroundPicture:(NSString *)fileName;
- (void)updateAlpha:(CGFloat)alpha;

@end
