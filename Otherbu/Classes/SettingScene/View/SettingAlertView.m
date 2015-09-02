//
//  SettingAlertView.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "SettingAlertView.h"

@implementation SettingAlertView

- (void)setup:(int)statusCode {
    self.title = @"";
    if (statusCode == 503) {
        self.message = @"現在メンテナンス中です";
    } else if (statusCode == 405) {
        self.message = @"リクエストに失敗しました";
    } else if (statusCode == 404) {
        self.message = @"アクセス先が見つかりませんでした";
    } else if (statusCode == 401) {
        self.message = @"認証に失敗しました";
    } else if (statusCode == 4011) {
        self.message = @"Twitterの認証に失敗しました";
    } else if (statusCode == 4012) {
        self.message = @"Facebookの認証に失敗しました";
    } else if (statusCode == 500) {
        self.message = @"システムエラーで同期に失敗しました";
    } else {
        self.message = @"同期しました";
    }

    [self addButtonWithTitle:@"Close"];
}

@end
