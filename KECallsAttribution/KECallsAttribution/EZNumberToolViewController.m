//
//  EZNumberToolViewController.m
//  KECallsAttribution
//
//  Created by 赵 进喜 on 15/4/22.
//  Copyright (c) 2015年 K.BLOCK. All rights reserved.
//

#import "EZNumberToolViewController.h"

@interface EZNumberToolViewController ()

@end

@implementation EZNumberToolViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
  
    [MobClick endLogPageView:@"dianhuazhushou"];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"dianhuazhushou"];
    
    
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backButtonPressed:(UIButton *)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
}
@end