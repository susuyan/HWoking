//
//  KEAboutUsViewController.h
//  KECallsAttribution
//
//  Created by lichenWang on 14-1-6.
//  Copyright (c) 2014年 KERNEL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KEAboutUsViewController : UITableViewController<UIGestureRecognizerDelegate>
{

    UISwitch *pushSwitch;
    
    UISwitch *NotificationSet;
    
    NSArray *urlArray;

}
- (IBAction)back:(UIButton *)sender;
//@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *pushCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *NotificationCell;

@end
