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
    NSMutableArray *_colorList;
    NSInteger _colorId;
    UICollectionViewCell *_colorSelectCell;
}

@end

@implementation EditModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 編集前のデータ
    _colorId = [_editItem iGetColorId];

    // カラーパレット用のカラーリスト
    _colorList = [[DataManager sharedManager] getColorList];

    // EditViewを生成
    _editModalView = [[EditModalView alloc] initWithFrame:(CGRect)self.view.frame];
    _editModalView.editItem = _editItem;
    _editModalView.delegate = self;
    [self.view addSubview:_editModalView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0.1 alpha:0.4];

    // EditViewの各パーツの生成
    [_editModalView setup];
    _editModalView.collectionView.delegate = self;
    _editModalView.collectionView.dataSource = self;
    _editModalView.textField.delegate = self;
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
    NSInteger idx = indexPath.section == 0 ? indexPath.row : indexPath.row + (kColumnOfColorPalette * (int)indexPath.section);
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
    NSInteger idx = indexPath.section == 0 ? indexPath.row : indexPath.row + (kColumnOfColorPalette * indexPath.section);
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

//--------------------------------------------------------------//
#pragma mark -- UITextFieldDelegate --
//--------------------------------------------------------------//

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_editModalView.textField resignFirstResponder];
    return YES;
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
    [_editItem iSetName:_editModalView.textField.text];
    [_editItem iSetColorId:_colorId];
    [self.delegate retrunActionOfEditModal:[_editItem iGetMenuId]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
