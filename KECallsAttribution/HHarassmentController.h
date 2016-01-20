//
//  HHarassmentController.h
//  KECallsAttribution
//
//  Created by EverZones on 15/12/4.
//  Copyright © 2015年 K.BLOCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHarassmentController : UIViewController

@property(copy,nonatomic)NSString *inquiryPhoneNumber;


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *index_top_tips;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *indexMarginTopConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *index_top_icon;



@end
