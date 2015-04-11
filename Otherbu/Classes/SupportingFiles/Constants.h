//
//  Constants.h
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

@interface Constants : NSObject

typedef NS_ENUM(NSUInteger, AngleType) {
    LEFT = 1,
    CENTER,
    RIGHT,
    LastAngle,
};

typedef NS_ENUM(NSUInteger, MenuList) {
    MENU_BOOKMARK = 0,
    MENU_CATEGORY,
    MENU_PAGE,
    MENU_DESIGN,
    LastMenu,
};

extern NSString * const kTitle;
extern const int kFontSizeOfTitle;
extern const float kOffsetYOfTitle;

extern NSString * const kDefaultFont;
extern NSString * const kDefaultImageName;
extern NSString * const kCellIdentifier;
extern const int kNumberOfPages;

extern NSString * const kTextFieldColorOfEditModal;
extern NSString * const kBorderColorOfInEditModal;

extern const float kMarginTopOfTableFrame;
extern const float kMarginBottomOfTableFrame;
extern const float kAdaptWidthOfTableCell;
extern const float kOffsetXOfTableCell;
extern const float kSizeOfTableFrame;
extern const float kHeightOfBorderLine;
extern const int kFontSizeOfBookmark;
extern const int kFontSizeOfUrl;

extern const float kHeightOfSectionHeader;
extern const int kFontSizeOfSectionTitle;
extern const int kOffsetXOfSectionTitle;
extern const int kOffsetYOfSectionTitle;
extern NSString * const kRightArrowImageName;
extern NSString * const kDownArrowImageName;
extern const int kOffsetXOfDownArrow;
extern const int kOffsetYOfDownArrow;
extern const int kOffsetXOfRightArrow;
extern const int kOffsetYOfRightArrow;

extern const int kFontSizeOfPageTab;
extern const int kOffsetYOfPageTab;
extern const float kHeightOfPageTab;
extern const float kAdaptWidthOfPageTab;
extern const float kAdaptHeightOfPageTab;

extern const float kHeightOfToolbar;
extern const float kLabelWidthOfToolbar;
extern const float kArrowWidthOfToolbar;
extern const int kFontSizeOfToolbar;

extern const float kBorderWidthOfEditModal;
extern const float kAdaptWidthOfEditModal;
extern const float kAdaptHeightOfEditModal;
extern const float kButtonWidthOfEditModal;
extern const float kLabelWidthOfEditModal;
extern const float kAdaptButtonWidthOfEditModal;
extern const float kAdaptButtonHeightOfEditModal;
extern const float kCommonAdaptWidthOfEditModal;
extern const float kCommonHeightOfEditModal;
extern const int kTitleFontSizeOfEditModal;
extern const int kLabelFontSizeOfEditModal;
extern NSString * const kCancelButtonOfEditModal;
extern NSString * const kUpdateButtonOfEditModal;

extern const int kRowOfColorPalette;
extern const int kColumnOfColorPalette;
extern const float kViewHeightOfColorPalette;
extern const float kCellSizeOfColorPalette;
extern const float kCellMarginOfColorPalette;
extern const float kBorderWidthOfColorPalette;

extern const int kCellMarginOfSetting;
extern const int kCellItemMarginOfSetting;
extern const float kCellHeightOfSetting;

extern NSString * const kMenuBookmarkName;
extern NSString * const kMenuBookmarkMoveName;
extern NSString * const kMenuCategoryName;
extern NSString * const kMenuPageName;
extern NSString * const kMenuDesignName;

extern NSString * const kSettingIcon;
extern NSString * const kBookmarkIcon;
extern NSString * const kBookmarkMoveIcon;
extern NSString * const kCategoryIcon;
extern NSString * const kPageIcon;
extern NSString * const kDesignIcon;
extern NSString * const kRighttArrowIcon;
extern NSString * const kCheckMarkIcon;

extern NSString * const kToWebViewBySegue;
extern NSString * const kToEditViewBySegue;
extern NSString * const kToSettingBySegue;
extern NSString * const kToCategoryListBySegue;
extern NSString * const kToCategoryOfBookmarkBySegue;
extern NSString * const kToBookmarkListBySegue;
extern NSString * const kToPageListBySegue;
extern NSString * const kToEditPageBySegue;

@end