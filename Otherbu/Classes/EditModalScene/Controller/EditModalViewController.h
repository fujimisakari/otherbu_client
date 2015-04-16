//
//  EditModalViewController.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "EditModalView.h"
#import "EditModalInterface.h"
#import "DataInterface.h"

@interface EditModalViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate,
                                                      UICollectionViewDelegateFlowLayout, UITextFieldDelegate, EditModalDelegate>

@property(nonatomic, weak) id<EditModalInterface> delegate;
@property(nonatomic, weak) id<DataInterface> editItem;

@end
