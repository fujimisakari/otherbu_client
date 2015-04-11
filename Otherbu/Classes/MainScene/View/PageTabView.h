//
//  PageTabView.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

@class PageData, PageTabView;

@protocol PageTabDelegate

- (void)didSingleTapPageTab:(PageData *)selectPage pageTabView:(PageTabView *)pageTabView;
- (void)didLongPressPageTab:(PageData *)selectPage pageTabView:(PageTabView *)pageTabView;

@end

@interface PageTabView : UIView

@property(nonatomic, weak) id<PageTabDelegate> delegate;

+ (CGSize)getTextSizeOfPageViewWithString:(NSString *)string;

- (void)setUpWithPage:(PageData *)page delegate:(id<PageTabDelegate>)delegate;
- (void)switchTabStatus;

@end
