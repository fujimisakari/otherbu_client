//
//  ModalViewController.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "ModalViewController.h"
#import "ModalView.h"
#import "ColorData.h"

@interface ModalViewController () {
    ModalView *_modalView;
    NSArray *_colorList;
    NSString *_colorId;
    UICollectionViewCell *_colorSelectCell;
}

@end

@implementation ModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // EditViewを生成
    _modalView = [[ModalView alloc] initWithFrame:(CGRect)self.view.frame];
    _modalView.editItem = _editItem;
    _modalView.delegate = self;
    [self.view addSubview:_modalView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // 編集前のデータ
    _colorId = [_editItem iGetColorId];

    // カラーパレット用のカラーリスト
    _colorList = [[DataManager sharedManager] getColorList];

    // 背景設定
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0.1 alpha:0.4];

    // EditViewの各パーツの生成
    [_modalView setup];
    _modalView.collectionView.delegate = self;
    _modalView.collectionView.dataSource = self;
    _modalView.nameTextField.delegate = self;
}

- (UIModalPresentationStyle)modalPresentationStyle {
    // modalView以外の背景が黒になってしまう問題の対応
    return UIModalPresentationOverCurrentContext;
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
    if ([_colorId isEqualToString:colorData.dataId]) {
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
    float viewWidth = _modalView.frame.size.width - kAdaptWidthOfEditModal;
    float totalCellWidth = (kCellSizeOfColorPalette + kBorderWidthOfColorPalette * 2) * kColumnOfColorPalette;
    float restViewWidth = viewWidth - totalCellWidth - (kCellMarginOfColorPalette * 5);
    float marginWidth = restViewWidth / 2;
    return UIEdgeInsetsMake(5, marginWidth, 0, marginWidth);
}

//--------------------------------------------------------------//
#pragma mark -- UITextFieldDelegate --
//--------------------------------------------------------------//

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // キーボードのreturn or 改行でキーボードを閉じる
    [textField resignFirstResponder];
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
    // 新規追加、更新時

    [_editItem iSetName:_modalView.nameTextField.text];
    [_editItem iSetColorId:_colorId];

    if ([_editItem isCreateMode]) {
        [_editItem addNewData];
    }

    [self.delegate retrunActionOfEditModal:[_editItem iGetMenuId]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
