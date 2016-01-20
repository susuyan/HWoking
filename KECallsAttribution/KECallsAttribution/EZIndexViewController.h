//
//  EZIndexViewController.h
//  KECallsAttribution
//
//  Created by 赵 进喜 on 15/4/21.
//  Copyright (c) 2015年 K.BLOCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EZIndexViewController : UIViewController



@property(copy,nonatomic)NSString *inquiryPhoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *index_top_tips;



@property (weak, nonatomic) IBOutlet UITextField *phoneTxt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top_icon_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top_icon_top;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *indexMarginTopConstraint;


@property (weak, nonatomic) IBOutlet UIImageView *index_top_icon;
@property (weak, nonatomic) IBOutlet UILabel *provinceLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@property (weak, nonatomic) IBOutlet UILabel *carrierLabel;

- (IBAction)queryNumber:(UIButton *)sender;
- (IBAction)hideKeyboard:(UITapGestureRecognizer *)sender;
@end
