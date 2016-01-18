//
//  EZIndexViewController.m
//  KECallsAttribution
//
//  Created by 赵 进喜 on 15/4/21.
//  Copyright (c) 2015年 K.BLOCK. All rights reserved.
//

#import "EZIndexViewController.h"
#import "EZProtectVC.h"
#import "DetailViewController.h"
#import "EZScanPhotoVC.h"
#import "SystemServicesDemoDiskViewController.h"
#define totaltime 3*60*60

#define totalusetime (19*60+45)*60


@interface EZIndexViewController ()<UIGestureRecognizerDelegate> {

    NSTimer *batteryFullTimer;
    int needTime;
    int canUseTime;
}



@end

@implementation EZIndexViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IS_IOS7) {
        self.navigationController.interactivePopGestureRecognizer.delegate=self;
    }
    
    if (kIsIPhone4) {
        self.upViewHeightConstraint.constant = 180;
    }
    
    self.moreView.hidden = YES;
    [self setupCleanButton];
    
    [self setupDeviceName];
    
    [self setupAnimation];
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"index"];
}
-(void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"index"];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initial UI
/**
 *  因为在iOS 8 以上的系统才能实现照片清理功能
 */
- (void)setupCleanButton {
    if (IS_IOS8) {
        //
        //TODO: 设置为照片清理
        //        [self.cleanButton setBackgroundImage:[UIImage imageNamed:@"zhaopianzhengli"] forState:UIControlStateNormal];
        //        [self.cleanButton setBackgroundImage:[UIImage imageNamed:@"zhaopianzhengli_high"] forState:UIControlStateHighlighted];
        
    }else {
        //TODO: 设置为读取系统存储信息
        [self.cleanButton setImage:[UIImage imageNamed:@"kongjian"] forState:UIControlStateNormal];
        [self.cleanButton setImage:[UIImage imageNamed:@"kongjian_high"] forState:UIControlStateHighlighted];
        
    }
}

- (void)setupAnimation {
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.delegate = self;
    rotationAnimation.toValue = [NSNumber numberWithFloat: -M_PI_2 * 8];
    rotationAnimation.duration = 3;
    rotationAnimation.repeatCount = 1.0;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [rotationAnimation setValue:@"rotationAnimation" forKey:@"MyAnimationType"];
    [self.circleImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        NSString *value = [anim valueForKey:@"MyAnimationType"];
        
        if ([value isEqualToString:@"rotationAnimation"]) {
            self.circleImageView.transform = CGAffineTransformMakeRotation(-M_PI_2 * 16);
            NSLog(@"动画结束");
            [self displayDeviceInfo];
            
        }
    }
}

/**
 *  获取设备名字，并设置
 */
- (void)setupDeviceName {
    //TODO: 获取设备名字
}

#pragma mark - Event Handle
/**
 *  显示设备信息
 *  设备可用空间
 */
- (void)displayDeviceInfo {
    //TODO: 获取设备可用空间，并设置
    
}

/**
 *  优化建议判断
 */
- (void)deviceOptimizeJudge {
    //TODO: 1. 是否开启防骚扰 2. 网络测速保证用户一天点一次 3. 看可用空间是否大于600M
    
}

#pragma mark - IBAction

- (IBAction)optimizeAction:(UIButton *)sender {
    
}

- (IBAction)cleanPhotoAction:(UIButton *)sender {
    if (IS_IOS8) {

        EZScanPhotoVC *scan=[self.storyboard instantiateViewControllerWithIdentifier:@"EZScanPhotoVC"];
        
        [self.navigationController pushViewController:scan animated:YES];
    }else {
        //TODO: 跳转到系统空间界面
        SystemServicesDemoDiskViewController *diskInfo = [self.storyboard instantiateViewControllerWithIdentifier:@"SystemServicesDemoDiskViewController"];
        [self.navigationController pushViewController:diskInfo animated:YES];
    }
    
}

- (IBAction)wallpaperPage:(UIButton *)sender {
    self.moreView.hidden = NO;
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect moreView = self.moreView.frame;
        moreView.origin.y = self.upView.frame.origin.y;
        self.moreView.frame = moreView;
    } completion:nil];
    
    
}
- (IBAction)downView:(id)sender {
    [UIView animateWithDuration:1.0f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect moreView = self.moreView.frame;
        moreView.origin.y = SCREEN_HEIGHT;
        self.moreView.frame = moreView;
        self.moreView.hidden = YES;
    } completion:nil];
    
    
}
- (IBAction)pushPaperPage:(id)sender {
    DetailViewController *detail=[[DetailViewController alloc]init];
    [self.navigationController pushViewController:detail animated:YES];
}
@end
