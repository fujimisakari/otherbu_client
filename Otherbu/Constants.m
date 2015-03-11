//
//  Constants.m
//  Otherbu
//
//  Created by fujimisakari on 2015/03/11.
//  Copyright (c) 2015年 fujimisakari. All rights reserved.
//

#import "Constants.h"

@implementation Constants

#pragma mark - Title Value
NSString * const kTitle = @"Otherbu";                        // タイトル名
const int kFontSizeOfTitle = 18;                             // タイトルフォントのサイズ
const float kVerticalOffsetOfTitle = -7;                     // タイトル名の縦位置調整

#pragma mark - Default Value
NSString * const kDefaultFont = @"Futura-Medium";            // デフォルトフォント名
NSString * const kDefaultImageName = @"wood-wallpeper.jpg";  // デフォルト背景
const int kNumberOfPages = 3;                                // ページ数
const float kHeightOfSectionHeader = 40.0f;                  // セクションヘッダーの高さ

#pragma mark - Table Value
const float kHorizontalAdaptSizeOfTableCell = 20;            // セルのサイズ調整
const float kHorizontalAdaptPositionOfTableCell = 10;        // セルのx位置調整
const float kSizeOfTableFrame = 5;                           // テーブルフレームのサイズ
const float kHeightOfBorderLine = 0.5f;                      // セルの区切り線の高さ
const int kFontSizeOfBookmark = 16;                             // タイトルフォントのサイズ
const int kFontSizeOfUrl = 12;                             // タイトルフォントのサイズ
@end
