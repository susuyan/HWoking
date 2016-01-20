//
//  EZResultTableVC.h
//  KECallsAttribution
//
//  Created by 赵 进喜 on 14/12/4.
//  Copyright (c) 2014年 K.BLOCK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECResultHeaderViewController.h"
@interface EZResultTableVC : UITableViewController
{

    ECResultHeaderViewController *resultHeader;

     NSMutableArray *mItems;

}
@property(nonatomic,strong)NSString  *myCode;
- (IBAction)buttonPressed:(UIButton *)sender;
@end
