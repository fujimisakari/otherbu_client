//
//  MyViewController.h
//  Otherbu
//
//  Created by fujimisakari on 2015/02/17.
//  Copyright (c) 2015年 fujimisakari. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyViewController : UIViewController {
   @private
    NSInteger number_;
}

@property (nonatomic, assign) NSInteger number;

+ (MyViewController *)myViewControllerWithNumber:(NSInteger)number;

@end
