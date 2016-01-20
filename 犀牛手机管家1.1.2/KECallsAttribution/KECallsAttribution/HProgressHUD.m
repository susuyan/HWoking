//
//  HProgressHUD.m
//  Harassment
//
//  Created by 余胜民 on 15/12/11.
//  Copyright © 2015年 EverZones. All rights reserved.
//

#import "HProgressHUD.h"

@implementation HProgressHUD
+ (void)showMBProgressHUD:(UIView *)view andString:(NSString *)string {
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    hud.labelText = string;
    hud.yOffset = -50;
    hud.mode = MBProgressHUDModeCustomView;
    hud.animationType = MBProgressHUDAnimationZoom;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [hud removeFromSuperview];
    }];
}
@end
