//
//  KEWelcomeViewController.m
//  KEMusic
//
//  Created by Kernel on 13-8-28.
//  Copyright (c) 2013年 Kernel. All rights reserved.
//

#import "KEWelcomeViewController.h"
#import "KEStartViewController.h"

#import "EZIndexViewController.h"
@interface KEWelcomeViewController ()

@end

@implementation KEWelcomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    
     NSString *lastVersion=[[NSUserDefaults standardUserDefaults]objectForKey:@"lastVersion"];
    
    //新用户安装，或者老用户升级
    if (lastVersion==nil||[lastVersion floatValue]<[VERSION floatValue]) {
        
        [[NSUserDefaults standardUserDefaults]setObject:VERSION forKey:@"lastVersion"];
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        KEStartViewController * StartViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StartViewController"];
        
                
        
      // [self presentViewController:StartViewController animated:NO completion:nil];

        
       
        
        [self performSelector:@selector(showMainVC:) withObject:StartViewController afterDelay:2];
        
        
    }else
    {
    
        EZIndexViewController * mainViewController =[self.storyboard instantiateViewControllerWithIdentifier:@"EZIndexViewController"];
        UINavigationController * navigation = [[UINavigationController alloc] initWithRootViewController:mainViewController];
        mainViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
       // [self presentViewController:navigation animated:NO completion:nil];
    
         [self performSelector:@selector(showMainVC:) withObject:navigation afterDelay:2];
    }
    
    
    
    
    




}


-(void)showMainVC:(UIViewController *)viewController
{



    [self presentViewController:viewController animated:NO completion:nil];
    


}


- (void)viewDidLoad
{
    [super viewDidLoad];
    if (SCREEN_HEIGHT>500) {
        self.bgView.image=[UIImage imageNamed:@"lunch_4"];
    }else
    {
        
        self.bgView.image=[UIImage imageNamed:@"lunch"];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
