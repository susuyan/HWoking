//
//  EZSmsInqueryVC.h
//  KECallsAttribution
//
//  Created by 赵 进喜 on 14/11/24.
//  Copyright (c) 2014年 K.BLOCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EZSmsInqueryVC : UITableViewController
{

    NSArray *smsItems;
    
    NSArray *phoneItems;


}
@property(strong,nonatomic)NSString *carrierNum;
@property(nonatomic,strong)NSArray *mItems;
- (IBAction)backButtonPressed:(UIButton *)sender;
@end
