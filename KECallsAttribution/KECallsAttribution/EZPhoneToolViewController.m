//
//  EZPhoneToolViewController.m
//  KECallsAttribution
//
//  Created by 赵 进喜 on 15/4/22.
//  Copyright (c) 2015年 K.BLOCK. All rights reserved.
//

#import "EZPhoneToolViewController.h"
#import "EZNewsViewController.h"
@interface EZPhoneToolViewController ()

@end

@implementation EZPhoneToolViewController
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
    
    [MobClick endLogPageView:@"shoujiguanjia"];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"shoujiguanjia"];
    
    
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    BOOL isPassed = [[NSUserDefaults standardUserDefaults] boolForKey:@"isPassed"];
    
    if (!isPassed) {
        
        
        
        for (UIButton *button in self.hideView) {
            button.hidden=YES;
        }
        
        
       
        
        
    }else
    {
        
        
        
    }

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
- (IBAction)pushToNews:(UIButton *)sender {
    
    
    
    
    
    
    
    
    EZNewsViewController *news=[self.storyboard instantiateViewControllerWithIdentifier:@"EZNewsViewController"];
    
    news.currentType = EZNewsVCTypeFromClick;
    
    
    
    switch (sender.tag) {
        case 5:
            news.pageCat=@"tianqi";
            news.currentUrl=@"http://m.weather.com.cn/mweather/101010100.shtml";
            
            news.navigationItem.title=@"天气";

            
            break;
        case 6:
            news.pageCat=@"xiaoshuo";
            news.currentUrl=@"http://m.shenmaxiaoshuo.com/";
            
            news.navigationItem.title=@"小说";

            break;

        case 7:
            news.pageCat=@"qiubai";
            news.currentUrl=@"http://m.qiushibaike.com/";
            
            news.navigationItem.title=@"糗事百科";

            break;

        case 8:
            news.pageCat=@"toutiao";
            news.currentUrl=@"http://m.toutiao.com/";
            
            news.navigationItem.title=@"今日头条";

            break;

        case 9:
            news.pageCat=@"xiaomiexinging";
            news.currentUrl=@"http://g.wanh5.com/wx/star_pops/";
            
            news.navigationItem.title=@"消灭星星";

            break;

            
        default:
            break;
    }
    
    
    
    
    
    
    [self.navigationController pushViewController:news animated:YES];
    
}
@end
