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

extern NSString * const kTitle;
extern const int kFontSizeOfTitle;
extern const float kOffsetYOfTitle;

extern NSString * const kDefaultFont;
extern NSString * const kDefaultImageName;
extern const int kNumberOfPages;

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

@end
