//
//  KEStartViewController.h
//  KEMusic
//
//  Created by Kernel on 13-8-20.
//  Copyright (c) 2013年 Kernel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KEStartViewController : UIViewController
@property (strong, nonatomic)NSArray * pictureData;


- (IBAction)openApp:(UIButton *)sender;
- (IBAction)checkButtonPressed:(UIButton *)sender;
- (IBAction)openAboutUs:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *openAppButton;
@end
