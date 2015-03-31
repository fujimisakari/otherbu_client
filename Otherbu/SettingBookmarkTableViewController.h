//
//  SettingBookmarkTableViewController.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingBookmarkTableViewController : UITableViewController

- (void)setCategory:(CategoryData *)category;
- (void)setBookmarkList:(NSArray *)bookmarkList;

@end
