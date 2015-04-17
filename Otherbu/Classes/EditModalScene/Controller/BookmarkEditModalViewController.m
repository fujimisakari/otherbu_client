//
//  BookmarkEditModalViewController.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "BookmarkEditModalViewController.h"
#import "EditModalBookmarkView.h"

@interface BookmarkEditModalViewController () {
    EditModalBookmarkView *_editModalView;
}

@end

@implementation BookmarkEditModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];

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
}

- (UIModalPresentationStyle)modalPresentationStyle {
    // modalView以外の背景が黒になってしまう問題の対応
    return UIModalPresentationOverCurrentContext;
}

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
