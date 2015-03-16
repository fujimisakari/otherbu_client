//
//  TableCellView.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PageData;

@interface TableCellView : UITableViewCell

+ (id)initWithCellIdentifier:(NSString *)cellIdentifier;

- (id)setupWithPageData:(PageData *)page tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end
