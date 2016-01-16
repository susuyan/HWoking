//
//  EMCeSuViewController.h
//  NetMonitor
//
//  Created by dyw on 14/12/4.
//  Copyright (c) 2014年 Everzones. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMGaugeView.h"
@interface EMCeSuViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (strong, nonatomic)  WMGaugeView *gaugeView2;
@end
