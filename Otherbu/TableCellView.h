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

/**
 セクションのタイトルを指定して初期化

 @parms frame セクションのframe
 @param section セクションのインデックス
 @param tag TableViewのtag名
 */
+ (id)initWithCellIdentifier:(NSString *)cellIdentifier;

- (id)setupWithPageData:(PageData *)page tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end
