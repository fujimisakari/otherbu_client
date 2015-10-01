//
//  ModalBKViewController.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "ModalBKViewController.h"
#import "ModalBKView.h"
#import "ModalValidatedAlertView.h"
#import "BookmarkData.h"
#import "CategoryData.h"

@interface ModalBKViewController () {
    ModalBKView *_modalView;
    NSArray *_categoryList;
    ModalValidatedAlertView *_validatedAlert;
}

@end

@implementation ModalBKViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // EditViewを生成
    _modalView = [[ModalBKView alloc] initWithFrame:(CGRect)self.view.frame];
    _modalView.editItem = _editItem;
    _modalView.delegate = self;
    [self.view addSubview:_modalView];

    // 背景をクリックしたら、キーボードを隠す
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_closeSoftKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    _categoryList = [[DataManager sharedManager] getCategoryList];

    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0.1 alpha:0.4];

    // EditViewの各パーツの生成
    [_modalView setup];
    _modalView.nameTextField.delegate = self;
    _modalView.urlTextField.delegate = self;
    _modalView.categoryPicker.delegate = self;
    _modalView.categoryPicker.dataSource = self;
    if (![_editItem isCreateMode]) {
        [self _pickerSelectRow];
    }

    // バリデートの警告View生成
    _validatedAlert = [[ModalValidatedAlertView alloc] init];
    [_validatedAlert setup];
}

- (UIModalPresentationStyle)modalPresentationStyle {
    // modalView以外の背景が黒になってしまう問題の対応
    return UIModalPresentationOverCurrentContext;
}

//--------------------------------------------------------------//
#pragma mark -- UIPickerViewDataSource --
//--------------------------------------------------------------//

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _categoryList.count;
}

//--------------------------------------------------------------//
#pragma mark -- UIPickerViewDelegate --
//--------------------------------------------------------------//

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    CategoryData *category = _categoryList[row];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 30)];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:kFontSizeOfTitle];
    label.text = [NSString stringWithFormat:@"   %@", category.name];
    return label;
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
    if ([_modalView.nameTextField.text isEqualToString:@""] || [_modalView.nameTextField.text isEqualToString:@""] ||
        _categoryList.count == 0) {
        [_validatedAlert show];
        return;
    }

    // 名前
    [_editItem iSetName:_modalView.nameTextField.text];
    // URL
    [_editItem iSetUrl:_modalView.urlTextField.text];
    // カテゴリ
    NSInteger row = [_modalView.categoryPicker selectedRowInComponent:0];
    CategoryData *category = _categoryList[row];
    [_editItem iSetCategoryId:category.dataId];

    // 新規追加
    if ([_editItem isCreateMode]) {
        [_editItem addNewData];
        [[DataManager sharedManager] updateSyncData:_editItem DataType:SAVE_BOOKMARK Action:@"insert"];
    } else {
        [[DataManager sharedManager] updateSyncData:_editItem DataType:SAVE_BOOKMARK Action:@"update"];
    }

    [[DataManager sharedManager] save:SAVE_BOOKMARK];

    [self.delegate returnActionOfModal:[_editItem iGetMenuId]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//--------------------------------------------------------------//
#pragma mark -- Private Method --
//--------------------------------------------------------------//

- (void)_pickerSelectRow {
    // セレクトボックスのデフォルト値をブックマークのカテゴリにする
    BookmarkData *bookmark = (BookmarkData *)_editItem;
    CategoryData *category = [bookmark category];
    NSInteger row = [_categoryList indexOfObject:category];
    [_modalView.categoryPicker selectRow:row inComponent:0 animated:YES];
}

- (void)_closeSoftKeyboard {
    // キーボードを隠す
    [self.view endEditing: YES];
}

@end
