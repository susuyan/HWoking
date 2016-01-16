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

{

   
    
    
   


}
@property (weak, nonatomic) IBOutlet UILabel *chargeTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lbl_fullTime;
@property (weak, nonatomic) IBOutlet UILabel *batteryLevelLbl;
@property (weak, nonatomic) IBOutlet VWWWaterView *waveView;


@property (weak, nonatomic) IBOutlet UIView *upView;

@property (weak, nonatomic) IBOutlet UIView *moreView;


@property (weak, nonatomic) IBOutlet UIButton *cleanButton;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upViewHeightConstraint;

- (IBAction)wallpaperPage:(UIButton *)sender;

@end
