//
//  ModalBKViewController.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "ModalView.h"
#import "DataInterface.h"
#import "ModalInterface.h"

@interface ModalBKViewController
    : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, EditModalDelegate>

@property(nonatomic, weak) id<ModalInterface> delegate;
@property(nonatomic, weak) id<DataInterface> editItem;

@end
