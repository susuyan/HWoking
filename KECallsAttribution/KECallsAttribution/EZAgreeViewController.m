//
//  EZAgreeViewController.m
//  KECallsAttribution
//
//  Created by 赵 进喜 on 15/4/28.
//  Copyright (c) 2015年 K.BLOCK. All rights reserved.
//

#import "EZAgreeViewController.h"

@interface EZAgreeViewController ()

@end

@implementation EZAgreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    if (_isPresented) {
        [self initNav];
    }

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initNav
{
    
    
    UIButton *back=[UIButton buttonWithType:UIButtonTypeCustom];
    back.frame=CGRectMake(0, 0, 32, 32);
    
    [back addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [back setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]initWithCustomView:back];
    
    
    
    self.navigationItem.leftBarButtonItem=backItem;
    
    
}

-(void)dismiss
{
    
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
