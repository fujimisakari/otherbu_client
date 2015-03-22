//
//  Constants.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "Constants.h"

@implementation Constants

//--------------------------------------------------------------//
#pragma mark -- Title Value --
//--------------------------------------------------------------//

NSString * const kTitle = @"Otherbu";                        // タイトル名
const int kFontSizeOfTitle = 18;                             // タイトル名のフォントサイズ
const float kOffsetYOfTitle = -2;                            // タイトル名の縦位置調整

//--------------------------------------------------------------//
#pragma mark -- Default Value --
//--------------------------------------------------------------//

NSString * const kDefaultFont = @"Helvetica";                // デフォルトフォント名
NSString * const kDefaultImageName = @"wood-wallpeper.jpg";  // デフォルト背景
const int kNumberOfPages = 3;                                // ページ数

//--------------------------------------------------------------//
#pragma mark -- Table Value --
//--------------------------------------------------------------//

const float kMarginTopOfTableFrame = 20.0f;                  // テーブルの上部に余白
const float kMarginBottomOfTableFrame = 30.0f;               // テーブルの下部に余白
const float kAdaptWidthOfTableCell = 20.0f;                  // セルのサイズ調整
const float kOffsetXOfTableCell = 10.0f;                     // セルのx位置調整
const float kSizeOfTableFrame = 5.0f;                        // テーブルフレームのサイズ
const float kHeightOfBorderLine = 0.5f;                      // セルの区切り線の高さ
const int kFontSizeOfBookmark = 16;                          // ブックマーク名のフォントサイズ
const int kFontSizeOfUrl = 12;                               // URLのフォントサイズ

//--------------------------------------------------------------//
#pragma mark -- Table Section Value --
//--------------------------------------------------------------//

const float kHeightOfSectionHeader = 40.0f;                  // セクションヘッダーの高さ
const int kFontSizeOfSectionTitle = 18;                      // セクションタイトル名のフォントサイズ
const int kOffsetXOfSectionTitle = 50;                       // セクションタイトル名のX位置調整
const int kOffsetYOfSectionTitle = 9;                        // セクションタイトル名のY位置調整
NSString * const kDownArrowImageName = @"downArrow";         // 開閉画像名(↓)
NSString * const kRightArrowImageName = @"rightArrow";       // 開閉画像名(→)
const int kOffsetXOfDownArrow = 20;                          // 開閉画像名(↓)のX位置調整
const int kOffsetYOfDownArrow = 15;                          // 開閉画像名(↓)のY位置調整
const int kOffsetXOfRightArrow = 25;                         // 開閉画像(→)のX位置調整
const int kOffsetYOfRightArrow = 12;                         // 開閉画像(→)のY位置調整

//--------------------------------------------------------------//
#pragma mark -- PageTab Value --
//--------------------------------------------------------------//

const int kFontSizeOfPageTab = 16;                           // PageTabのフォントサイズ
const int kOffsetYOfPageTab = 3;                             // PageTabのY位置調整
const float kHeightOfPageTab = 37.0f;                        // PageTabの高さ
const float kAdaptWidthOfPageTab = 30.0f;                    // PageTabのサイズ調整(width)
const float kAdaptHeightOfPageTab = 5.0f;                    // PageTabのサイズ調整(height)

//--------------------------------------------------------------//
#pragma mark -- Toolbar Value --
//--------------------------------------------------------------//

const float kHeightOfToolbar = 44.0f;                        // Toolbarの高さ
const float kLabelWidthOfToolbar = 50.0f;                    // Toolbarのラベル幅
const float kArrowWidthOfToolbar = 50.0f;                    // Toolbarの矢印の幅
const int kFontSizeOfToolbar = 30;                           // Toolbarのフォントサイズ

@end
