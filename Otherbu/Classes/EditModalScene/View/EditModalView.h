//
//  EditModalView.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "DataInterface.h"

@protocol EditModalDelegate

- (void)didPressCancelButton;
- (void)didPressUpdateButton;

@end

@interface EditModalView : UIView

@property(nonatomic, weak) id<EditModalDelegate> delegate;
@property(nonatomic, weak) id<DataInterface> editItem;
@property(nonatomic) UICollectionView *collectionView;;
@property(nonatomic) UITextField *textField;

- (id)initWithFrame:(CGRect)rect;
- (void)setup;

@end
