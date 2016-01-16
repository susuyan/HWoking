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
    
    
    self.batteryLevelLbl.text=[NSString stringWithFormat:@"%d",(int)[self batteryLevel]];
    
    
    batteryFullTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(batteryFullTimer) userInfo:nil repeats:YES];
    needTime = totaltime * (100 - [self batteryLevel])/100;
    
    
    canUseTime=totalusetime*[self batteryLevel]/100;
    
    self.waveView.currentLinePointY=(1-([self batteryLevel]/100))*self.waveView.frame.size.height;
    
    self.waveView.hidden = YES;
    
    if (kIsIPhone4) {
        self.upViewHeightConstraint.constant = 180;
    }
    
    
    self.moreView.hidden = YES;
    
    [self setupCleanButton];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"index"];
}
-(void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"index"];

}

- (void)setupCleanButton {
    if (IS_IOS8) {
        //因为在iOS 8 以上的系统才能实现照片清理功能
        //TODO: 设置为照片清理
//        [self.cleanButton setBackgroundImage:[UIImage imageNamed:@"zhaopianzhengli"] forState:UIControlStateNormal];
//        [self.cleanButton setBackgroundImage:[UIImage imageNamed:@"zhaopianzhengli_high"] forState:UIControlStateHighlighted];
        
    }else {
        //TODO: 设置为读取系统存储信息
        [self.cleanButton setImage:[UIImage imageNamed:@"kongjian"] forState:UIControlStateNormal];
        
        [self.cleanButton setImage:[UIImage imageNamed:@"kongjian_high"] forState:UIControlStateHighlighted];

    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Event Handle



-(void)skipToQueryPage {

    EZProtectVC *query=[self.storyboard instantiateViewControllerWithIdentifier:@"EZProtectVC"];
    
    
    [self.navigationController pushViewController:query animated:YES];




}
-(void)batteryFullTimer{
    /*************************/
    self.batteryLevelLbl.text=[NSString stringWithFormat:@"%d",(int)[self batteryLevel]];
    
    self.waveView.currentLinePointY=(1-([self batteryLevel]/100))*self.waveView.frame.size.height;
    
    UIDevice *device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = YES;
    if (device.batteryState == UIDeviceBatteryStateUnknown) {
        
        self.chargeTimeLabel.text=@"";
        
        
    }else if (device.batteryState == UIDeviceBatteryStateUnplugged){
        
        
        
        canUseTime=totalusetime*[self batteryLevel]/100;
        
        
        int h; int m;
        h = canUseTime/3600; m = (canUseTime%3600)/60;
        
        
        NSString *timerStr = [NSString stringWithFormat:@"可用%02d小时%02d分钟",h,m];
        
        
        self.chargeTimeLabel.text = timerStr;
        
        
        
        if ([self batteryLevel]>50) {
            
            
            self.lbl_fullTime.text=@"电量充足，请放心使用";
            
        }else {
            
            self.lbl_fullTime.text=@"如需较长时间使用，请充电";
            
            
        }
        
        
        
    }else if (device.batteryState == UIDeviceBatteryStateCharging){
        
        
        
        int h; int m;
        h = needTime/3600; m = (needTime%3600)/60;
        NSString *timerStr = [NSString stringWithFormat:@"充满还需要%02d小时%02d分钟",h,m];
        self.chargeTimeLabel.text = timerStr;
        needTime -= 1;
        if (needTime >= 0 && [self batteryLevel] < 100) {
            needTime = totaltime * (100 - [self batteryLevel])/100;
        }else if ([self batteryLevel] == 100){
            self.chargeTimeLabel.text = @"无需充电";
            self.lbl_fullTime.text=@"电池已充满，无需充电";
            // [batteryFullTimer invalidate];
        }
        
        
        
        if ([self  batteryLevel]<80) {
            
            
            self.lbl_fullTime.text=@"电池会迅速充到80%，仍需连接充电可充满";
            
            
            
        }else if ([self  batteryLevel]<100)
        {
            
            
            self.lbl_fullTime.text=@"电流逐渐减小，确保电池完全充满";
            
            
        }
        
        
        
        
    }else if (device.batteryState == UIDeviceBatteryStateFull){
        
        
        self.chargeTimeLabel.text=@"无需充电";
        
        
        
        self.lbl_fullTime.text=@"电池已充满，无需充电";
        
        
    }
    
}
//设备的当前电量
-(double)batteryLevel
{
    float battery = [self mainbatteryLevel];
    
    return battery;
}

-(float)mainbatteryLevel {
    // Find the battery level
    @try {
        // Get the device
        UIDevice *Device = [UIDevice currentDevice];
        // Set battery monitoring on
        Device.batteryMonitoringEnabled = YES;
        
        // Set up the battery level float
        float BatteryLevel = 0.0;
        // Get the battery level
        float BatteryCharge = [Device batteryLevel];
        
        // Check to make sure the battery level is more than zero
        if (BatteryCharge > 0.0f) {
            // Make the battery level float equal to the charge * 100
            BatteryLevel = BatteryCharge * 100;
        } else {
            // Unable to find the battery level
            return -1;
        }
        
        // Output the battery level
        return BatteryLevel;
    }
    @catch (NSException *exception) {
        // Error out
        return -1;
    }
}

#pragma mark - IBAction 

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
