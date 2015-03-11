//
//  TableCellView.m
//  Otherbu
//
//  Created by fujimisakari on 2015/03/02.
//  Copyright (c) 2015年 fujimisakari. All rights reserved.
//

#import "TableCellView.h"
#import "PageData.h"
#import "CategoryData.h"
#import "BookmarkData.h"
#import "ColorData.h"
#import "Constants.h"

@implementation TableCellView {
    NSIndexPath *_indexPath;
    UITableView *_tableView;
    CategoryData *_category;
    BookmarkData *_bookmark;
    UIView *_cellBackgroundView;
    float _cellWidth;
    float _cellInnerWidth;
};

+ (id)initWithCellIdentifier:(NSString *)cellIdentifier {
    TableCellView *cell = [[TableCellView alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    return cell;
}

- (id)setUpWithPageData:(PageData *)page tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    _tableView = tableView;
    _category = [page getCategoryListByTag:_tableView.tag][indexPath.section];
    _bookmark = [_category getBookmarkList][indexPath.row];
    _cellBackgroundView = [[UIView alloc] init];
    _cellWidth = _tableView.contentSize.width - kHorizontalAdaptSizeOfTableCell;
    _cellInnerWidth = _tableView.contentSize.width - (kHorizontalAdaptSizeOfTableCell + kHorizontalAdaptPositionOfTableCell);

    // 背景設定
    [self setupBackground];

    // セルの選択時の背景指定
    // UIView *cellSelectedBackgroundView = [[UIView alloc] init];
    // cellSelectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.0f];
    // cell.selectedBackgroundView = cellSelectedBackgroundView;
    // cell.contentView.backgroundColor = [UIColor blackColor];

    // セルの右側に矢印アイコンを表示
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    // ボーダーライン設定
    [self setupBorder];

    // 文言設定
    [self setupText];

    return self;
}

- (void)setFrame:(CGRect)frame {
    frame.origin.x += kHorizontalAdaptPositionOfTableCell;
    frame.size.width = _cellWidth;
    [super setFrame:frame];
}

#pragma mark - Private Methods

- (void)setupBackground {

    // 後面の背景指定
    _cellBackgroundView.backgroundColor = [[_category color] getCellBackGroundColor];

    // セクションの最後のセルの場合はfooterのUIViewを付ける
    if ([self isLastCellOfSection]) {
        UIView *footerView = [self createFooterViewOfLastCell];
        [_cellBackgroundView addSubview:footerView];
    }

    // 前面の背景指定
    float width = _cellInnerWidth;
    float height = self.bounds.size.height;
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(self.bounds.origin.x + kSizeOfTableFrame, self.bounds.origin.y, width, height);
    layer.backgroundColor = [UIColor blackColor].CGColor;
    [_cellBackgroundView.layer addSublayer:layer];

    self.backgroundView = _cellBackgroundView;
}

- (UIView *)createFooterViewOfLastCell {
    int x = self.bounds.origin.x;
    int y = self.bounds.origin.y + self.bounds.size.height;
    float width = _cellWidth;
    float height = kSizeOfTableFrame;
    CGRect rect = CGRectMake(x, y, width, height);

    UIView *footerView = [[UIView alloc] initWithFrame:rect];
    footerView.backgroundColor = [[_category color] getCellBackGroundColor];

    // 角丸にする
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:footerView.bounds
                                     byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                           cornerRadii:CGSizeMake(24.0, 24.0)];

    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = footerView.bounds;
    maskLayer.path = maskPath.CGPath;
    footerView.layer.mask = maskLayer;

    return footerView;
}

- (void)setupText {
    self.textLabel.text = _bookmark.name;
    self.textLabel.textColor = [UIColor whiteColor];
    self.textLabel.font = [UIFont fontWithName:kDefaultFont size:kFontSizeOfBookmark];
    self.detailTextLabel.text = _bookmark.url;
    self.detailTextLabel.textColor = [UIColor lightGrayColor];
    self.detailTextLabel.font = [UIFont fontWithName:kDefaultFont size:kFontSizeOfUrl];
}

- (void)setupBorder {
    // セルのボーダーライン配置（既定のだと後面の背景まで線が越えてしまうため）
    if (![self isFirstCellOfSection]) {
        CGRect rect = CGRectMake(self.bounds.origin.x + kSizeOfTableFrame, self.bounds.origin.y, _cellInnerWidth, kHeightOfBorderLine);
        UIView *borderline = [[UIView alloc] initWithFrame:rect];
        borderline.backgroundColor = [UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f];
        [_cellBackgroundView addSubview:borderline];
    }
}

- (BOOL)isFirstCellOfSection {
    return (_indexPath.row == 0) ? YES : NO;
}

- (BOOL)isLastCellOfSection {
    NSArray *bookmarkList = [_category getBookmarkList];
    int lastCellIndex = (int)_indexPath.row + 1;
    return (lastCellIndex == bookmarkList.count) ? YES : NO;
}

@end
