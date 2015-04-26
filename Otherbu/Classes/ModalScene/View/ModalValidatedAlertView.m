//
//  ModalValidatedAlertView.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "ModalValidatedAlertView.h"

@implementation ModalValidatedAlertView

- (void)setup {
    self.title = @"";
    self.message = @"入力されていない項目があるため、\n実行できませんでした";
    [self addButtonWithTitle:@"OK"];
}

@end
