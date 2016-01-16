//
//  KBAppDelegate.m
//  KECallsAttribution
//
//  Created by lichenWang on 14-4-2.
//  Copyright (c) 2014年 K.BLOCK. All rights reserved.
//


//                            _ooOoo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                            O\ = /O
//                        ____/`---'\____
//                      .   ' \\| |// `.
//                       / \\||| : |||// \
//                     / _||||| -:- |||||- \
//                       | | \\\ - /// | |
//                     | \_| ''\---/'' | |
//                      \ .-\__ `-` ___/-. /
//                   ___`. .' /--.--\ `. . __
//                ."" '< `.___\_<|>_/___.' >'"".
//               | | : `- \`.;`\ _ /`;.`/ - ` : | |
//                 \ \ `-. \_ __\ /__ _/ .-` / /
//         ======`-.____`-.___\_____/___.-`____.-'======
//                            `=---='
//                 佛祖保佑     永无bug     永不修改
//         .............................................
//                  佛祖镇楼                  BUG辟易
//          佛曰:
//                  写字楼里写字间，写字间里程序员；
//                  程序人员写程序，又拿程序换酒钱。
//                  酒醒只在网上坐，酒醉还来网下眠；
//                  酒醉酒醒日复日，网上网下年复年。
//                  但愿老死电脑间，不愿鞠躬老板前；
//                  奔驰宝马贵者趣，公交自行程序员。
//                  别人笑我忒疯癫，我笑自己命太贱；
//                  不见满街漂亮妹，哪个归得程序员？





// ┏ ┓　　　┏ ┓
//┏┛ ┻━━━━━┛ ┻┓
//┃　　　　　　 ┃
//┃　　　━　　　┃
//┃　┳┛　  ┗┳　┃
//┃　　　　　　 ┃
//┃　　　┻　　　┃
//┃　　　　　　 ┃
//┗━┓　　　┏━━━┛
//  ┃　　　┃   神兽保佑
//  ┃　　　┃   代码无BUG！
//  ┃　　　┗━━━━━━━━━┓
//  ┃　　　　　　　    ┣┓
//  ┃　　　　         ┏┛
//  ┗━┓ ┓ ┏━━━┳ ┓ ┏━┛
//    ┃ ┫ ┫   ┃ ┫ ┫
//    ┗━┻━┛   ┗━┻━┛



//
//                       .::::.
//                     .::::::::.
//                    :::::::::::
//                 ..:::::::::::'
//              '::::::::::::'
//                .::::::::::
//           '::::::::::::::..
//                ..::::::::::::.
//              ``::::::::::::::::
//               ::::``:::::::::'        .:::.
//              ::::'   ':::::'       .::::::::.
//            .::::'      ::::     .:::::::'::::.
//           .:::'       :::::  .:::::::::' ':::::.
//          .::'        :::::.:::::::::'      ':::::.
//         .::'         ::::::::::::::'         ``::::.
//     ...:::           ::::::::::::'              ``::.
//    ```` ':.          ':::::::::'                  ::::..
//                       '.:::::'                    ':'````..
//
//美女镇楼


#import "KBAppDelegate.h"

#import "UMSocial.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "MobClick.h"
@import GoogleMobileAds;
#import "Reachability.h"
#import "UMSocial.h"
#import "KEProgressHUD.h"
#import "APService.h"
#import "UMSocialSinaHandler.h"

#import "HTTPServer.h"
#import "GDTMobInterstitial.h"
#import "AFHTTPRequestOperationManager.h"
#import "UMFeedback.h"
#import "UMOpus.h"
#import "EZFeedBackViewController.h"
#import "SVProgressHUD.h"
#import <AdSupport/AdSupport.h>
//#import "EZAddQuickContractVC.h"
@interface KBAppDelegate()<UIAlertViewDelegate,GADInterstitialDelegate,GDTMobInterstitialDelegate>
@property (nonatomic, strong)NSDictionary * dictionary;
@property (nonatomic, strong)UIAlertView * updateAlertView;
@property (nonatomic, strong)UIAlertView * neituiAlertView;
@property (nonatomic, strong)UIAlertView * giveAmarkAlertView;
@property (nonatomic, copy)NSString * urlScheme;
@property (nonatomic, strong)GADInterstitial *interstitial;
@property(nonatomic,strong)GDTMobInterstitial *gdtInterstitial;
@end
@implementation KBAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


#define IOS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IOS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
   
    
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    
    if (IS_IOS7) {
        
        [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
        
        [[UITextField appearance]setTintColor:[UIColor lightGrayColor]];

        
    }
    
    
    
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    if (DEVICE) {
        UIImage * imageNavigationBar = [UIImage imageNamed:@"daohang_bg"];
        [[UINavigationBar appearance] setBackgroundImage:imageNavigationBar forBarMetrics:UIBarMetricsDefault];
    }else{
        UIImage * imageNavigationBar = [UIImage imageNamed:@"daohang_bg_ios7"];
        [[UINavigationBar appearance] setBackgroundImage:imageNavigationBar forBarMetrics:UIBarMetricsDefault];
    }
    NSDictionary * titelDictionary = @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                       NSFontAttributeName:[UIFont boldSystemFontOfSize:22]};
    [[UINavigationBar appearance] setTitleTextAttributes:titelDictionary];
    
    
    
    
    
     [MobClick startWithAppkey:UMENG_APP_ID reportPolicy:BATCH channelId:@"App Store"];
    //[MobClick startWithAppkey:UMENG_APP_ID reportPolicy:BATCH channelId:@"91 Platform"];
    [MobClick setVersion:[VERSION integerValue]];
    
    [self testUM];
    
    [self umSocial];
    
    
    
    
    
   // [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isPassed"];
    
    
    
    NSString *idfa=[[[ASIdentifierManager sharedManager] advertisingIdentifier]UUIDString];
    [[NSUserDefaults standardUserDefaults]setValue:idfa forKey:@"uid"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
    
    
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"adtype"]==nil) {
        
        
        
         [[NSUserDefaults standardUserDefaults]setObject:@"admob" forKey:@"adtype"];
        
        
    }
    
    
    [self requests];//控制请求
    
    
    
    
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        
        
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert) categories:nil];
        [[UIApplication sharedApplication]registerForRemoteNotifications];
        
    }else
    {
        
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
        
    }
    
    
    
    
    
#else
    
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
    
#endif
    
    
    
    [APService setupWithOption:launchOptions];
    
    //内购，清除钥匙串
    // [SFHFKeychainUtils deleteItemForUsername:BUNDLEID andServiceName:kProductIdInAppPurchase error:nil];
    
    
    [[HTTPServer sharedHTTPServer] start];
    
    
    
//    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
//    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    
    
    
    
//    NSString *lastVersion=[[NSUserDefaults standardUserDefaults]objectForKey:@"lastVersion"];
//    
//    
//    if (lastVersion==nil) {
//        
//        
//        
//        [self postUserIdfa:idfa isAd:NO];
//        
//        
//        
//    }
    

    
    
    
    
    [UMOpus setAudioEnable:YES];
    [UMFeedback setAppkey:UMENG_APP_ID];
    [UMFeedback setLogEnabled:YES];
    [[UMFeedback sharedInstance] setFeedbackViewController:[UMFeedback feedbackViewController] shouldPush:NO];
   

    
    checkTime= [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(testBattery) userInfo:nil repeats:YES];
    
   
    
    
    return YES;
}
-(void)testBattery
{
    
    
    
    
    UIDevice *device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = YES;
    
    
    
    
    // [formatter dateFromString:@"00:00"];device.batteryState ==UIDeviceBatteryStateFull  [self  batteryLevel]<80
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"Battery"] && device.batteryState ==UIDeviceBatteryStateFull ) {
        
        [checkTime invalidate];
        
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        if (notification) {
            
            notification.fireDate = [NSDate date ];
            notification.repeatInterval=0;
            notification.timeZone=[NSTimeZone defaultTimeZone];
            notification.alertBody =[NSString stringWithFormat:@"当电池满电时，请拔掉充电线，过度充电会损坏电池寿命!"];
            // notification.alertAction = @"textContent";
        }
        
        notification.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
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
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    
    
    [checkTime invalidate];
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate) ;
    
    
    NSString *path =@"/System/Library/Audio/UISounds/sms-received1.caf";
    //[[NSBundle bundleWithIdentifier:@"com.apple.UIKit" ]pathForResource:soundName ofType:soundType];//得到苹果框架资源UIKit.framework ，从中取出所要播放的系统声音的路径
    //[[NSBundle mainBundle] URLForResource: @"tap" withExtension: @"aif"];  获取自定义的声音
    
    SystemSoundID sound;
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&sound);
    
    
    AudioServicesPlaySystemSound(sound);
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"当电池满电时，请拔掉充电线，过度充电会损坏电池寿命!" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    
    
    [alert show];
    
    
}



- (void)receiveNotification:(id)receiveNotification {
    //    NSLog(@"receiveNotification = %@", receiveNotification);
}

- (void)checkFinished:(NSNotification *)notification {
    NSLog(@"class checkFinished = %@", notification);
}


-(void)postUserIdfa:(NSString *)uid isAd:(BOOL)isAd
{


    
    int time=[[NSDate date]timeIntervalSince1970];
    
    


    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers]];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html", nil];
    
    
    NSString *url;
    
    if (isAd) {
        
        
         url=[NSString stringWithFormat:@"http://93app.com/laidianguishu/record_clikc_ad_user.php?version=%@&bundleid=%@&idfa=%@&time=%d",VERSION,BUNDLEID,uid,time];
        
        
    }else
    {
    
        url=[NSString stringWithFormat:@"http://93app.com/laidianguishu/record_all_user.php?version=%@&bundleid=%@&idfa=%@&time=%d",VERSION,BUNDLEID,uid,time];
    
    
    }
    
    
    
    
    
    
    
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
      
        
        NSLog(@"idfa:%@",responseObject);
        
        
        
        if (isAd) {
            NSURL *url = [NSURL URLWithString:self.urlScheme];
            [[UIApplication sharedApplication]openURL:url];
        }
        
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
       
        NSLog(@"idfa error:%@",error);
    
    }];


}



- (void)umSocial{    
    [UMSocialData setAppKey:UMENG_APP_SHARE_ID];
    //设置微信AppId，url地址传nil，将默认使用友盟的网址
    NSString * string= [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@?mt=8",APPLE_ID];
   // [UMSocialWechatHandler setWXAppId:@"wx12815c3885327d6a" url:string];
    
    [UMSocialWechatHandler setWXAppId:@"wx12815c3885327d6a" appSecret:@"bfc284340b6fcd09afe9762d95f12aa6" url:string];
    
    
    [UMSocialData defaultData].extConfig.title = @"手机归属地";
    
    //设置手机QQ的AppId，url传nil，将使用友盟的网址
    [UMSocialQQHandler setQQWithAppId:@"101009432" appKey:@"0ecd1c5cad0a81e5e8411ebad3b411c7" url:string];
    //打开新浪微博的SSO开关
   // [UMSocialConfig setSupportSinaSSO:YES];

    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    

    
}

-(void)testUM
{



    
    Class cls = NSClassFromString(@"UMANUtil");
    SEL deviceIDSelector = @selector(openUDIDString);
    NSString *deviceID = @"974993118602";
    if(cls && [cls respondsToSelector:deviceIDSelector]      ){
        deviceID = [cls performSelector:deviceIDSelector];
    }
    NSLog(@"{\"oid\": \"%@\"}", deviceID);
    


}
- (void)requests{
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        return;
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://93app.com/gonglue_xilie/ping.php?id=%@&version=%@",BUNDLEID,VERSION]];
        NSLog(@"neitui:%@",url);
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        if (data) {
            self.dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        }else{
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.dictionary[@"status"] integerValue] == 1 && [self.dictionary[@"in_control"] integerValue] == 0){
              //  [self giveAmark];//评分
                [self performSelector:@selector(giveAmark) withObject:self afterDelay:25];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isPassed"];
                
                [[NSUserDefaults standardUserDefaults]setObject:self.dictionary[@"ad_banner"] forKey:@"adtype"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
//                if (![self.dictionary[@"update_url"] isEqualToString:@""]) {
//                    //版本更新
//                    self.updateAlertView=[[UIAlertView alloc]initWithTitle:@"更新"
//                                                                   message:@"有可更新的版本，需要更新吗?"
//                                                                  delegate:self
//                                                         cancelButtonTitle:@"取消"
//                                                         otherButtonTitles:@"下载", nil];
//                    [self.updateAlertView show];
//                }
                if ([self.dictionary[@"big_ad_interval"] integerValue] > 1) {
                    
                    
                    [NSTimer scheduledTimerWithTimeInterval:[self.dictionary[@"big_ad_interval"] integerValue] target:self selector:@selector(loadFullScreenAd) userInfo:nil repeats:NO];
                }
                [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(neituiAction) userInfo:nil repeats:NO];
            }
        });
    });
}
- (void)neituiAction{
    id  test = self.dictionary[@"neitui_list"];
    if ([test isKindOfClass:[NSArray class]]) {
        
        
        
        
        NSArray * array = self.dictionary[@"neitui_list"];
        
        
        
        
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        int lastInterval=[userDefaults floatForKey:@"lasttime"];
        NSDate *nowDate=[NSDate date];
        int nowInterval=[nowDate timeIntervalSince1970];
        

        
        //首次不弹广告
        if (lastInterval==0) {
            
            
            
            [userDefaults setInteger:nowInterval-6*3600 forKey:@"lasttime"];
            [userDefaults synchronize];

            return;
            
        }
        
        
        if (nowInterval-lastInterval>=3600*12*1) {
            
            
            for (int i=0; i<array.count; i++) {
                
                
                
                
                
                
                
                self.urlScheme = array[i][@"url"];
                
                
                
                
                
                
                
                
                
                
                
                //已安装跳出当前循环
                if ([self APCheckIfAppInstalled2:[array objectAtIndex:i][@"url_scheme"]]) {
                    
                    continue;
                    
                    
                }else{
                    //弹出广告，停止循环
                    
                    
                    [userDefaults setInteger:nowInterval forKey:@"lasttime"];
                    [userDefaults synchronize];
                    
                    
                    
                    self.neituiAlertView = [[UIAlertView alloc] initWithTitle:[array objectAtIndex:i][@"headline"]
                                                                      message:[array objectAtIndex:i][@"description"]
                                                                     delegate:self
                                                            cancelButtonTitle:@"取消"
                                                            otherButtonTitles:@"下载", nil];
                    [self.neituiAlertView show];
                    
                    
                    
                    break;
                    
                    
                }
                
            }
            
            
            
            
            
            
        }
        
        
        
        
 
        
    }
}
- (void)giveAmark{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger nextAlertCount = [userDefaults integerForKey:@"nextAlertCount"];
    NSInteger count = [userDefaults integerForKey:@"count"];
    count ++;
    if (count == 1) {
        nextAlertCount +=3;
        [userDefaults setInteger:nextAlertCount forKey:@"nextAlertCount"];
        
    }
    [userDefaults setInteger:count forKey:@"count"];
    [userDefaults synchronize];
    {
        if (count == nextAlertCount) {
            
            
            nextAlertCount +=5;
            [userDefaults setInteger:nextAlertCount forKey:@"nextAlertCount"];
            
            
            [userDefaults synchronize];
            
            self.giveAmarkAlertView = [[UIAlertView alloc] initWithTitle:@"给个好评吧"
                                                                 message:@"觉得手机归属地好用么？举手之劳给个评分吧！您的支持是我们的动力！"
                                                                delegate:self
                                                       cancelButtonTitle:@"残忍拒绝"
                                                       otherButtonTitles:@"现在就去",@"意见反馈", nil];
            [self.giveAmarkAlertView show];
            
        }
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == self.updateAlertView) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.dictionary[@"update_url"]]];
        }
    }else if (alertView == self.giveAmarkAlertView){
        if (buttonIndex == 0) {
//            NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
//            
//            NSInteger nextAlertCount = [userDefaults integerForKey:@"nextAlertCount"];
//            nextAlertCount += 5;
//            [userDefaults setInteger:nextAlertCount forKey:@"nextAlertCount"];
//            [userDefaults synchronize];
        }else if (buttonIndex==1)
        {
        
            NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
            
            NSInteger nextAlertCount = [userDefaults integerForKey:@"nextAlertCount"];
            nextAlertCount += 5;
            [userDefaults setInteger:nextAlertCount forKey:@"nextAlertCount"];
            [userDefaults synchronize];
            
            
            
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@?mt=8",APPLE_ID]]];

        
        
        }else if (buttonIndex == 2){
            
            
            
            UIViewController *vc= [self getLast];
            
            EZFeedBackViewController *feedback=[[EZFeedBackViewController alloc]init];
            
            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:feedback];
            
            
            [vc presentViewController:nav animated:YES completion:nil];

            
            
           
        }
    }else if (alertView == self.neituiAlertView){
        if (buttonIndex == 1) {
            
            
           // [self postUserIdfa:UID isAd:YES];
            
            NSURL *url = [NSURL URLWithString:self.urlScheme];
            [[UIApplication sharedApplication]openURL:url];
           
        }
    }
}
-(void)loadFullScreenAd
{
    
    NSString *type=[[NSUserDefaults standardUserDefaults]objectForKey:@"adtype"];
    
    
    
    if ([type isEqualToString:@"gdt"]) {
        
        
        _gdtInterstitial = [[GDTMobInterstitial alloc] initWithAppkey:GDT_APP_ID
                                                          placementId:GDT_SCREEN_APP_ID];
        
        _gdtInterstitial.delegate=self;
        
        _gdtInterstitial.isGpsOn = YES; //【可选】设置GPS开关
        //预加载⼲⼴广告
        [_gdtInterstitial loadAd];
        
        
        
    }else
    {
    
    
        self.interstitial = [[GADInterstitial alloc]init];
        self.interstitial.delegate=self;
        self.interstitial.adUnitID =ADMOB_SCREEN_APP_ID;
        [self.interstitial loadRequest:[GADRequest request]];
    
    }
    
    
    
    
   
}
//admob
- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial
{
    if (self.window.rootViewController.presentedViewController.presentedViewController==nil) {
         [self.interstitial presentFromRootViewController:self.window.rootViewController.presentedViewController];
    }else
    {
     [self.interstitial presentFromRootViewController:self.window.rootViewController.presentedViewController.presentedViewController];
    
    }
    
   
    
   
}
- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error
{


    NSLog(@"%@",error);


}


//广点通
// ⼲⼴广告预加载成功回调
- (void)interstitialSuccessToLoadAd:(GDTMobInterstitial *)interstitial
{
    
    

    if (self.window.rootViewController.presentedViewController.presentedViewController==nil) {
        [self.gdtInterstitial presentFromRootViewController:self.window.rootViewController.presentedViewController];
    }else
    {
        [self.gdtInterstitial presentFromRootViewController:self.window.rootViewController.presentedViewController.presentedViewController];
        
    }

   
}// ⼲⼴广告预加载失败回调
- (void)interstitialFailToLoadAd:(GDTMobInterstitial *)interstitial errorCode:(int)errorCode
{

    NSLog(@"广点通：%d",errorCode);


}






-(BOOL)APCheckIfAppInstalled2:(NSString *)urlSchemes
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlSchemes]])
    {
        NSLog(@"installed");
        return  YES;
    }else{
        return  NO;
    }
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    [self saveContext];
    
 
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    BOOL backgroundAccepted = [[UIApplication sharedApplication] setKeepAliveTimeout:600 handler:^{ [self backgroundHandler]; }];
    if (backgroundAccepted)
    {
        NSLog(@"backgrounding accepted");
    }
    
    [self backgroundHandler];

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
       // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService  applicationDidBecomeActive];
    
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
    
     [[HTTPServer sharedHTTPServer] stop];
    
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
- (void)backgroundHandler {
    
    NSLog(@"### -->backgrounding handler");
    
    UIApplication*    app = [UIApplication sharedApplication];
    
    backgroundTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:backgroundTask];
        backgroundTask = UIBackgroundTaskInvalid;
    }];
    
    // Start the long-running task
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        
        
        
    });
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"KECallsAttribution" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"KECallsAttribution.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//    
//    
//    if ([[url scheme] isEqualToString:@"quickdial"]) {
//        NSString *hostName = [url host];
//        if ([hostName isEqualToString:@"tel"]) {
//            // NSString *phoneNo = [url query];
//            NSString *phoneNo = [[[url absoluteString] componentsSeparatedByString:@"//"] objectAtIndex:2];
//            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phoneNo]]];
//        }
//    }
//
//   
//    
//    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
//}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    
    
    
    if ([[url scheme] isEqualToString:@"quickdial"]) {
        NSString *hostName = [url host];
        if ([hostName isEqualToString:@"tel"]) {
            // NSString *phoneNo = [url query];
            NSString *phoneNo = [[[url absoluteString] componentsSeparatedByString:@"//"] objectAtIndex:2];
            
            NSLog(@"__________%@",phoneNo);
            
            
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phoneNo]]];
        }
    }else if ([[url host]isEqualToString:@"widgetquick"])
    {
    
    
    
        
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"widgetquick" object:nil];
        
        
      
    
    
    }

   // NSLog(@"%@___%@___%@",url,[url scheme],[url host]);
    
    
    
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    
    
    
    // Required
    [APService registerDeviceToken:deviceToken];
    
    
    
    
    [[UMFeedback sharedInstance]updateUserInfo:@{@"contact":@{@"user_id":[APService registrationID]}}];
    
    
   
    
    
}
//iOS 7 Remote Notification
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"this is iOS7 Remote Notification");
    // 取得 APNs 标准信息内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    
    // 取得自定义字段内容
    NSString *customizeField1 = [userInfo valueForKey:@"customizeField1"]; //自定义参数，key是自己定义的
    NSLog(@"content =[%@], badge=[%ld], sound=[%@], customize field =[%@]",content,(long)badge,sound,customizeField1);
    // Required
    
    // [[UIApplication sharedApplication]openURL:[NSURL URLWithString:content]];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [APService handleRemoteNotification:userInfo];
    
    [UMFeedback didReceiveRemoteNotification:userInfo];
    
    // [UMFeedback showFeedback:[UMFeedback feedbackViewController] withAppkey:UMENG_APP_ID];
    
    
     NSString *key = [userInfo valueForKey:@"key"];
    
    if ([key isEqualToString:@"feedback"]) {
        
        
        UIViewController *vc= [self getLast];
        
        EZFeedBackViewController *feedback=[[EZFeedBackViewController alloc]init];
        
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:feedback];
        
        
        [vc presentViewController:nav animated:YES completion:nil];

        
    }
    
    
    
    
    
    

    completionHandler(UIBackgroundFetchResultNoData);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required
    [APService handleRemoteNotification:userInfo];
    
    
//    [UMFeedback showFeedback:[UMFeedback feedbackViewController] withAppkey:UMENG_APP_ID];
    
    
   
    
    
    //    [UMessage didReceiveRemoteNotification:userInfo];
    [UMFeedback didReceiveRemoteNotification:userInfo];
    
    
    NSString *key = [userInfo valueForKey:@"key"];
    
    if ([key isEqualToString:@"feedback"]) {
        
        
        UIViewController *vc= [self getLast];
        
        EZFeedBackViewController *feedback=[[EZFeedBackViewController alloc]init];
        
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:feedback];
        
        
        [vc presentViewController:nav animated:YES completion:nil];
        
        
    }

    
    
    


}



-(UIViewController *)getLast
{


    for (UIViewController* next = self.window.rootViewController; next; next =
         next.presentedViewController) {
        
        if (next.presentedViewController==nil) {
            return next;
        }
    
    
    }

    return nil;

}



@end
