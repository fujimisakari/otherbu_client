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
extern const float kVerticalOffsetOfTitle;

extern NSString * const kDefaultFont;
extern NSString * const kDefaultImageName;
extern const int kNumberOfPages;

extern const float kMarginTopOfTableFrame;
extern const float kMarginBottomOfTableFrame;
extern const float kHorizontalAdaptSizeOfTableCell;
extern const float kHorizontalOffsetOfTableCell;
extern const float kSizeOfTableFrame;
extern const float kHeightOfBorderLine;
extern const int kFontSizeOfBookmark;
extern const int kFontSizeOfUrl;

extern const float kHeightOfSectionHeader;
extern const int kFontSizeOfSectionTitle;
extern const int kVerticalOffsetOfSectionTitle;
extern const int kHorizontalOffsetOfSectionTitle;
extern NSString * const kRightArrowImageName;
extern NSString * const kDownArrowImageName;
extern const int kHorizontalOffsetOfDownArrow;
extern const int kVerticalOffsetOfDownArrow;
extern const int kHorizontalOffsetOfRightArrow;
extern const int kVerticalOffsetOfRightArrow;

extern const int kFontSizeOfPageTab;
extern const float kHeightOfPageTab;
extern const float kAdaptWidthOfPageTab;
extern const float kAdaptHeightOfPageTab;

@end
