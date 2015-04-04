//
//  EditModalViewController.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "EditModalView.h"
#import "DataInterface.h"

@interface EditModalViewController : UIViewController<EditModalDelegate>

@property(nonatomic, weak) id<DataInterface> editItem;

- (void)setEditItem:(id<DataInterface>)editItem;

@end
