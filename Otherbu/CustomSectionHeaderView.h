//
//  CustomSectionHeaderView.h
//  Otherbu
//
//  Created by fujimisakari on 2015/02/17.
//  Copyright (c) 2015年 fujimisakari. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CategoryData;

@protocol CustomSectionHeaderViewDelegate

/**
 シングルタップ

 @param section セクションのインデックス；
 @param tag TableViewのtag名
 */
- (void)didSectionHeaderSingleTap:(NSInteger)section tag:(NSInteger)tag;

@end

@interface CustomSectionHeaderView : UIView

@property (nonatomic, weak) id<CustomSectionHeaderViewDelegate> delegate;

/**
 セクションのタイトルを指定して初期化

 @param section セクションのインデックス；
 @param tag TableViewのtag名
 */
- (id)initWithCategory:(CategoryData *)categoryData section:(NSInteger)section tag:(NSInteger)tag;

@end
