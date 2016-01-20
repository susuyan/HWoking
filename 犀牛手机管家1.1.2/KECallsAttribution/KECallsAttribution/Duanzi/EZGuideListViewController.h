//
//  EZGuideListViewController.h
//  GameGuide
//
//  Created by lichenWang on 13-12-9.
//  Copyright (c) 2013年 EverZones. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullTableView.h"
@interface EZGuideListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, PullTableViewDelegate>
@property (weak, nonatomic) IBOutlet PullTableView *pullTableView;
- (IBAction)back:(UIButton *)sender;
@property (nonatomic) NSInteger uRLRequestType;
@property (weak, nonatomic) IBOutlet UIView *gadView;
- (IBAction)goToDuanZi:(UITapGestureRecognizer *)sender;
@end
