//
//  ColorData.h
//  Otherbu
//
//  Created by fujimisakari on 2015/03/01.
//  Copyright (c) 2015年 fujimisakari. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColorData : NSObject

@property(nonatomic) NSInteger dataId;               // ID
@property(nonatomic) NSString *name;                 // カラー名
@property(nonatomic) NSString *font_color;           // fontColor
@property(nonatomic) NSString *icon_color;           // Bookmark名
@property(nonatomic) NSInteger sort;                 // 選択時の表示順
@property(nonatomic) NSString *color_code1;          // カラーグラデーション(上部)
@property(nonatomic) NSString *color_code2;          // カラーグラデーション(中部)
@property(nonatomic) NSString *color_code3;          // カラーグラデーション(下部)
@property(nonatomic) NSString *thumbnail_color_code; // 選択時のサムネカラー

- (id)initWithDictionary:(NSDictionary *)dataDict;
- (NSArray *)getGradientColorList;

@end
