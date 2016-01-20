//
//  EZMergeViewController.h
//  ContactBackup
//
//  Created by 赵 进喜 on 15/3/19.
//  Copyright (c) 2015年 everzones. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EZMergeViewController : UITableViewController
@property(nonatomic,strong)NSMutableDictionary *allDic;
- (IBAction)autoMerge:(UIButton *)sender;
@end
