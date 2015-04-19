//
//  EditModalBookmarkView.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "ModalBaseView.h"

@interface ModalBKView : ModalBaseView

@property(nonatomic) UITextField *nameTextField;
@property(nonatomic) UITextField *urlTextField;
@property(nonatomic) UIPickerView *categoryPicker;

@end
