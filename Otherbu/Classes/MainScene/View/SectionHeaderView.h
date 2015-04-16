//
//  SectionHeaderView.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

@class CategoryData;

@protocol SectionHeaderViewDelegate

- (void)didSectionHeaderSingleTap:(NSInteger)section tagNumber:(NSInteger)tagNumber;
- (void)didLongPressCategory:(CategoryData *)category;

@end

@interface SectionHeaderView : UIView

@property(nonatomic, weak) id<SectionHeaderViewDelegate> delegate;

- (id)initWithCategory:(CategoryData *)categoryData
                 frame:(CGRect)frame
               section:(NSInteger)section
              delegate:(id<SectionHeaderViewDelegate>)delegate
             tagNumber:(NSInteger)tagNumber;

@end
