//
//  ModalViewController.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "ModalView.h"
#import "ModalInterface.h"
#import "DataInterface.h"

@interface ModalViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate,
                                                      UICollectionViewDelegateFlowLayout, UITextFieldDelegate, EditModalDelegate>

@property(nonatomic, weak) id<ModalInterface> delegate;
@property(nonatomic, weak) id<DataInterface> editItem;

@end
