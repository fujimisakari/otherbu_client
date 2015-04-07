//
//  SettingBookmarkTableViewController.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "SettingBaseTableViewController.h"

@interface SettingBookmarkTableViewController : SettingBaseTableViewController

- (void)setCategory:(CategoryData *)category;
- (void)setBookmarkList:(NSArray *)bookmarkList;

@end
