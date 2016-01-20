//
//  YUProtectSettingController.m
//  KECallsAttribution
//
//  Created by EverZones on 15/9/14.
//  Copyright (c) 2015年 K.BLOCK. All rights reserved.
//

#import "YUProtectSettingController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "UMSocial.h"
#import "KEProgressHUD.h"
#import "YUVcardImporter.h"
@interface YUProtectSettingController ()

@end

@implementation YUProtectSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)setupLunbo {
    
    self.disBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.disBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.disBtn.backgroundColor =[UIColor blackColor];
    self.disBtn.alpha = 0.2;
    [self.view addSubview:self.disBtn];
    [self.disBtn addTarget:self action:@selector(dismissLunbo) forControlEvents:UIControlEventTouchUpInside];
    
    self.lunbo = [[Lunbo alloc]initWithFrame:CGRectMake((SCREEN_WIDTH -250)/2, (SCREEN_HEIGHT - 380 - 64)/2, 250, 380)];
    
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:@[@"guide1",@"guide2",@"guide3",@"guide4"]];
    self.lunbo.imagearr = arr;
    self.lunbo.pagecontrol.hidden = YES;
    [self.view addSubview: self.lunbo];

}

- (void)dismissLunbo {
    self.disBtn.hidden = YES;
    self.lunbo.hidden = YES;
}
- (IBAction)backHome:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 清空号码库
- (IBAction)cleanNumberPlate:(UIButton *)sender {
    
    YUVcardImporter *importer = [[YUVcardImporter alloc] init];
    [importer deleteNumberLibrary];
    [KEProgressHUD mBProgressHUD:self.view :@"已经删除号码库"];
}
#pragma mark - 弹出加入黑名单提示
- (IBAction)addBlacklist:(UIButton *)sender {
    //TODO: 黑名单的弹出提示
    [self setupLunbo];
}
#pragma mark - 分享
- (IBAction)shareAction:(UIButton *)sender {
    NSString * content = [NSString stringWithFormat:@"%@。\r\n%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"],[NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@?mt=8",APPLE_ID]];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMENG_APP_SHARE_ID
                                      shareText:content
                                     shareImage:[UIImage imageNamed:@"icon120"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,nil]
                                       delegate:nil];
    [UMSocialData defaultData].extConfig.title = @"手机归属地";

    
}

@end
