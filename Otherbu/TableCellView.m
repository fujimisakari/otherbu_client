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

@implementation TableCellView {
    NSIndexPath *_indexPath;
    UITableView *_tableView;
    CategoryData *_category;
    BookmarkData *_bookmark;
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
    // todo このマジックナンバーをなんとかする
    frame.origin.x += 10;
    frame.size.width = _tableView.contentSize.width - 20;
    [super setFrame:frame];
}

#pragma mark - Private Methods

- (void)setupBackground {

    UIView *cellBackgroundView = [[UIView alloc] init];

    // 後面の背景指定
    cellBackgroundView.backgroundColor = [[_category color] getCellBackGroundColor];

    // セクションの最後のセルの場合はfooterのUIViewを付ける
    if ([self isLastCellOfSection]) {
        UIView *footerView = [self createFooterViewOfLastCell];
        [cellBackgroundView addSubview:footerView];
    }

    // 前面の背景指定
    float width = _tableView.contentSize.width - 30;  // todo この30をなんとかする
    float height = self.bounds.size.height;
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(self.bounds.origin.x + 5, self.bounds.origin.y, width, height);
    layer.backgroundColor = [UIColor blackColor].CGColor;
    [cellBackgroundView.layer addSublayer:layer];

    self.backgroundView = cellBackgroundView;
}

- (UIView *)createFooterViewOfLastCell {
    int x = self.bounds.origin.x;
    int y = self.bounds.origin.y + self.bounds.size.height;
    float width = _tableView.contentSize.width - 20;  // todo この20をなんとかする
    float height = 5;
    CGRect rect = CGRectMake(x, y, width, height);

    UIView *footerView = [[UIView alloc] initWithFrame:rect];
    footerView.backgroundColor = [[_category color] getCellBackGroundColor];

    // 角丸にする
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath
        bezierPathWithRoundedRect:footerView.bounds
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
    self.textLabel.font = [UIFont fontWithName:@"Futura-Medium" size:16];
    self.detailTextLabel.text = _bookmark.url;
    self.detailTextLabel.textColor = [UIColor whiteColor];
}

- (void)setupBorder {
    // セルのボーダーライン配置（既定のだと後面の背景まで線が越えてしまうため）
    CGRect rect = CGRectMake(self.bounds.origin.x + 5, self.bounds.origin.y, _tableView.contentSize.width - 30, 0.5f);
    UIView *borderline = [[UIView alloc] initWithFrame:rect];
    borderline.backgroundColor = [UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f];
    [self.contentView addSubview:borderline];
}

- (BOOL)isLastCellOfSection {
    NSArray *bookmarkList = [_category getBookmarkList];
    int lastCellIndex = _indexPath.row + 1;
    return (lastCellIndex == bookmarkList.count) ? YES : NO;
}

@end
