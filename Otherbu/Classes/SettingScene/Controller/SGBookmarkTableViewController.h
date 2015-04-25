//
//  SGBookmarkTableViewController.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "SGBaseTableViewController.h"

@interface SGBookmarkTableViewController : SGBaseTableViewController

@property(nonatomic) CategoryData *category;
@property(nonatomic) NSMutableArray *bookmarkList;

@end
