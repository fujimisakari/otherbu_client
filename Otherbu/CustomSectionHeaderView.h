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

 @param sectionIndex セクションのインデックス
 @param isOpen 開閉状態（YES:開, NO:閉）
 */
- (void)didSectionHeaderSingleTap:(NSInteger)section angle:(NSNumber *)angleNumber tag:(NSInteger)tag;

@end

@interface CustomSectionHeaderView : UIView

@property (nonatomic, weak) id<CustomSectionHeaderViewDelegate> delegate;

/**
 セクションのタイトルを指定して初期化
 */
- (id)initWithCategory:(CategoryData *)categoryData section:(NSInteger)section angle:(NSNumber *)angleNumber tag:(NSInteger)tag;

@end
