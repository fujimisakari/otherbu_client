//
//  EditModalViewController.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "EditModalViewController.h"
#import "EditModalView.h"

@interface EditModalViewController () {
    EditModalView *_editModalView;
}

@end

@implementation EditModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _editModalView = [EditModalView initWithFrame:(CGRect)self.view.frame];
    _editModalView.editItem = _editItem;
    _editModalView.delegate = self;
    [self.view addSubview:_editModalView];
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
#pragma mark -- EditModalViewDelegate --
//--------------------------------------------------------------//

- (void)didPressCancelButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didPressUpdateButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
