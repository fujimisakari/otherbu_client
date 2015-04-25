//
//  ModalInterface.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

@protocol ModalInterface <NSObject>

@optional

- (void)returnActionOfModal:(NSInteger)menuId;
- (void)closeModalView;

@end
