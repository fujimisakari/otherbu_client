//
//  BookmarkTableViewController.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "SettingBaseTableViewController.h"

@interface BookmarkTableViewController : SettingBaseTableViewController

@property(nonatomic) CategoryData *category;
@property(nonatomic) NSMutableArray *bookmarkList;

@end
