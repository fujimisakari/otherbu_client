//
//  BookmarkEditModalViewController.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "EditModalView.h"
#import "DataInterface.h"
#import "EditModalInterface.h"

@interface BookmarkEditModalViewController : UIViewController<UITextFieldDelegate, EditModalDelegate>

@property(nonatomic, weak) id<EditModalInterface> delegate;
@property(nonatomic, weak) id<DataInterface> editItem;

@end
