//
//  SettingAlertView.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "SettingAlertView.h"

@implementation SettingAlertView

- (void)setup:(NSString *)result {
    self.title = @"";
    if ([result isEqualToString:@"success"]) {
        self.message = @"同期しました";
    } else if ([result isEqualToString:@"error"]) {
        self.message = @"同期に失敗しました";
    }

    [self addButtonWithTitle:@"Close"];
}

@end
