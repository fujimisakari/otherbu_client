//
//  PageTabView.h
//  Otherbu
//
//  Created by fujimisakari on 2015/03/14.
//  Copyright (c) 2015年 fujimisakari. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PageData;

@interface PageTabView : UIView

+ (id)initWithFrame:(CGRect)rect;

- (void)setUpWithPage:(PageData *)page;

@end
