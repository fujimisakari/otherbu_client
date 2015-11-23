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
#import "SGDesignAlertController.h"
#import "CellDesignView.h"

@interface SGDesignTableViewController () {
    NSArray *_menuList;
    NSMutableArray *_menuIndexPathList;
    NSMutableArray *_openFlagArray;
    UICollectionView *_collectionView;
    UISlider *_slider;
    CellDesignView *_cellDesignView;
    NSArray *_colorList;
    NSArray *_bookmarkBGColorList;
    NSString *_colorCode;
    UICollectionViewCell *_colorSelectCell;
    SGDesignAlertController *_alertController;
}

@end

@implementation SGDesignTableViewController

// メニューのArray番号
const int kBackgroundChengeMenuIdx = 0;
const int kBackgroundColorChengeMenuIdx = 1;
const int kBackgroundAlphaChengeMenuIdx = 2;
const int kNameFontColorChengeMenuIdx = 3;
const int kUrlFontColorChengeMenuIdx = 4;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = [NSString stringWithFormat:@"%@%@", kMenuDesignName, @"設定"];

    _menuIndexPathList = [[NSMutableArray alloc] init];

    _menuList = @[ @"背景画像を変更", @"Bookmark背景色の変更", @"Bookmark背景の透明度変更", @"Bookmark名の色の変更", @"BookmarkURLの色の変更" ];

    // カラーパレット用のカラーリスト
    _colorList = [[DataManager sharedManager] getColorList];
    _bookmarkBGColorList = [[DataManager sharedManager] getBookmarkBGColorList];

    // 背景画像の変更用のActionSheetを準備
    _alertController = [SGDesignAlertController alertControllerWithTitle:@"背景画像を変更"
                                                                 message:@""
                                                          preferredStyle:UIAlertControllerStyleActionSheet];
    [_alertController setup:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

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

    // カラーパレットの生成
    int y = kCellHeightOfSGColorPalette - kCellMarginOfSGColorPalette;
    CGRect colorRect = CGRectMake(0, y, self.view.frame.size.width, kCellHeightOfSGColorPalette);
    [self _setColorPalette:colorRect];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;

    // スライダーの生成
    [self _setSlider];
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

- (void)updateBackgroundView {
    [super updateBackgroundView];
}

//--------------------------------------------------------------//
#pragma mark -- set Slider --
//--------------------------------------------------------------//

-(void)_setSlider {
    // 透明度用のスライダー
    int size = self.view.frame.size.width - (kCellMarginOfSlider * 2);
    int height = 20;
    int y = kCellHeightOfSlider / 2 + height;
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(kCellMarginOfSlider, y, size, height)];
    _slider.minimumValue = 0.00f;  // 最小値
    _slider.maximumValue = 1.00f;  // 最大値
    _slider.value = [[DataManager sharedManager] getDesign].alpha;  // 初期値
    [_slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
}

-(void)sliderAction:(UISlider *)slider{
    // データの保存
    [[[DataManager sharedManager] getDesign] updateAlpha:slider.value];
    [[DataManager sharedManager] save:SAVE_DESIGN];
    _cellDesignView.backgroundColor = [[[DataManager sharedManager] getDesign] getTableBackGroundColor];
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
        [self presentViewController:_alertController animated:YES completion:nil];
    } else if (indexPath.row == kBackgroundAlphaChengeMenuIdx) {
        // スライダーの場合
        if ([[_openFlagArray objectAtIndex:indexPath.row] boolValue]) {
            // すでに表示していた場合
            [self _openFlagReset];
            NSArray *indexPaths = [_menuIndexPathList copy];
            [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            _menuIndexPathList = [[NSMutableArray alloc] init];
        } else {
            // 表示する場合
            [self _openFlagReset];
            _openFlagArray[indexPath.row] = @"1";
            [_menuIndexPathList addObject:indexPath];
            NSArray *indexPaths = [_menuIndexPathList copy];
            [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            // すでに表示されていたindexPathが入ってる場合があるので
            // 今回表示するindexPathのみ入ってる状態にする
            _menuIndexPathList = [[NSMutableArray alloc] init];
            [_menuIndexPathList addObject:indexPath];
        }
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
                _colorCode = [[DataManager sharedManager] getDesign].tableBackGroundColor;
            } else {
                if (indexPath.row == kNameFontColorChengeMenuIdx) {
                    _colorCode = [[DataManager sharedManager] getDesign].bookmarkColor;
                } else {
                    _colorCode = [[DataManager sharedManager] getDesign].urlColor;
                }
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
        if (indexPath.row == kBackgroundAlphaChengeMenuIdx) {
            return kCellHeightOfSlider;
        } else {
            return kCellHeightOfSGColorPalette;
        }
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

        // 1つCellをキャッシュで使い回しされるので
        // UISliderとUICollectionViewはキャッシュから削除してから利用する
        for (UIView *view in cell.contentView.subviews) {
            if ([[[view class] description] isEqualToString:@"UISlider"] ||
                [[[view class] description] isEqualToString:@"UICollectionView"]) {
                [view removeFromSuperview];
            }
        }

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

        if (indexPath.row == kBackgroundAlphaChengeMenuIdx) {
            // スライダー配置
            [cell.contentView addSubview:_slider];
        } else {
            // カラーパレット配置
            [cell.contentView addSubview:_collectionView];
        }

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
    NSInteger idx = indexPath.section == 0 ? indexPath.row : indexPath.row + (kColumnOfColorPalette * indexPath.section);
    ColorData *colorData = [self _getColorData:(int)idx];

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

- (ColorData *)_getColorData:(int)idx {
    // ブックマック背景色だった場合
    for (int i = 0; i < _menuList.count; ++i) {
        if([[_openFlagArray objectAtIndex:i] boolValue] && i == kBackgroundColorChengeMenuIdx) {
            return _bookmarkBGColorList[idx];
        }
    }
    return _colorList[idx];
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
    ColorData *colorData = [self _getColorData:(int)idx];
    _colorCode = colorData.thumbnailColorCode;

    // 選択してたカラー枠をシアンにしてキャッシュ
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.borderColor = [UIColor cyanColor].CGColor;
    _colorSelectCell = cell;

    // 更新処理
    [self _updateColor:colorData];

    // データの同期登録、保存
    [[DataManager sharedManager] updateSyncData:[[DataManager sharedManager] getDesign] DataType:SAVE_DESIGN Action:@"update"];
    [[DataManager sharedManager] save:SAVE_DESIGN];
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
    DesignData *design = [[DataManager sharedManager] getDesign];
    for (int i = 0; i < _menuList.count; ++i) {
        if ([[_openFlagArray objectAtIndex:i] boolValue]) {
            switch (i) {
                // ブックマーク背景が更新の場合
                case kBackgroundColorChengeMenuIdx: {
                    [design updateTableBackGroundColor:colorData.thumbnailColorCode];
                    [_cellDesignView setBackgroundColor:[design getTableBackGroundColor]];
                } break;
                // ブックマークの文字色が更新の場合
                case kNameFontColorChengeMenuIdx: {
                    [design updatetbookmarkNameColor:colorData.thumbnailColorCode];
                    [_cellDesignView setBookmarkNameColor:[design getbookmarkColor]];
                } break;
                // ブックマークの文字色が更新の場合
                case kUrlFontColorChengeMenuIdx: {
                    [design updatetbookmarkUrlColor:colorData.thumbnailColorCode];
                    [_cellDesignView setBookmarkUrlColor:[design getUrlColor]];
                } break;
            }
        }
    }
}

@end
