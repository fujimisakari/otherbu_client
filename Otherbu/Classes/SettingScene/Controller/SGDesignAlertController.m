//
//  SGDesignAlertController.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "SGDesignAlertController.h"
#import "SGDesignTableViewController.h"
#import "DesignData.h"

@interface SGDesignAlertController () {
    UIViewController *_clientViewController;
}

@end

@implementation SGDesignAlertController

- (void)setup:(UIViewController *)clientViewController {
    _clientViewController = clientViewController;

    // アクションの処理をBlockで定義しておく
    NSMutableDictionary *actionDict = [[NSMutableDictionary alloc] init];
    actionDict[@"chenge"] = ^(UIAlertAction * action) {
        // モーダルビューとして写真選択画面を呼び出す
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = sourceType;
            [_clientViewController presentModalViewController:picker animated:YES];
        }
    };
    actionDict[@"default"] = ^(UIAlertAction * action) {
        // デフォルトの背景画像に戻す場合
        [[DesignData shared] updatetBackgroundPicture:kDefaultImageName];
        SGDesignTableViewController *clientViewController = (SGDesignTableViewController *)_clientViewController;
        [clientViewController updateBackgroundView];
    };

    // アクションシートの項目設定
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *chengeAction =
        [UIAlertAction actionWithTitle:@"画像から選ぶ" style:UIAlertActionStyleDefault handler:actionDict[@"chenge"]];
    UIAlertAction *defaultAction =
        [UIAlertAction actionWithTitle:@"デフォルトにする" style:UIAlertActionStyleDefault handler:actionDict[@"default"]];
    [self addAction:cancelAction];
    [self addAction:chengeAction];
    [self addAction:defaultAction];
}

//--------------------------------------------------------------//
#pragma mark -- UIImagePickerControllerDelegate --
//--------------------------------------------------------------//

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // 画像が選択された場合
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *data = UIImageJPEGRepresentation(image, 0.8f);
    NSString *path =
        [NSString stringWithFormat:@"%@/%@", [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"], kCustomImageName];
    // atomically=YESの場合、同名のファイルがあったら、まずは別名で作成して、その後、ファイルの上書きを行います
    if ([data writeToFile:path atomically:YES]) {
        [[DesignData shared] updatetBackgroundPicture:path];
        LOG(@"save OK");
        LOG(@"save file: %@", [DesignData shared].backgroundPicture);
    } else {
        LOG(@"save NG");
    }

    // アプリを抜けるとステータスバーの文字が黒に戻るので再度白にする
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [_clientViewController dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    // 画像の選択がキャンセルされた場合
    [_clientViewController dismissModalViewControllerAnimated:YES];
}

@end
