//
//  UIScrollView+TouchEvent.m
//  Otherbu
//
//  Created by fujimisakari on 2015/03/14.
//  Copyright (c) 2015年 fujimisakari. All rights reserved.
//

#import "UIScrollView+TouchEvent.h"

@implementation UIScrollView (UIScrollView_TouchEvent)
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"iiiiiiiiiiiiiiii %d", self.dragging);
    // [[self nextResponder] touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"iiiiddii %d", self.dragging);
    // [[self nextResponder] touchesBegan:touches withEvent:event];
}
@end
