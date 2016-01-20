//
//  EZGuideCell.h
//  GameGuide
//
//  Created by lichenWang on 13-12-9.
//  Copyright (c) 2013年 EverZones. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZGuide.h"
@interface EZGuideCell : UITableViewCell
@property (strong, nonatomic)EZGuide * guide;
@property (weak, nonatomic) IBOutlet UIImageView *headPortrait;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *dateInformation;
@property (weak, nonatomic) IBOutlet UILabel *content;
+ (CGFloat) heightForMessage:(EZGuide *)guide;
@property (weak, nonatomic) IBOutlet UIImageView *contentBackground;
@end
