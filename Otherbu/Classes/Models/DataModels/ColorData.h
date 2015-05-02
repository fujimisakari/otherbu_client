//
//  ColorData.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

# import "DataInterface.h"

@interface ColorData : NSObject<DataInterface>

@property(nonatomic) NSString  *dataId;              // ID
@property(nonatomic) NSString  *name;                // カラー名
@property(nonatomic) NSString  *fontColor;           // BookmarkのColor
@property(nonatomic) NSString  *iconColor;           // リンクIconカラー(使用してない)
@property(nonatomic) NSInteger sort;                 // 選択時の表示順
@property(nonatomic) NSString  *colorCode1;          // カラーグラデーション(上部)
@property(nonatomic) NSString  *colorCode2;          // カラーグラデーション(中部)
@property(nonatomic) NSString  *colorCode3;          // カラーグラデーション(下部)
@property(nonatomic) NSString  *thumbnailColorCode;  // 選択時のサムネカラー

- (id)initWithDictionary:(NSDictionary *)dataDict;
- (NSArray *)getGradientColorList;
- (UIColor *)getBackGroundColor;
- (UIColor *)getSectionHeaderFontColor;
- (UIColor *)getFooterColorOfGradient;
- (UIColor *)getThumbnailColor;

@end
