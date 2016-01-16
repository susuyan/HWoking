//
//  SystemServicesDemoDiskViewController.h
//  SystemServicesDemo
//
//  Created by Kramer on 4/4/13.
//  Copyright (c) 2013 Shmoopi LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SystemServicesDemoDiskViewController : UIViewController

- (IBAction)back_home:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UILabel *lbl_space;
@property (strong, nonatomic) IBOutlet UILabel *lbl_total;
@property (strong, nonatomic) IBOutlet UILabel *lbl_used;
@property (strong, nonatomic) IBOutlet UIView *seconView;

@end
