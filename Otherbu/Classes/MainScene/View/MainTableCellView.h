//
//  MainTableCellView.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

@class PageData;

@protocol MainTableCellViewDelegate

- (void)didLongPressBookmark:(BookmarkData *)selectBookmark;

@end

@interface MainTableCellView : UITableViewCell

@property(nonatomic, weak) id<MainTableCellViewDelegate> delegate;

@property(nonatomic) CategoryData *category;
@property(nonatomic) BookmarkData *bookmark;

- (id)initWithCellIdentifier:(NSString *)cellIdentifier ContentSizeWidth:(float)contentSizeWidth;
- (id)setupWithPageData:(PageData *)page indexPath:(NSIndexPath *)indexPath;

@end
