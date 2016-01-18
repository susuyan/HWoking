//
//  EZIndexViewController.h
//  KECallsAttribution
//
//  Created by 赵 进喜 on 15/4/21.
//  Copyright (c) 2015年 K.BLOCK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VWWWaterView.h"
@interface EZIndexViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *upView;
@property (weak, nonatomic) IBOutlet UIView *moreView;
@property (weak, nonatomic) IBOutlet UIButton *cleanButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *circleImageView;

@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *deviceFreeSpaceLabel;
@property (weak, nonatomic) IBOutlet UIButton *optimizeButton;

- (IBAction)wallpaperPage:(UIButton *)sender;

@end
