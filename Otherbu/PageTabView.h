//
//  PageTabView.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

@class PageData, PageTabView;

@protocol PageTabDelegate

- (void)didPageTabSingleTap:(PageData *)selectPage pageTabView:(PageTabView *)pageTabView;

@end

@interface PageTabView : UIView

@property(nonatomic, weak) id<PageTabDelegate> delegate;

+ (id)initWithFrame:(CGRect)rect;
+ (CGSize)getTextSizeOfPageViewWithString:(NSString *)string;

- (void)setUpWithPage:(PageData *)page delegate:(id<PageTabDelegate>)delegate;
- (void)switchTabStatus;

@end
