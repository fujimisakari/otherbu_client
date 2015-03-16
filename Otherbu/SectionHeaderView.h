//
//  SectionHeaderView.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CategoryData;

@protocol SectionHeaderViewDelegate

/**
 シングルタップ

 @param section セクションのインデックス；
 @param tag TableViewのtag名
 */
- (void)didSectionHeaderSingleTap:(NSInteger)section tag:(NSInteger)tag;

@end

@interface SectionHeaderView : UIView

@property (nonatomic, weak) id<SectionHeaderViewDelegate> delegate;

/**
 セクションのタイトルを指定して初期化

 @parms frame セクションのframe
 @param section セクションのインデックス
 @param tag TableViewのtag名
 */
- (id)initWithCategory:(CategoryData *)categoryData frame:(CGRect)frame  section:(NSInteger)section tag:(NSInteger)tag;

@end
