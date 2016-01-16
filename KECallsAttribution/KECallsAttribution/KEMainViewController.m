//
//  KEMainViewController.m
//  KECallsAttribution
//
//  Created by lichenWang on 14-1-4.
//  Copyright (c) 2014年 KERNEL. All rights reserved.
//

#import "KEMainViewController.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import "UMSocial.h"
@import GoogleMobileAds;

#import "InAppPurchaseManage.h"
//#import "UMUFPHandleView.h"
//#import "UMUFPBadgeView.h"

#import "MobClick.h"
#import <NotificationCenter/NotificationCenter.h>

#import "GDTMobBannerView.h"
//#import "EZAddQuickContractVC.h"
@interface KEMainViewController ()<GADBannerViewDelegate,InAppPurchaseManageDelegate,GDTMobBannerViewDelegate>
{
    InAppPurchaseManage *mPurchaseManage;
    
    
//    UMUFPHandleView *appHandleView;
//    UMUFPBadgeView *appBadge;
//    
//    
//    UMUFPHandleView  *taoBaoHandView;
//    UMUFPBadgeView   *taoBaoBadge;
    
    
    NSArray *buttonArray;

}
@property (nonatomic, strong)GADBannerView * gadBannerView;
@property (nonatomic, strong)GDTMobBannerView *gdtBannerView;
@end

@implementation KEMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(UIStatusBarStyle)preferredStatusBarStyle
{

    return UIStatusBarStyleLightContent;

}
- (void)dealloc
{
    _gdtBannerView.delegate=nil;
    _gdtBannerView.currentViewController=nil;
    _gdtBannerView=nil;
    
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"widgetquick" object:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
   
    
    
    NSString *type=[[NSUserDefaults standardUserDefaults]objectForKey:@"adtype"];
    
    if ([type isEqualToString:@"gdt"]) {
        
        
        
        _gdtBannerView = [[GDTMobBannerView alloc] initWithFrame:CGRectMake(0, 0, GDTMOB_AD_SUGGEST_SIZE_320x50.width,
                                                                        
                                                                         GDTMOB_AD_SUGGEST_SIZE_320x50.height) appkey:GDT_APP_ID
                                                  placementId:GDT_BANNER_APP_ID];
        
        
        
        _gdtBannerView.delegate = self; // 设置Delegate
        _gdtBannerView.currentViewController = self; //设置当前的ViewController
        _gdtBannerView.interval = 30; //【可选】设置刷新频率;默认30秒
        _gdtBannerView.isGpsOn = YES; //【可选】开启GPS定位;默认关闭
        _gdtBannerView.showCloseBtn = YES; //【可选】展⽰示关闭按钮;默认显⽰示
        _gdtBannerView.isAnimationOn = YES; //【可选】开启banner轮播和展现时的动画效果;默认开启
        [self.gadView addSubview:_gdtBannerView]; //添加到当前的view中
        [_gdtBannerView loadAdAndShow]; //加载⼲⼴广告并展⽰示
        
    }else
    {
    
        self.gadBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        self.gadBannerView.adUnitID = ADMOB_APP_ID;
        self.gadBannerView.rootViewController = self;
        self.gadBannerView.delegate  = self;
        
        
        
        [self.gadView addSubview:self.gadBannerView];
        
        
        [self.gadBannerView loadRequest:[GADRequest request]];

    
    
    }
    
    
    
    
    
    
    [self initPurchase];
    [self checkPurchaseHidden];
    
    
  //  [self initUMAPP];
    //[self initUMTaoBao];
    
    
    
     BOOL isPassed = [[NSUserDefaults standardUserDefaults] boolForKey:@"isPassed"];
    
    if (!isPassed) {
        for (UIButton *button in self.hideView) {
            button.hidden=YES;
        }
        
        
         self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 800);
        
        
    }else
    {
    
         self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 1000);
    
    }
    
    //self.navigationItem.leftBarButtonItem=nil;
    
    
    
//    if(IS_IOS8)
//    {
//    
//        //内存插件
//        NCWidgetController *lol = [NCWidgetController widgetController];
//        [lol setHasContent:YES forWidgetWithBundleIdentifier:@"com.app72.laidianguishudi.phoneTodayWidget"];
//
//    
//        NSString *urlStr = @"com.app72.laidianguishudi.phoneTodayWidget://";
//        [[self extensionContext] openURL:[NSURL URLWithString:urlStr] completionHandler:nil];
//
//    
//        //快捷联系人
//        
//        NCWidgetController *quick = [NCWidgetController widgetController];
//        [quick setHasContent:YES forWidgetWithBundleIdentifier:@"com.app72.laidianguishudi.quickwidget"];
//    
//    }
    
    
//动画按钮顺序
  
    buttonArray=@[_guishudi,_tongxunlu,_changyong,_youbian,_ipdianhua,_saomabijia,_shenghuohuangye,_kuaijielianxiren,_wannianli,_findPeople,_haomabaoguang,_kaixinyike,_heimingdan,_wangshnagyingyeting];

    
    
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(goToWidgetPage) name:@"widgetquick" object:nil];
    
    
    
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
//    if (self.view.window == nil) {
//        
//        self.view = nil;
//        //
//    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    
     BOOL isPassed = [[NSUserDefaults standardUserDefaults] boolForKey:@"isPassed"];
    
//    if(isPassed)
//    {
    
    
        [buttonArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            
            UIButton *button=(UIButton *)obj;
            
            button.layer.transform = CATransform3DMakeScale(0, 0, 1);
            button.alpha = 0;
            
            
            if ([button isKindOfClass:[UIButton class]]) {
                
                
                int index=idx/3;
                
                
                [self animateFauxBounceWithView:button idx:index initDelay:0];
                
                
                
                
            }
            
            
            
        }];

    
    
  //  }
    
    
    
    
}





- (IBAction)biaoqing:(UIButton *)sender {
  [self share];
}
- (void)share{
    NSString * content = [NSString stringWithFormat:@"%@。\r\n%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"],[NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@?mt=8",APPLE_ID]];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMENG_APP_SHARE_ID
                                      shareText:content
                                     shareImage:[UIImage imageNamed:@"icon120"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,nil]
                                       delegate:nil];
      [UMSocialData defaultData].extConfig.title = @"犀牛手机管家";
}
- (IBAction)goToWallPapper:(UIButton *)sender {
    
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@?mt=8",@"804520830"]]];
    
}

- (IBAction)removeAds:(UIButton *)sender {
    
    
    [self purchaseAdButtonPressed];
    
   }

- (IBAction)aliBuyButtonPressed:(UIButton *)sender {
}





#pragma mark InAppPurchaseManage Delegate

-(void)initPurchase
{
    
    mPurchaseManage = [[InAppPurchaseManage alloc] init];
    mPurchaseManage.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPurchaseButtonEnable) name:@"purchaseProductInfoReceived" object:nil];
    
    
}

- (void)setPurchaseButtonEnable {
    //    leftItem.enabled = YES;
    self.navigationItem.leftBarButtonItem.enabled = YES;
}


- (void)purchaseAdButtonPressed {
       self.navigationItem.leftBarButtonItem.enabled = NO;
    [self performSelector:@selector(setPurchaseButtonEnable) withObject:nil afterDelay:5];
    [mPurchaseManage loadStore];
}
- (void)purchasedSuccessfully:(BOOL)wasSuccessful {
    
    self.navigationItem.leftBarButtonItem=nil;
    self.gadView.hidden=YES;
}
- (void)checkPurchaseHidden {
    if ([AppUtil productWasPurchased]) {
     
        self.navigationItem.leftBarButtonItem = nil;
    } else  {
        }
}








//- (IBAction)tuijian:(UIButton *)sender {
//    
//    
//    if (appHandleView)
//    {
//        [appHandleView showHandleViewDetailPage];
//        appBadge.hidden = YES;
//        
//        [MobClick beginLogPageView:@"jingpintuijian"];
//    }
//
//    
//    
//}
//- (IBAction)goToTaoBao:(UIButton *)sender {
//    
//    
//    if (taoBaoHandView)
//    {
//        [taoBaoHandView showHandleViewDetailPage];
//         taoBaoBadge.hidden = YES;
//        [MobClick beginLogPageView:@"taobao"];
//    }
//
//    
//    
//}
//-(void)initUMAPP
//{
//
//
//
//
//    appHandleView = [[UMUFPHandleView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-88, 32, 88) appKey:nil slotId:APPSLOTID currentViewController:self];
//    appHandleView.delegate = (id<UMUFPHandleViewDelegate>)self;
//    
//    // 集成方式二：入口完全自定义（可以是button，也可以是tableview的cell等），广告未加载完成或加载失败时，点击自定义的入口，广告详情页不会被展示，failedToPackUpHandleView 回调方法被触发
//    
//  //  [self setupSelfDefinedEntrance];
//    
//    [appHandleView requestPromoterDataInBackground];
//
//
//    appBadge = [[UMUFPBadgeView alloc] initWithFrame:CGRectMake(_appTuiJIanButton.bounds.size.width-24, 16, 22, 22)];
//    appBadge.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
//    [_appTuiJIanButton addSubview:appBadge];
//    appBadge.hidden = YES;
//
//
//
//
//}
//-(void)initUMTaoBao
//{
//
//    taoBaoHandView = [[UMUFPHandleView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-88, 32, 88) appKey:nil slotId:TAOBAOSLOTID currentViewController:self];
//    taoBaoHandView.delegate = (id<UMUFPHandleViewDelegate>)self;
//    
//    // 集成方式二：入口完全自定义（可以是button，也可以是tableview的cell等），广告未加载完成或加载失败时，点击自定义的入口，广告详情页不会被展示，failedToPackUpHandleView 回调方法被触发
//    
//    //  [self setupSelfDefinedEntrance];
//    
//    [taoBaoHandView requestPromoterDataInBackground];
//
//
//    
//    taoBaoBadge = [[UMUFPBadgeView alloc] initWithFrame:CGRectMake(_taoBaoButton.bounds.size.width-10, -5, 18, 18)];
//    taoBaoBadge.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
//    [_taoBaoButton addSubview:taoBaoBadge];
//    taoBaoBadge.hidden = YES;
//
//
//
//}
//
//#pragma mark - UMUFPHandleView delegate methods
//
//// 取广告列表数据完成
//
//- (void)didLoadDataFinished:(UMUFPHandleView *)_handleView
//{
//    
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    
//    if ([_handleView isEqual:appHandleView]) {
//        [appBadge updateNewMessageCount:_handleView.mNewPromoterCount];
//    }else
//    {
//    
//        [taoBaoBadge updateNewMessageCount:_handleView.mNewPromoterCount];
//    }
//    
//    
//}


//按钮动画

- (void)animateFauxBounceWithView:(UIButton *)view idx:(NSUInteger)idx initDelay:(CGFloat)initDelay {
    
    initDelay=0.1f;
    
    [UIView animateWithDuration:0.2f
                          delay:(initDelay + idx*0.1f)
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseInOut
                     animations:^{
                         view.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1);
                         view.alpha = 1;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.1 animations:^{
                             view.layer.transform = CATransform3DIdentity;
                         }];
                     }];
}


//-(void)goToWidgetPage
//{
//
//
//    EZAddQuickContractVC *widget=[self.storyboard instantiateViewControllerWithIdentifier:@"EZAddQuickContractVC"];
//    
//    [self.navigationController pushViewController:widget animated:YES];
//    
//    
//    
//
//
//
//
//}
@end
