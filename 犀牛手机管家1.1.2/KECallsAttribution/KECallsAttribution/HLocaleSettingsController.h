//
//  HLocaleSettingsController.h
//  Harassment
//
//  Created by EverZones on 15/11/9.
//  Copyright (c) 2015年 EverZones. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioButton.h"
@interface HLocaleSettingsController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *localeLabel;
@property (weak, nonatomic) IBOutlet UITextField *queryTextField;

@property (weak, nonatomic) IBOutlet RadioButton *localeButton;


@end
