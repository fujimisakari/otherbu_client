//
//  MainTableCellView.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "MainTableCellView.h"
#import "DataManager.h"
#import "PageData.h"
#import "CategoryData.h"
#import "BookmarkData.h"
#import "DesignData.h"
#import "ColorData.h"

@interface MainTableCellView ()

@property(nonatomic) NSIndexPath  *indexPath;
@property(nonatomic) UITableView  *tableView;
@property(nonatomic) CategoryData *category;
@property(nonatomic) BookmarkData *bookmark;
@property(nonatomic) DesignData   *design;
@property(nonatomic) UIView       *cellBackgroundView;
@property(nonatomic) float        cellWidth;
@property(nonatomic) float        cellInnerWidth;

@end

@implementation MainTableCellView

//--------------------------------------------------------------//
#pragma mark -- initialize --
//--------------------------------------------------------------//

+ (id)initWithCellIdentifier:(NSString *)cellIdentifier {
    MainTableCellView *cell = [[MainTableCellView alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    return cell;
}

- (id)setupWithPageData:(PageData *)page tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    _tableView = tableView;
    _category = [page getCategoryListByTag:_tableView.tag][indexPath.section];
    _bookmark = [_category getBookmarkList][indexPath.row];
    _cellBackgroundView = [[UIView alloc] init];
    _cellWidth = _tableView.contentSize.width - kAdaptWidthOfTableCell;
    _cellInnerWidth = _tableView.contentSize.width - (kAdaptWidthOfTableCell + kOffsetXOfTableCell);
    _design = [[DataManager sharedManager] getDesign];

    // 背景設定
    [self _setupBackground];

    // セルの選択時の背景指定
    [self _setupCellSelectBackground];

    // セルの右側に矢印アイコンを表示
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    // ボーダーライン設定
    [self _setupBorder];

    // 文言設定
    [self _setupText];

    return self;
}

- (void)setFrame:(CGRect)frame {
    // cellのframeを変更するため、setFrameをOverWrideする
    frame.origin.x += kOffsetXOfTableCell;
    frame.size.width = _cellWidth;
    [super setFrame:frame];
}

//--------------------------------------------------------------//
#pragma mark -- SetUP Method --
//--------------------------------------------------------------//

- (void)_setupBackground {
    // 後面の背景指定
    _cellBackgroundView.backgroundColor = [[_category color] getBackGroundColor];

    // セクションの最後のセルの場合はfooterのUIViewを付ける
    if ([self _isLastCellOfSection]) {
        UIView *footerView = [self createFooterViewOfLastCell];
        [_cellBackgroundView addSubview:footerView];
    }

    // 前面の背景指定
    float width = _cellInnerWidth;
    float height = self.bounds.size.height;
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(self.bounds.origin.x + kSizeOfTableFrame, self.bounds.origin.y, width, height);
    layer.backgroundColor = [_design getTableBackGroundColor].CGColor;
    [_cellBackgroundView.layer addSublayer:layer];

    self.backgroundView = _cellBackgroundView;
}

- (void)_setupCellSelectBackground {
    // 後面の背景指定
    UIView *cellSelectedBackgroundView = [[UIView alloc] init];
    cellSelectedBackgroundView.backgroundColor = [[_category color] getBackGroundColor];

    // セクションの最後のセルの場合はfooterのUIViewを付ける
    if ([self _isLastCellOfSection]) {
        UIView *footerView = [self createFooterViewOfLastCell];
        [cellSelectedBackgroundView addSubview:footerView];
    }

    // 前面の背景指定
    float width = _cellInnerWidth;
    float height = self.bounds.size.height + 1;
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(self.bounds.origin.x + kSizeOfTableFrame, self.bounds.origin.y, width, height);
    UIColor *backGroundColor = [self _getCellSelectBackgroundColor:[_design getTableBackGroundColor]];
    layer.backgroundColor = backGroundColor.CGColor;
    [cellSelectedBackgroundView.layer addSublayer:layer];

    self.selectedBackgroundView = cellSelectedBackgroundView;
}

- (void)_setupBorder {
    // セルのボーダーライン配置（既定のだと後面の背景まで線が越えてしまうため）
    if (![self _isFirstCellOfSection]) {
        CGRect rect = CGRectMake(self.bounds.origin.x + kSizeOfTableFrame, self.bounds.origin.y, _cellInnerWidth, kHeightOfBorderLine);
        UIView *borderline = [[UIView alloc] initWithFrame:rect];
        borderline.backgroundColor = [UIColor lightGrayColor];;
        [_cellBackgroundView addSubview:borderline];
    }
}

- (void)_setupText {
    // ブックマーク名、URLを設定
    self.textLabel.text = _bookmark.name;
    self.textLabel.textColor = [_design getbookmarkColor];
    self.textLabel.font = [UIFont fontWithName:kDefaultFont size:kFontSizeOfBookmark];
    self.detailTextLabel.text = _bookmark.url;
    self.detailTextLabel.textColor = [_design getUrlColor];
    self.detailTextLabel.font = [UIFont fontWithName:kDefaultFont size:kFontSizeOfUrl];
}

//--------------------------------------------------------------//
#pragma mark -- Cell Helper Method --
//--------------------------------------------------------------//

- (BOOL)_isFirstCellOfSection {
    // 先頭のセルか判定
    return (_indexPath.row == 0) ? YES : NO;
}

- (BOOL)_isLastCellOfSection {
    // 末尾のセルか判定
    NSArray *bookmarkList = [_category getBookmarkList];
    int lastCellIndex = (int)_indexPath.row + 1;
    return (lastCellIndex == bookmarkList.count) ? YES : NO;
}

- (UIColor *)_getCellSelectBackgroundColor:(UIColor *)baseColor {
    // セルをタップされた時の背景色を取得
    // 現在、設定されている背景色から目立つカラーを自動選定する
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    [baseColor getRed:&red green:&green blue:&blue alpha:&alpha];

    if (red < 0.5f) {
        red += 0.1;
        green += 0.1;
        blue += 0.1;
    } else {
        red -= 0.1;
        green -= 0.1;
        blue -= 0.1;
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (UIView *)createFooterViewOfLastCell {
    // セクションの最後のセルに付けるfooterのUIViewを生成
    int x = self.bounds.origin.x;
    int y = self.bounds.origin.y + self.bounds.size.height;
    float width = _cellWidth;
    float height = kSizeOfTableFrame;
    CGRect rect = CGRectMake(x, y, width, height);

    UIView *footerView = [[UIView alloc] initWithFrame:rect];
    footerView.backgroundColor = [[_category color] getBackGroundColor];

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

@end
