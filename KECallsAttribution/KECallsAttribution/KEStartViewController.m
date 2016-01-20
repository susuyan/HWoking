//
//  KEStartViewController.m
//  KEMusic
//
//  Created by Kernel on 13-8-20.
//  Copyright (c) 2013年 Kernel. All rights reserved.
//

#import "KEStartViewController.h"

#import "EZIndexViewController.h"
#import "EZAgreeViewController.h"
@interface KEStartViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic)UIPageControl * pageControl;

@end

@implementation KEStartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    self.pictureData = [NSArray array];
    if (SCREEN_HEIGHT > 500) {
        self.pictureData = @[@"ios7_1.png",
                             @"ios7_2.png",
                             @"ios7_3.png",
                             @"ios7_4.png",
                             @"ios7_5.png"];
    }else{
        self.pictureData = @[@"ios6_1.png",
                             @"ios6_2.png",
                             @"ios6_3.png",
                             @"ios6_4.png",
                             @"ios6_5.png"];
    }

    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 5, SCREEN_HEIGHT);
    [self.view addSubview:scrollView];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;

    
    for (int i = 0; i < self.pictureData.count;i++ ) {
        
        NSString *imageStr = self.pictureData[i];
        
        UIImage * image = [UIImage imageNamed:imageStr];
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        imageView.image = image;
        
        [scrollView addSubview:imageView];
        
        if (i == self.pictureData.count - 1) {
                        
            UIView *guideView=[[[NSBundle mainBundle]loadNibNamed:@"guide" owner:self options:nil]objectAtIndex:0];
            
            guideView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            [guideView setBackgroundColor:[UIColor clearColor]];
            imageView.userInteractionEnabled=YES;
            
            [imageView addSubview:guideView];
        }
        

    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    self.pageControl.currentPage = round(offset.x / scrollView.frame.size.width);
}
- (void)start:(id)sender {
    
    EZIndexViewController * mainViewController =[self.storyboard instantiateViewControllerWithIdentifier:@"EZIndexViewController"];
    UINavigationController * navigation = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    mainViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:navigation animated:YES completion:nil];

}

- (IBAction)openApp:(UIButton *)sender {
    
    [self start:sender];
    
}

- (IBAction)checkButtonPressed:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        _openAppButton.userInteractionEnabled = NO;
    }else{
        _openAppButton.userInteractionEnabled = YES;
    }
    
    
}

- (IBAction)openAboutUs:(UIButton *)sender {
    
    
   // [self xieyiView];
    
    
    EZAgreeViewController *agree=[self.storyboard instantiateViewControllerWithIdentifier:@"EZAgreeViewController"];
    
    agree.isPresented=YES;
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:agree];
    
    
    [self presentViewController:nav animated:YES completion:nil];
    
    
    
}



@end

