//
//  EditModalView.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

@protocol EditModalDelegate

- (void)didPressCancelButton;
- (void)didPressUpdateButton;

@end

@interface EditModalView : UIView

@property(nonatomic, weak) id<EditModalDelegate> delegate;

+ (id)initWithFrame:(CGRect)rect;

- (void)setup;

@end
