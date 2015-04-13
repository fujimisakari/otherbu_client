//
//  EditModalViewController.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "EditModalView.h"
#import "DataInterface.h"

@protocol EditModalViewDelegate

- (void)retrunActionOfEditModal:(NSInteger)menuId;

@end

@interface EditModalViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate,
                                                      UICollectionViewDelegateFlowLayout, UITextFieldDelegate, EditModalDelegate>

@property(nonatomic, weak) id<EditModalViewDelegate> delegate;
@property(nonatomic, weak) id<DataInterface> editItem;

@end
