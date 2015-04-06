//
//  SettingTableViewCell.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "SettingTableViewCell.h"

@implementation SettingTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(self.textLabel.frame.origin.x, 5, self.textLabel.frame.size.width, self.textLabel.frame.size.height);
    self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y + 5, self.imageView.frame.size.width, self.imageView.frame.size.height);
}

@end
