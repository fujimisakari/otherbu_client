//
//  PageTabView.h
//  Otherbu
//
//  Created by fujimisakari on 2015/03/14.
//  Copyright (c) 2015年 fujimisakari. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PageData, PageTabView;

@protocol PageTabDelegate

/**
 シングルタップ

 @param section セクションのインデックス；
 @param tag TableViewのtag名
 */
- (void)didPageTabSingleTap:(PageData *)selectPage pageTabView:(PageTabView *)pageTabView;

@end

@interface PageTabView : UIView

@property (nonatomic, weak) id<PageTabDelegate> delegate;

+ (id)initWithFrame:(CGRect)rect;

- (void)setUpWithPage:(PageData *)page;

@end
