//
//  ModalViewController.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "ModalViewController.h"
#import "ModalView.h"
#import "ModalPageViewController.h"
#import "ModalValidatedAlertView.h"
#import "PageData.h"
#import "ColorData.h"

@interface ModalViewController () {
    ModalView *_modalView;
    NSArray *_colorList;
    NSString *_colorId;
    UICollectionViewCell *_colorSelectCell;
    ModalValidatedAlertView *_validatedAlert;
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

    // 背景をキリックしたら、キーボードを隠す
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_closeSoftKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
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

    // バリデートの警告View生成
    _validatedAlert = [[ModalValidatedAlertView alloc] init];
    [_validatedAlert setup];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [_modalView deleteSubviews];
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
    float viewWidth = _modalView.frame.size.width - kAdaptWidthOfModal;
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
#pragma mark -- ModalViewDelegate --
//--------------------------------------------------------------//

- (void)didPressCancelButton {
    // キャンセル時
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didPressUpdateButton {
    // 新規追加、更新時

    // バリデートチェック
    if ([_modalView.nameTextField.text isEqualToString:@""] || !_colorId) {
        [_validatedAlert show];
        return;
    }

    [_editItem iSetName:_modalView.nameTextField.text];
    [_editItem iSetColorId:_colorId];

    if ([_editItem iGetMenuId] == MENU_PAGE) {
        // ページの場合
        if ([_editItem isCreateMode]) {
            [_editItem addNewData];
            [[DataManager sharedManager] updateSyncData:_editItem DataType:SAVE_PAGE Action:@"insert"];
            [self performSegueWithIdentifier:kToModalPageViewBySegue sender:self];
        } else {
            [[DataManager sharedManager] updateSyncData:_editItem DataType:SAVE_PAGE Action:@"update"];
            [self.delegate returnActionOfModal:[_editItem iGetMenuId]];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        [[DataManager sharedManager] save:SAVE_PAGE];
    } else {
        // カテゴリの場合
        if ([_editItem isCreateMode]) {
            [_editItem addNewData];
            [[DataManager sharedManager] updateSyncData:_editItem DataType:SAVE_CATEGORY Action:@"insert"];
        } else {
            [[DataManager sharedManager] updateSyncData:_editItem DataType:SAVE_CATEGORY Action:@"update"];
        }
        [[DataManager sharedManager] save:SAVE_CATEGORY];
        [self.delegate returnActionOfModal:[_editItem iGetMenuId]];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

//--------------------------------------------------------------//
#pragma mark -- segue --
//--------------------------------------------------------------//

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:kToModalPageViewBySegue]) {
        ModalPageViewController *modalPageViewController = (ModalPageViewController *)[segue destinationViewController];
        modalPageViewController.page = (PageData *)_editItem;
        modalPageViewController.delegate = self;
    }
}

- (void)closeModalView {
    // 画面を閉じる
    [self.delegate returnActionOfModal:[_editItem iGetMenuId]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//--------------------------------------------------------------//
#pragma mark -- Private Method --
//--------------------------------------------------------------//

- (void)_closeSoftKeyboard {
    // キーボードを隠す
    [self.view endEditing: YES];
}

@end
