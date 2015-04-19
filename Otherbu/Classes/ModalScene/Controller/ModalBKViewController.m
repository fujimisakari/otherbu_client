//
//  ModalBKViewController.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "ModalBKViewController.h"
#import "ModalBKView.h"
#import "BookmarkData.h"
#import "CategoryData.h"

@interface ModalBKViewController () {
    ModalBKView *_modalView;
    NSArray *_categoryList;
}

@end

@implementation ModalBKViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _categoryList = [[DataManager sharedManager] getCategoryList];

    // EditViewを生成
    _modalView = [[ModalBKView alloc] initWithFrame:(CGRect)self.view.frame];
    _modalView.editItem = _editItem;
    _modalView.delegate = self;
    [self.view addSubview:_modalView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0.1 alpha:0.4];

    // EditViewの各パーツの生成
    [_modalView setup];
    _modalView.nameTextField.delegate = self;
    _modalView.urlTextField.delegate = self;
    _modalView.categoryPicker.delegate = self;
    _modalView.categoryPicker.dataSource = self;
    [self _pickerSelectRow];
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
#pragma mark -- EditModalViewDelegate --
//--------------------------------------------------------------//

- (void)didPressCancelButton {
    // キャンセル時
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didPressUpdateButton {
    // 新規追加、更新時
    if ([_editItem isCreateMode]) {
        
    }
    // 名前
    [_editItem iSetName:_modalView.nameTextField.text];
    // URL
    [_editItem iSetUrl:_modalView.urlTextField.text];
    // カテゴリ
    NSInteger row = [_modalView.categoryPicker selectedRowInComponent:0];
    CategoryData *category = _categoryList[row];
    [_editItem iSetCategoryId:category.dataId];

    [self.delegate retrunActionOfEditModal:[_editItem iGetMenuId]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//--------------------------------------------------------------//
#pragma mark -- Private Method --
//--------------------------------------------------------------//

- (void)_pickerSelectRow {
    BookmarkData *bookmark = (BookmarkData *)_editItem;
    CategoryData *category = [bookmark category];
    NSInteger row = [_categoryList indexOfObject:category];
    [_modalView.categoryPicker selectRow:row inComponent:0 animated:YES];
}

@end
