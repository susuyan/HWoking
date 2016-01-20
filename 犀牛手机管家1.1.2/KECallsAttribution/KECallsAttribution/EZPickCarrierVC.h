//
//  EZPickCarrierVC.h
//  KECallsAttribution
//
//  Created by 赵 进喜 on 14/11/24.
//  Copyright (c) 2014年 K.BLOCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EZPickCarrierVC : UITableViewController
{

    NSArray *allInfos;

}
@property (strong, nonatomic)  UIView *gadView;
- (IBAction)buttonPressed:(UIButton *)sender;
@end
