//
//  MainTableCellView.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

@class PageData;

@interface MainTableCellView : UITableViewCell

+ (id)initWithCellIdentifier:(NSString *)cellIdentifier;

- (id)setupWithPageData:(PageData *)page tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end
