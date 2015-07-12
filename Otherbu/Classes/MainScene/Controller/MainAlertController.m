//
//  MainAlertController.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "MainAlertController.h"

@interface MainAlertController () {
    NSMutableDictionary *_actionDict;
}

@end

@implementation MainAlertController

- (void)setActionDict:(NSMutableDictionary *)actionDict {
    _actionDict = actionDict;
}

- (void)setup {
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *pageAction = [UIAlertAction actionWithTitle:@"Page" style:UIAlertActionStyleDefault handler:_actionDict[@"page"]];
    UIAlertAction *categoryAction =
        [UIAlertAction actionWithTitle:@"Category" style:UIAlertActionStyleDefault handler:_actionDict[@"category"]];
    UIAlertAction *bookmarkAction =
        [UIAlertAction actionWithTitle:@"Bookmark" style:UIAlertActionStyleDefault handler:_actionDict[@"bookmark"]];

    [self addAction:cancelAction];
    [self addAction:categoryAction];
    [self addAction:bookmarkAction];
    [self addAction:pageAction];
}

@end
