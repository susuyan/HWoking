//
//  KEProgressHUD.m
//  KECallsAttribution
//
//  Created by lichenWang on 14-2-18.
//  Copyright (c) 2014年 KERNEL. All rights reserved.
//

#import "KEProgressHUD.h"

@implementation KEProgressHUD
+ (void)mBProgressHUD:(UIView*)view :(NSString*)string{
    MBProgressHUD * HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    HUD.labelText = string;
    HUD.yOffset = -50;
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.animationType = MBProgressHUDAnimationZoom;
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
}
@end
