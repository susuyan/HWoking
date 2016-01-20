//
//  EZProtectCheckResultVC.h
//  MyContacts
//
//  Created by 赵 进喜 on 15/1/30.
//  Copyright (c) 2015年 everzones. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface EZProtectCheckResultVC : UIViewController
{

    NSString *currentKey;
    
    NSString *currentSign;

    
    BOOL check_result;

}
@property(strong,nonatomic)NSString *inquiryPhoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *markLbl;
@property (weak, nonatomic) IBOutlet UILabel *infoLbl;
@property(strong,nonatomic)Reachability *mReach;
@property (weak, nonatomic) IBOutlet UIButton *markButton;
@property (weak, nonatomic) IBOutlet UILabel *loadingLbl;
@property (weak, nonatomic) IBOutlet UIImageView *resultImageView;


- (IBAction)markNumber:(UIButton *)sender;
- (IBAction)backButtonPressed:(UIButton *)sender;
@end
