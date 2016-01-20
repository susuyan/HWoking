//
//  KEContactCell.h
//  KECallsAttribution
//
//  Created by lichenWang on 14-1-6.
//  Copyright (c) 2014年 KERNEL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KECoreDataContact.h"
#import "CircleImage.h"
@interface KEContactCell : UITableViewCell
@property (strong, nonatomic)KECoreDataContact * contact;
@property (weak, nonatomic) IBOutlet CircleImage *headPortrait;
@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNmberAreaNameLabel;
@end
