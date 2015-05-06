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

NSString * const kTitle = @"OtherBu";                        // タイトル名
const int kFontSizeOfTitle = 18;                             // タイトル名のフォントサイズ
const float kOffsetYOfTitle = -2;                            // タイトル名の縦位置調整

//--------------------------------------------------------------//
#pragma mark -- Default Value --
//--------------------------------------------------------------//

NSString * const kAppVersion = @"1.0.0";                       // アプリのバージョン
NSString * const kDefaultFont = @"Helvetica";                  // デフォルトフォント名
NSString * const kDefaultImageName = @"default-wallpeper.jpg"; // デフォルト背景画像名
NSString * const kCustomImageName = @"user-wallpaper.jpg";     // ユーザーのカスタム背景画像名
NSString * const kCellIdentifier = @"Cell";                    // セルの識別子
NSString * const kDefaultPageDataId = @"AllCategory";          // デフォルトのPageの識別子
NSString * const kDefaultSearchDataId = @"1";                  // デフォルトの検索サイト
const int kNumberOfPages = 3;                                  // ページ数
const float kCellAlpha = 0.85f;                                // セルの透明度

// データ保存時のファイル名
NSString * const kSaveFileNameList[] = {
    [SAVE_USER] = @"User",
    [SAVE_DESIGN] = @"Design",
    [SAVE_BOOKMARK] = @"Bookmark",
    [SAVE_CATEGORY] = @"Category",
    [SAVE_PAGE] = @"Page",
    [SAVE_SYNC] = @"Sync"
};

//--------------------------------------------------------------//
#pragma mark -- Color Hex --
//--------------------------------------------------------------//

NSString * const kTextFieldColorOfModal = @"555555";         // Modalのテキトフィールドの背景色
NSString * const kBorderColorOfModal = @"555555";            // ModalのViewの枠線

//--------------------------------------------------------------//
#pragma mark -- Table Value Of Main View--
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
#pragma mark -- Table Section Value Of Main View --
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
#pragma mark -- PageTab Value Of Main View --
//--------------------------------------------------------------//

const int kFontSizeOfPageTab = 16;                           // PageTabのフォントサイズ
const int kOffsetYOfPageTab = 3;                             // PageTabのY位置調整
const float kHeightOfPageTab = 37.0f;                        // PageTabの高さ
const float kAdaptWidthOfPageTab = 30.0f;                    // PageTabのサイズ調整(width)
const float kAdaptHeightOfPageTab = 5.0f;                    // PageTabのサイズ調整(height)

//--------------------------------------------------------------//
#pragma mark -- Toolbar Value Of Main View --
//--------------------------------------------------------------//

const float kHeightOfToolbar = 44.0f;                        // Toolbarの高さ
const float kLabelWidthOfToolbar = 50.0f;                    // Toolbarのラベル幅
const float kArrowWidthOfToolbar = 50.0f;                    // Toolbarの矢印の幅
const int kFontSizeOfToolbar = 30;                           // Toolbarのフォントサイズ

//--------------------------------------------------------------//
#pragma mark -- Value Of Modal View --
//--------------------------------------------------------------//

const float kBorderWidthOfModal = 2.0f;                      // Modalの画面の枠線
const float kAdaptWidthOfModal = 20.0f;                      // Modalの画面サイズ調整(width)
const float kAdaptHeightOfModal = 50.0f;                     // Modalの画面サイズ調整(height)
const float kAdaptHeightOfModalForip6 = 100.0f;              // Modalの画面サイズ調整(height)
const float kButtonWidthOfModal = 100.0f;                    // Modalのボタンサイズ(width)
const float kLabelWidthOfModal = 150.0f;                     // Modalのラベルサイズ(width)
const float kAdaptButtonWidthOfModal = 20.0f;                // Modalのボタン位置調整(width)
const float kAdaptButtonHeightOfModal = 20.0f;               // Modalのボタン位置調整(height)
const float kCommonAdaptWidthOfModal = 20.0f;                // Modalのボタンやラベルの位置調整(width)
const float kCommonHeightOfModal = 30.0f;                    // Modalのボタンやラベルのサイズ(height)
const int kTitleFontSizeOfModal = 20;                        // Modalのタイトルラベルのフォントサイズ
const int kLabelFontSizeOfModal = 15;                        // Modalの項目ラベルのフォントサイズ
NSString * const kCancelButtonOfModal = @"Cancel";
NSString * const kCreateButtonOfModal = @"Create";
NSString * const kUpdateButtonOfModal = @"Update";

//--------------------------------------------------------------//
#pragma mark -- Color Palette --
//--------------------------------------------------------------//

const int kRowOfColorPalette = 3;                            // カラーパレットの行数
const int kColumnOfColorPalette = 6;                         // カラーパレットの列数
const float kViewHeightOfColorPalette = 140.0f;              // カラーパレットの高さ
const float kCellSizeOfColorPalette = 35.0f;                 // カラーパレットのセルサイズ
const float kCellMarginOfColorPalette = 5.0f;                // カラーパレットのセル同士の余白
const float kBorderWidthOfColorPalette = 2.0f;               // カラーパレットのセル枠線

//--------------------------------------------------------------//
#pragma mark -- Value Of Setting View --
//--------------------------------------------------------------//

const int kCellMarginOfSetting = 10;                         // Setting画面のCellの余白
const int kCellItemMarginOfSetting = 5;                      // Setting画面のCell内のItemの余白
const float kCellHeightOfSetting = 50.0f;                    // Setting画面のCellの高さ
const int kFontSizeOfSettingDesc = 14;                       // Setting画面の説明ViewのFontサイズ
const int kMarginOfSettingDesc = 20;                         // Setting画面の説明Viewの余白
const int kHeightOfSettingDesc = 30;                         // Setting画面の説明Viewの高さ
const float kCellHeightOfSGColorPalette = 210.0f;            // Setting画面のカラーパレット用のCellの高さ
const int kCellMarginOfSGColorPalette = 140;                 // Setting画面のカラーパレット用のCellの余白

//--------------------------------------------------------------//
#pragma mark -- Menu Of Setting View --
//--------------------------------------------------------------//

NSString * const kMenuSectionName1 = @"各種設定";
NSString * const kMenuSectionName2 = @"Webと連携";
NSString * const kMenuSectionName3 = @"このアプリについて";

NSString * const kMenuBookmarkName = @"Bookmark";
NSString * const kMenuCategoryName = @"Category";
NSString * const kMenuPageName = @"Page";
NSString * const kMenuDesignName = @"Design";
NSString * const kMenuSearchName = @"検索サイト";
NSString * const kMenuSyncName = @"同期";
NSString * const kMenuSigninName = @"サインイン";
NSString * const kMenuSignOutName = @"サインアウト";
NSString * const kMenuHelpName = @"ヘルプ";
NSString * const kMenuReviewName = @"レビューを書く";
NSString * const kMenuWebSiteName = @"アプリのWebサイト";
NSString * const kMenuVersionName = @"バージョン";

//--------------------------------------------------------------//
#pragma mark -- IconName --
//--------------------------------------------------------------//

NSString * const kSettingIcon = @"settingIcon.png";
NSString * const kSwapIcon = @"swapIcon.png";
NSString * const kSearchIcon = @"searchIcon.png";
NSString * const kMoveListIcon = @"moveListIcon.png";
NSString * const kBookmarkIcon = @"bookmarkIcon.png";
NSString * const kCategoryIcon = @"categoryIcon.png";
NSString * const kPageIcon = @"pageIcon.png";
NSString * const kDesignIcon = @"designIcon.png";
NSString * const kSignInIcon = @"signInIcon.png";
NSString * const kSignOutIcon = @"signOutIcon.png";
NSString * const kBlackSearchIcon = @"blackSearchIcon.png";
NSString * const kSyncIcon = @"syncIcon.png";
NSString * const kHelpIcon = @"helpIcon.png";
NSString * const kWebSiteIcon = @"webSiteIcon.png";
NSString * const kReviewIcon = @"reviewIcon.png";
NSString * const kVersionIcon = @"versionIcon.png";
NSString * const kRighttArrowIcon = @"righttArrowIcon.png";
NSString * const kCheckMarkIcon = @"checkMarkIcon.png";

//--------------------------------------------------------------//
#pragma mark -- segue --
//--------------------------------------------------------------//

NSString * const kToWebViewBySegue = @"toWebView";                            // WebViewページへ
NSString * const kToSwapViewBySegue = @"toSwapView";                          // Swapページへ
NSString * const kToModalViewBySegue = @"toModalView";                        // 編集Modalへ
NSString * const kToModalBKViewBySegue = @"toModalBKView";                    // ブックマーク編集Modalへ
NSString * const kToModalPageViewBySegue = @"toModalPageView";                // ページ編集Modalへ
NSString * const kToSettingBySegue = @"toSetting";                            // 設定ページへ
NSString * const kToCategoryListBySegue = @"toCateogoryList";                 // 設定ページ → カテゴリへ
NSString * const kToCategoryOfBookmarkBySegue = @"toCategoryListOfBookmark";  // 設定ページ → ブックマークのカテゴリ選択へ
NSString * const kToBookmarkListBySegue = @"toBookmarkList";                  // 設定ページ → ブックマークのカテゴリ選択へ → ブックマーク一覧
NSString * const kToPageListBySegue = @"toPageList";                          // 設定ページ → ページ一覧へ
NSString * const kToEditPageBySegue = @"toEditPage";                          // 設定ページ → ページ一覧 → ページ設定
NSString * const kToDesignBySegue = @"toDesignPage";                          // 設定ページ → デザイン設定
NSString * const kToSearchBySegue = @"toSearchPage";                          // 設定ページ → 検索サイト設定

@end
