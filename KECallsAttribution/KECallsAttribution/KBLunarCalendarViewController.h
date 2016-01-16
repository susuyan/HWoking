//
//  KBLunarCalendarViewController.h
//  KECallsAttribution
//
//  Created by lichenWang on 14-4-3.
//  Copyright (c) 2014年 K.BLOCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KBLunarCalendarViewController : UITableViewController<UIActionSheetDelegate>
- (IBAction)back:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *yearAndMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *lunarCalendarLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UILabel *yiLabel;
@property (weak, nonatomic) IBOutlet UILabel *jiLabel;
@property (weak, nonatomic) IBOutlet UILabel *shaLabel;
@property (weak, nonatomic) IBOutlet UILabel *chengLabel;
@property (weak, nonatomic) IBOutlet UILabel *jingriLabel;
@property (weak, nonatomic) IBOutlet UILabel *chongLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhengchongLabel;
@property (weak, nonatomic) IBOutlet UILabel *jieqiLabel;
@property(copy,nonatomic) NSString *strPath;
- (IBAction)showDatePicker:(UIButton *)sender;
@end
