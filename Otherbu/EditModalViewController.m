//
//  EditModalViewController.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "EditModalViewController.h"
#import "EditModalView.h"
#import "ColorData.h"

@interface EditModalViewController () {
    EditModalView *_editModalView;
    UICollectionView *_collectionView;
    UICollectionViewCell *_colorSelectCell;
    NSMutableArray *_colorList;
    NSString *_name;
    NSInteger _colorId;
}

@end

@implementation EditModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 編集前のデータ
    _name = [_editItem iGetName];
    _colorId = [_editItem iGetColorId];

    // カラーパレット用のカラーリスト
    _colorList = [[DataManager sharedManager] getColorList];

    // 編集Viewを生成
    _editModalView = [EditModalView initWithFrame:(CGRect)self.view.frame];
    _editModalView.editItem = _editItem;
    _editModalView.delegate = self;
    [self.view addSubview:_editModalView];

    // カラーパレットを生成
    [self _createColorPalette];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0.1 alpha:0.4];

    [_editModalView setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIModalPresentationStyle)modalPresentationStyle {
    return UIModalPresentationOverCurrentContext;
}

- (void)setEditItem:(id<DataInterface>)editItem {
    _editItem = editItem;
}

//--------------------------------------------------------------//
#pragma mark -- Set Method --
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
    int idx = indexPath.section == 0 ? indexPath.row : indexPath.row + (kColumnOfColorPalette * indexPath.section);
    ColorData *colorData = _colorList[idx];

    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [colorData getThumbnailColor];
    cell.layer.borderWidth = kBorderWidthOfColorPalette;
    if (_colorId == colorData.dataId) {
        cell.layer.borderColor = [UIColor cyanColor].CGColor;
        _colorSelectCell = cell;
    } else {
        cell.layer.borderColor = [UIColor grayColor].CGColor;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // cellをタッチした場合

    // 前に選択してたカラー枠をグレーへ
    _colorSelectCell.layer.borderColor = [UIColor grayColor].CGColor;

    // タッチしたカラーIDをキャッシュ
    int idx = indexPath.section == 0 ? indexPath.row : indexPath.row + (kColumnOfColorPalette * indexPath.section);
    ColorData *colorData = _colorList[idx];
    _colorId = colorData.dataId;

    // 選択してたカラー枠をシアンにしてキャッシュ
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.borderColor = [UIColor cyanColor].CGColor;
    _colorSelectCell = cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    // セクションの上左下右のマージン
    float viewWidth = _editModalView.frame.size.width - kAdaptWidthOfEditModal;
    float totalCellWidth = (kCellSizeOfColorPalette + kBorderWidthOfColorPalette * 2) * kColumnOfColorPalette;
    float restViewWidth = viewWidth - totalCellWidth - (kCellMarginOfColorPalette * 5);
    float marginWidth = restViewWidth / 2;
    return UIEdgeInsetsMake(5, marginWidth, 0, marginWidth);
}

- (void) _createColorPalette {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    float cellSize = kCellSizeOfColorPalette;
    layout.itemSize = CGSizeMake(cellSize, cellSize);            //表示するアイテムのサイズ
    layout.minimumLineSpacing = kCellMarginOfColorPalette;       //セクションとアイテムの間隔
    layout.minimumInteritemSpacing = kCellMarginOfColorPalette;  //アイテム同士の間隔

    float width = _editModalView.frame.size.width - (kAdaptWidthOfEditModal * 2);
    float height = kViewHeightOfColorPalette;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
    _collectionView.frame = CGRectMake(kAdaptWidthOfEditModal, 180, width, height);
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_editModalView addSubview:_collectionView];
}

//--------------------------------------------------------------//
#pragma mark -- EditModalViewDelegate --
//--------------------------------------------------------------//

- (void)didPressCancelButton {
    // キャンセル時
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didPressUpdateButton {
    // 更新時
    [_editItem iSetName:_name];
    [_editItem iSetColorId:_colorId];
    [self.delegate retrunActionOfEditModal:[_editItem iGetMenuId]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
