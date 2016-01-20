//
//  EZProtectVC.h
//  MyContacts
//
//  Created by 赵 进喜 on 15/1/29.
//  Copyright (c) 2015年 everzones. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lunbo.h"
@interface EZProtectVC : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *numberText;
@property(strong,nonatomic)NSString *inquiryPhoneNumber;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UIImageView *top_icon;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property(copy,nonatomic)NSString *databaseFilePath;
@property(copy,nonatomic)NSString *query;
@property (weak, nonatomic) IBOutlet UILabel *provinceLbl;
@property (weak, nonatomic) IBOutlet UILabel *carrierLbl;

@property (nonatomic,strong )UIButton *disBtn;
@property (nonatomic,strong)    Lunbo *lunbo;

- (IBAction)hideKeyboard:(UITapGestureRecognizer *)sender;

- (IBAction)checkNumber:(UIButton *)sender;
- (IBAction)backButtonPressed:(UIButton *)sender;
#pragma mark - 

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end
