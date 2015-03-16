//
//  PageTabView.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PageData, PageTabView;

@protocol PageTabDelegate

- (void)didPageTabSingleTap:(PageData *)selectPage pageTabView:(PageTabView *)pageTabView;

@end

@interface PageTabView : UIView

@property (nonatomic, weak) id<PageTabDelegate> delegate;

+ (id)initWithFrame:(CGRect)rect;

- (void)setUpWithPage:(PageData *)page;
- (void)switchTabStatus;

@end
