//
//  BookmarkEditModalViewController.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "BookmarkEditModalViewController.h"
#import "EditModalBookmarkView.h"
#import "CategoryData.h"

@interface BookmarkEditModalViewController () {
    EditModalBookmarkView *_editModalView;
    NSArray *_categoryList;
}

@end

@implementation BookmarkEditModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _categoryList = [[DataManager sharedManager] getCategoryList];

    // EditViewを生成
    _editModalView = [[EditModalBookmarkView alloc] initWithFrame:(CGRect)self.view.frame];
    _editModalView.editItem = _editItem;
    _editModalView.delegate = self;
    [self.view addSubview:_editModalView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0.1 alpha:0.4];

    // EditViewの各パーツの生成
    [_editModalView setup];
    _editModalView.nameTextField.delegate = self;
    _editModalView.urlTextField.delegate = self;
    _editModalView.categoryPicker.delegate = self;
    _editModalView.categoryPicker.dataSource = self;
}

- (UIModalPresentationStyle)modalPresentationStyle {
    // modalView以外の背景が黒になってしまう問題の対応
    return UIModalPresentationOverCurrentContext;
}

//--------------------------------------------------------------//
#pragma mark-- UIPickerViewDelegate--
//--------------------------------------------------------------//

/**
 * ピッカーに表示する列数を返す
 */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

/**
 * ピッカーに表示する行数を返す
 */
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _categoryList.count;
}

/**
 * 行のサイズを変更
 */
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return _editModalView.frame.size.width - (kAdaptButtonWidthOfEditModal * 2);
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return kCommonHeightOfEditModal;
}

/**
 * ピッカーに表示する値を返す
 */
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    CategoryData *category = _categoryList[row];
    return [NSString stringWithFormat:@"%@", category.name];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    CategoryData *category = _categoryList[row];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 200)];
    // label.backgroundColor = [UIColor grayColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    label.text = [NSString stringWithFormat:@"%@", category.name];

    // UILabel *label = [[UILabel alloc] init];
    // label.backgroundColor = [UIColor blueColor];
    // label.textColor = [UIColor whiteColor];
    // label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];

    // //WithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 60)];

    // if(component == 0)
    // {
    //     label.text = [countryArray objectAtIndex:row];
    // }
    // else
    // {
    //     label.text = [cityArray objectAtIndex:row];
    // }
    return label;
}


/**
 * ピッカーの選択行が決まったとき
 */
// - (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//     // 1列目の選択された行数を取得
//     NSInteger val0 = [pickerView selectedRowInComponent:0];

//     // 2列目の選択された行数を取得
//     NSInteger val1 = [pickerView selectedRowInComponent:1];

//     // 3列目の選択された行数を取得
//     NSInteger val2 = [pickerView selectedRowInComponent:2];

//     NSLog(@"1列目:%d行目が選択", val0);
//     NSLog(@"2列目:%d行目が選択", val1);
//     NSLog(@"3列目:%d行目が選択", val2);
// }

//--------------------------------------------------------------//
#pragma mark-- UITextFieldDelegate--
//--------------------------------------------------------------//

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // キーボードのreturn or 改行でキーボードを閉じる
    [textField resignFirstResponder];
    return YES;
}

//--------------------------------------------------------------//
#pragma mark-- EditModalViewDelegate--
//--------------------------------------------------------------//

- (void)didPressCancelButton {
    // キャンセル時
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didPressUpdateButton {
    // 更新時
    // [_editItem iSetName:_editModalView.textField.text];
    // [_editItem iSetColorId:_colorId];
    // [self.delegate retrunActionOfEditModal:[_editItem iGetMenuId]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
