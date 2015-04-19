//
//  EditModalBaseView.h
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

@interface ModalBaseView : UIView

@property(nonatomic, weak) id<EditModalDelegate> delegate;
@property(nonatomic, weak) id<DataInterface> editItem;

- (id)initWithFrame:(CGRect)rect;
- (void)setup;

- (void)setTitleLabel:(CGRect)rect;
- (void)setFieldLabel:(CGRect)rect label:(NSString *)labelName;
- (void)setTextField:(CGRect)rect TextField:(UITextField *)textField Text:(NSString *)text;
- (void)setButton:(CGRect)rect label:(NSString *)title action:(SEL)action;

@end
