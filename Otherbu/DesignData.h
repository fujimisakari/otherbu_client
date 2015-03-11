//
//  DesignData.h
//  Otherbu
//
//  Created by fujimisakari on 2015/03/12.
//  Copyright (c) 2015年 fujimisakari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DesignData : NSObject

@property(nonatomic) NSString *tableBackGroundColor;  // Tableセル背景
@property(nonatomic) NSString *bookmarkColor;         // Bookmarkカラー
@property(nonatomic) NSString *urlColor;              // URLカラー

- (id)initWithDictionary:(NSDictionary *)dataDict;

- (UIColor *)getTableBackGroundColor;
- (UIColor *)getbookmarkColor;
- (UIColor *)getUrlColor;

@end
