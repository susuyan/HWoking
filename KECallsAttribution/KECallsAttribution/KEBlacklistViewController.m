//
//  KEBlacklistViewController.m
//  KECallsAttribution
//
//  Created by lichenWang on 14-1-18.
//  Copyright (c) 2014年 KERNEL. All rights reserved.
//

#import "KEBlacklistViewController.h"

@interface KEBlacklistViewController ()
@end

@implementation KEBlacklistViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.scrollView.contentSize = CGSizeMake(320,800);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
