//
//  SGDesignTableViewController.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "SGDesignTableViewController.h"
#import "DescHeaderView.h"
#import "BookmarkData.h"
#import "CategoryData.h"
#import "ColorData.h"
#import "DesignData.h"
#import "CellDesignView.h"

@interface SGDesignTableViewController () {
    NSArray *_menuList;
    NSMutableArray *_menuIndexPathList;
    NSMutableArray *_openFlagArray;
    UICollectionView *_collectionView;
    CellDesignView *_cellDesignView;
    NSArray *_colorList;
    NSString *_colorCode;
    UICollectionViewCell *_colorSelectCell;
}

@end

@implementation SGDesignTableViewController

// メニューのArray番号
const int kBackgroundChengeMenuIdx = 0;
const int kBackgroundColorChengeMenuIdx = 1;
const int kFontColorChengeMenuIdx = 2;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = [NSString stringWithFormat:@"%@%@", kMenuDesignName, @"設定"];

    _menuList = @[ @"背景画像の変更", @"Bookmark背景色の変更", @"Bookmark文字色の変更" ];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    _menuIndexPathList = [[NSMutableArray alloc] init];

    // 説明Headerを追加
    DescHeaderView *descHeaderView = [[DescHeaderView alloc] init];
    CGSize size = CGSizeMake(self.view.frame.size.width - (kOffsetXOfTableCell * 2), kHeightOfSettingDesc + kMarginOfSettingDesc);
    [descHeaderView setupWithCGSize:size descMessage:@"背景画像変更、カラー設定ができます"];
    CGRect reRect = CGRectMake(0, descHeaderView.frame.origin.y, descHeaderView.frame.size.width, descHeaderView.frame.size.height);
    descHeaderView.frame = reRect;

    // サンプルCellを生成
    CGRect cellRect = CGRectMake(0, 0, size.width, size.height + 60);
    _cellDesignView = [[CellDesignView alloc] initWithFrame:cellRect];
    [_cellDesignView setup];
    [_cellDesignView addSubview:descHeaderView];
    [self.tableView setTableHeaderView:_cellDesignView];

    // カラーパレット用のカラーリスト
    _colorList = [[DataManager sharedManager] getColorList];

    // カラーパレットの生成
    int y = kCellHeightOfSGColorPalette - kCellMarginOfSGColorPalette;
    CGRect colorRect = CGRectMake(0, y, self.view.frame.size.width, kCellHeightOfSGColorPalette);
    [self _setColorPalette:colorRect];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
}

- (void)_setColorPalette:(CGRect)rect {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    float cellSize = kCellSizeOfColorPalette;
    layout.itemSize = CGSizeMake(cellSize, cellSize);            //表示するアイテムのサイズ
    layout.minimumLineSpacing = kCellMarginOfColorPalette;       //セクションとアイテムの間隔
    layout.minimumInteritemSpacing = kCellMarginOfColorPalette;  //アイテム同士の間隔

    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.frame = rect;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
}

//--------------------------------------------------------------//
#pragma mark -- UITableViewDataSource --
//--------------------------------------------------------------//

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _menuList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.text = _menuList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // セルをタップされた場合
    if (indexPath.row == kBackgroundChengeMenuIdx) {
        // 背景画像の変更の場合、アクションシートを表示
    } else {
        // Bookmarkの色の変更の場合、セルにカラーパレット表示する
        if ([[_openFlagArray objectAtIndex:indexPath.row] boolValue]) {
            // すでに表示していた場合
            [self _openFlagReset];
            NSArray *indexPaths = [_menuIndexPathList copy];
            [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            [_collectionView reloadData];
            _menuIndexPathList = [[NSMutableArray alloc] init];
        } else {
            // 表示する場合
            [self _openFlagReset];
            if (indexPath.row == kBackgroundColorChengeMenuIdx) {
                _colorCode = [DesignData shared].tableBackGroundColor;
            } else {
                _colorCode = [DesignData shared].bookmarkColor;
            }
            _openFlagArray[indexPath.row] = @"1";
            [_menuIndexPathList addObject:indexPath];
            NSArray *indexPaths = [_menuIndexPathList copy];
            [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            [_collectionView reloadData];
            // すでに表示されていたindexPathが入ってる場合があるので
            // 今回表示するindexPathのみ入ってる状態にする
            _menuIndexPathList = [[NSMutableArray alloc] init];
            [_menuIndexPathList addObject:indexPath];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[_openFlagArray objectAtIndex:indexPath.row] boolValue]) {
        return kCellHeightOfSGColorPalette;
    } else {
        return kCellHeightOfSetting;
    }
}

- (void)_openFlagReset {
    _openFlagArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < _menuList.count; ++i) {
        [_openFlagArray addObject:@"0"];
    }
}

//--------------------------------------------------------------//
#pragma mark -- UITableViewDelegate --
//--------------------------------------------------------------//

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];

    if ([[_openFlagArray objectAtIndex:indexPath.row] boolValue]) {
        // ラベル生成
        float _width = cell.frame.size.width - kCellMarginOfSetting * 3;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _width, kCellHeightOfSetting)];
        label.backgroundColor = [UIColor clearColor];
        label.text = cell.textLabel.text;
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(16, 5, _width, kCellHeightOfSetting)];
        label.backgroundColor = [UIColor clearColor];
        [container addSubview:label];
        [cell.contentView addSubview:container];

        // 区切り線の生成
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(16, 5 + kCellHeightOfSetting, _width, 1)];
        separator.backgroundColor = [UIColor blackColor];
        [cell.contentView addSubview:separator];

        // カラーパレット配置
        [cell.contentView addSubview:_collectionView];

        cell.textLabel.text = @"";
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

//--------------------------------------------------------------//
#pragma mark -- UICollectionViewDataSource --
//--------------------------------------------------------------//

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    // 行数
    return kRowOfColorPalette;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // 列数
    return kColumnOfColorPalette;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // cellオブジェクトを生成
    NSInteger idx = indexPath.section == 0 ? indexPath.row : indexPath.row + (kColumnOfColorPalette * (int)indexPath.section);
    ColorData *colorData = _colorList[idx];

    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [colorData getThumbnailColor];
    cell.layer.borderWidth = kBorderWidthOfColorPalette;
    if ([_colorCode isEqualToString:colorData.thumbnailColorCode]) {
        cell.layer.borderColor = [UIColor cyanColor].CGColor;
        _colorSelectCell = cell;
    } else {
        cell.layer.borderColor = [UIColor grayColor].CGColor;
    }
    return cell;
}

//--------------------------------------------------------------//
#pragma mark -- UICollectionViewDelegate --
//--------------------------------------------------------------//

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // cellをタッチした場合

    // 前に選択してたカラー枠をグレーへ
    _colorSelectCell.layer.borderColor = [UIColor grayColor].CGColor;

    // タッチしたカラーIDをキャッシュ
    NSInteger idx = indexPath.section == 0 ? indexPath.row : indexPath.row + (kColumnOfColorPalette * indexPath.section);
    ColorData *colorData = _colorList[idx];
    _colorCode = colorData.thumbnailColorCode;

    // 選択してたカラー枠をシアンにしてキャッシュ
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.borderColor = [UIColor cyanColor].CGColor;
    _colorSelectCell = cell;

    // 更新処理
    [self _updateColor:colorData];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    // セクションの上左下右のマージン
    float viewWidth = self.view.frame.size.width;
    float totalCellWidth = (kCellSizeOfColorPalette + kBorderWidthOfColorPalette * 2) * kColumnOfColorPalette;
    float restViewWidth = viewWidth - totalCellWidth - (kCellMarginOfColorPalette * 5);
    float marginWidth = restViewWidth / 2;
    return UIEdgeInsetsMake(5, marginWidth, 0, marginWidth);
}

- (void)_updateColor:(ColorData *)colorData {
    for (int i = 0; i < _menuList.count; ++i) {
        if ([[_openFlagArray objectAtIndex:i] boolValue]) {
            switch (i) {
                // ブックマーク背景が更新の場合
                case kBackgroundColorChengeMenuIdx: {
                    [[DesignData shared] updateTableBackGroundColor:colorData.thumbnailColorCode];
                    [_cellDesignView setBackgroundColor:[[DesignData shared] getTableBackGroundColor]];
                } break;
                // ブックマークの文字色が更新の場合
                case kFontColorChengeMenuIdx: {
                    [[DesignData shared] updatetbookmarkColor:colorData.thumbnailColorCode];
                    [_cellDesignView setBookmarkNameColor:[[DesignData shared] getbookmarkColor]];
                } break;
            }
        }
    }
}

@end
