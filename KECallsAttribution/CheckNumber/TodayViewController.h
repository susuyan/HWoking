//
//  TodayViewController.h
//  CheckNumber
//
//  Created by 赵 进喜 on 15/7/7.
//  Copyright (c) 2015年 K.BLOCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *tipsLbl;

@property (weak, nonatomic) IBOutlet UILabel *loadingLbl;
@property (weak, nonatomic) IBOutlet UIView *showResultView;
@property (weak, nonatomic) IBOutlet UILabel *markLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressAndCarrierLbl;
@property (weak, nonatomic) IBOutlet UILabel *numberLbl;
- (IBAction)quitCkeck:(UIButton *)sender;
- (IBAction)dailNumber:(UIButton *)sender;

- (IBAction)goToHost:(UITapGestureRecognizer *)sender;
@end
