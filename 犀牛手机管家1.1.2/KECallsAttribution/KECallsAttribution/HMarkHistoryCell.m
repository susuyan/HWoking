//
//  HMarkHistoryCell.m
//  Harassment
//
//  Created by EverZones on 15/11/18.
//  Copyright (c) 2015年 EverZones. All rights reserved.
//

#import "HMarkHistoryCell.h"

@implementation HMarkHistoryCell

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Public
- (void)setupCellWith:(NSString *)phoneNumber markType:(NSString *)markType {
    self.phoneNumberLabel.text = phoneNumber;
    self.markTypeLabel.text = markType;
}
@end
