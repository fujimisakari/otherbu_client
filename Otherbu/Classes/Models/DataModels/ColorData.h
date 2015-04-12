//
//  ColorData.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

# import "DataInterface.h"

@interface ColorData : NSObject<DataInterface>

@property(nonatomic) NSInteger dataId;               // ID
@property(nonatomic) NSString *name;                 // カラー名
@property(nonatomic) NSString *font_color;           // BookmarkのColor
@property(nonatomic) NSString *icon_color;           // リンクIconカラー(使用してない)
@property(nonatomic) NSInteger sort;                 // 選択時の表示順
@property(nonatomic) NSString *color_code1;          // カラーグラデーション(上部)
@property(nonatomic) NSString *color_code2;          // カラーグラデーション(中部)
@property(nonatomic) NSString *color_code3;          // カラーグラデーション(下部)
@property(nonatomic) NSString *thumbnail_color_code; // 選択時のサムネカラー

- (id)initWithDictionary:(NSDictionary *)dataDict;
- (NSArray *)getGradientColorList;
- (UIColor *)getBackGroundColor;
- (UIColor *)getSectionHeaderFontColor;
- (UIColor *)getFooterColorOfGradient;
- (UIColor *)getThumbnailColor;

@end
