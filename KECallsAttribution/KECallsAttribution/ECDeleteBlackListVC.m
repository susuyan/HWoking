//
//  ECDeleteBlackListVC.m
//  KECallsAttribution
//
//  Created by 赵 进喜 on 14-10-11.
//  Copyright (c) 2014年 K.BLOCK. All rights reserved.
//

#import "ECDeleteBlackListVC.h"

@interface ECDeleteBlackListVC ()

@end

@implementation ECDeleteBlackListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, 600);
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
    [self.navigationController popViewControllerAnimated:YES];
}
@end
