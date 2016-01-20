//
//  EZPhoneToolViewController.h
//  KECallsAttribution
//
//  Created by 赵 进喜 on 15/4/22.
//  Copyright (c) 2015年 K.BLOCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EZPhoneToolViewController : UIViewController

- (IBAction)backButtonPressed:(UIButton *)sender;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *hideView;
- (IBAction)pushToNews:(UIButton *)sender;
@end
