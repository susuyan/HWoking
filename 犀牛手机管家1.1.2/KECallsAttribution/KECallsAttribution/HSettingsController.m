//
//  HSettingsController.m
//  KECallsAttribution
//
//  Created by EverZones on 16/1/4.
//  Copyright © 2016年 K.BLOCK. All rights reserved.
//

#import "HSettingsController.h"
#import "HVcardImporter.h"
#import "MBProgressHUD.h"
#import "UMSocial.h"
#import "HDefaults.h"
@interface HSettingsController ()

@property (weak, nonatomic) IBOutlet UISwitch *harassmentSwitch;

@end

@implementation HSettingsController


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.harassmentSwitch.on = [HDefaults sharedDefaults].isOpenHarassment;
    if (self.harassmentSwitch.on) {
        self.harassmentSwitch.enabled = YES;
    }else {
        self.harassmentSwitch.enabled = NO;
    }

}

#pragma mark - IBAction

- (IBAction)backAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  分享
 */
- (IBAction)shareAction:(UIButton *)sender {
    NSString * content = [NSString stringWithFormat:@"%@。\r\n%@",@"你的iphone也能防骚扰啦！陌生来电识别、防骚扰防诈骗，不信你也试试",[NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@?mt=8",APPLE_ID]];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMENG_APP_SHARE_ID
                                      shareText:content
                                     shareImage:[UIImage imageNamed:@"icon120"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,nil]
                                       delegate:nil];
    [UMSocialData defaultData].extConfig.title = @"手机归属地";
}
/**
 *  防骚扰开关
 */
- (IBAction)harassmentSwitchAction:(UISwitch *)sender {
    if (!sender.on) {
        
        [HVcardImporter CheckAddressBookAuthorization:^(bool isAuthorized) {
            if (isAuthorized) {
                HVcardImporter *importer = [[HVcardImporter alloc] init];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                hud.mode = MBProgressHUDModeIndeterminate;
                hud.labelText = @"正在移除号码库";
                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                    // Do something...
                    [importer closeAntiHarassmentMode];
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"openHarassment"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        hud.labelText = @"移除完毕";
                        [hud hide:YES];
                    });
                });
                
            }else {
                //TODO: 做出通讯录权限提示。
                UIAlertView * alart = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请您设置允许APP访问您的通讯录\n设置>隐私>通讯录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alart show];
                self.harassmentSwitch.on = YES;
            }
        }];
        
        
    }

}

@end
