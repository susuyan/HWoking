//
//  KEStartViewController.m
//  KEMusic
//
//  Created by Kernel on 13-8-20.
//  Copyright (c) 2013年 Kernel. All rights reserved.
//

#import "KEStartViewController.h"
#import "KEMainViewController.h"
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

- (void)viewDidLoad
{
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
    UIImage * testImage = [UIImage imageNamed:self.pictureData[0]];
    UIScrollView * scrollView = [[UIScrollView alloc] init];
    CGRect frame =  scrollView.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size.width = 320;
    frame.size.height = 568;
    scrollView.frame = frame;
    
    for (int i = 0; i < self.pictureData.count;i++ ) {
        UIImage * image = [UIImage imageNamed:self.pictureData[i]];
        UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
        CGRect frame = imageView.frame;
        frame.size.width = testImage.size.width/2;
        frame.size.height = testImage.size.height/2;
        frame.origin.x = frame.size.width * i;
        imageView.frame = frame;
        [scrollView addSubview:imageView];
        
        scrollView.contentSize = CGSizeMake(imageView.frame.size.width * self.pictureData.count, imageView.frame.size.height);
        
        
        
        
        
        if (i == self.pictureData.count - 1) {
            
            
            
            
            UIView *guideView=[[[NSBundle mainBundle]loadNibNamed:@"guide" owner:self options:nil]objectAtIndex:0];
            
            guideView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            
            
            [guideView setBackgroundColor:[UIColor clearColor]];
            imageView.userInteractionEnabled=YES;
            
            [imageView addSubview:guideView];
        }
        
//        if (i == self.pictureData.count - 1) {
//            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
//            button.frame = imageView.frame;
//            [button addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
//            [scrollView addSubview:button];
//        }
    }
    [self.view addSubview:scrollView];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    //加入PageControl;
    UIPageControl * pageControl = [[UIPageControl alloc] init];
    pageControl.frame = CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 40);
    pageControl.numberOfPages = self.pictureData.count;
    pageControl.userInteractionEnabled = YES;
    scrollView.delegate = self;
    self.pageControl = pageControl;
    [self.view addSubview:pageControl];
    self.pageControl.hidden = YES;
    
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    self.pageControl.currentPage = round(offset.x / scrollView.frame.size.width);
}
- (void)start:(id)sender
{
//    KEMainViewController * mainViewController =[self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
//    UINavigationController * navigation = [[UINavigationController alloc] initWithRootViewController:mainViewController];
//    mainViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [self presentViewController:navigation animated:YES completion:nil];
    
    
    EZIndexViewController * mainViewController =[self.storyboard instantiateViewControllerWithIdentifier:@"EZIndexViewController"];
    UINavigationController * navigation = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    mainViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:navigation animated:YES completion:nil];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

