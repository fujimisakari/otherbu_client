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

- (void)didSectionHeaderSingleTap:(NSInteger)section tag:(NSInteger)tag;

@end

@interface SectionHeaderView : UIView

@property (nonatomic, weak) id<SectionHeaderViewDelegate> delegate;

- (id)initWithCategory:(CategoryData *)categoryData frame:(CGRect)frame  section:(NSInteger)section tag:(NSInteger)tag;

@end
