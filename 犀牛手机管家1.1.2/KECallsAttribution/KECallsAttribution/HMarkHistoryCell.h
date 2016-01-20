//
//  HMarkHistoryCell.h
//  Harassment
//
//  Created by EverZones on 15/11/18.
//  Copyright (c) 2015年 EverZones. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMarkHistoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *markTypeLabel;

- (void)setupCellWith:(NSString *)phoneNumber markType:(NSString *)markType;
@end
