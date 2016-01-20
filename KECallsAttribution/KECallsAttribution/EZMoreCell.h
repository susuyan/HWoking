//
//  EZMoreCell.h
//  ContactBackup
//
//  Created by 赵 进喜 on 15/3/19.
//  Copyright (c) 2015年 everzones. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZSquareImage.h"

@interface EZMoreCell : UITableViewCell
@property (weak, nonatomic) IBOutlet EZSquareImage *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end
