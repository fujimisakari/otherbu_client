//
//  PageTabLabel.m
//  Otherbu
//
//  Created by fujimisakari on 2015/03/14.
//  Copyright (c) 2015年 fujimisakari. All rights reserved.
//

#import "PageTabLabel.h"
#import "PageData.h"
#import "Constants.h"

@implementation PageTabLabel {
    PageData *_page;
}


+ (id)initWithFrame:(CGRect)rect {
    PageTabLabel *label = [[PageTabLabel alloc] initWithFrame:rect];
    return label;
}

/**
   pageTABラベル生成
*/
- (void)setUpWithPage:(PageData *)page {
    _page = page;
    UIFont *font = [UIFont fontWithName:kDefaultFont size:16];
    CGSize textSize = [_page.name sizeWithFont:font constrainedToSize:CGSizeMake(200, 2000) lineBreakMode:UILineBreakModeWordWrap];
    self.font = font;
    self.text = _page.name;

    self.backgroundColor = [UIColor yellowColor];
    self.textColor = [UIColor blueColor];
    self.numberOfLines = 1;
    self.textAlignment = UITextAlignmentCenter;
}

@end
