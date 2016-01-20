//
//  HAdvertisementManager.m
//  
//
//  Created by 余胜民 on 15/11/29.
//
//

#import "HAdvertisementManager.h"
static HAdvertisementManager *manager;


@interface HAdvertisementManager()<GADBannerViewDelegate,GDTMobBannerViewDelegate,GADInterstitialDelegate,GDTMobInterstitialDelegate>


//rootcontroller
@property (nonatomic, strong) UIViewController *mobRootController;

@end

@implementation HAdvertisementManager

+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HAdvertisementManager alloc] init];
        
    });
    [manager initPlatformType];
    return manager;
}

#pragma mark - public
- (void)showBannerToParentView:(UIView *)parentView
            rootViewController:(UIViewController *)rootViewController
                bannerAdUnitID:(NSString *)bannerAdUnitID
                        appKey:(NSString *)appKey
                   placementID:(NSString *)placementID {
    
    switch (self.platformType) {
        case kDefaultType:
        {
            //什么都不用做
        }
            break;
            
        case kAdmobType:
        {
            //加载谷歌的banner广告
            [self showAdmobBannerToParentView:parentView
                           rootViewController:rootViewController
                               bannerAdUnitID:bannerAdUnitID];
        }
            break;
        case kGDTmobType:
        {
            //加载广点通的banner广告
            [self showGDTmobBannerToParentView:parentView
                            rootViewController:rootViewController
                                        appKey:appKey
                                   placementID:placementID];
        }
            break;
    }
}

- (void)showInterstitialToRootViewController:(UIViewController *)rootViewController
                        interstitialAdUnitID:(NSString *)interstitialAdUnitID
                                      appKey:(NSString *)appKey
                                 placementID:(NSString *)placementID {
    switch (self.platformType) {
        case kDefaultType:
        {
            //什么都不做
        }
            break;
        case kAdmobType:
        {
            [self showAdmobInterstitialToRootViewController:rootViewController interstitialAdUnitID:interstitialAdUnitID];
            
        }
            break;
        case kGDTmobType:
        {
            [self showGDTmobInterstitialToRootViewController:rootViewController appKey:appKey placementID:placementID];
        }
            break;
    }
    
}
#pragma mark - private
- (void)initPlatformType {
    //NSString *platformTypeString = [[NSUserDefaults standardUserDefaults] objectForKey:@"ad_banner"];
    #warning 请注意这个platformTypeString这个字段的获取
    NSString *platformTypeString = @"admob";
    if ([platformTypeString isEqualToString:@"admob"]) {
        self.platformType = kAdmobType;
    }else if ([platformTypeString isEqualToString:@"gdt"]) {
        self.platformType = kGDTmobType;
    }else {
        self.platformType = kDefaultType;
    }
    
}

//加载谷歌的banner
- (void)showAdmobBannerToParentView:(UIView *)parentView
                 rootViewController:(UIViewController *)rootViewController
                     bannerAdUnitID:(NSString *)bannerAdUnitID {
    
    self.admobBannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(0, 0, parentView.frame.size.width, 50)];
    
    self.admobBannerView.adUnitID = bannerAdUnitID;
    self.admobBannerView.rootViewController = rootViewController;
    self.admobBannerView.delegate = self;
    [parentView addSubview:self.admobBannerView];
    GADRequest *request = [GADRequest request];
    
    [self.admobBannerView loadRequest:request];
}
//加载广点通的banner
- (void)showGDTmobBannerToParentView:(UIView *)parentView
                  rootViewController:(UIViewController *)rootViewController
                              appKey:(NSString *)appKey
                         placementID:(NSString *)placementID {
    
    self.gdtmobBannerView = [[GDTMobBannerView alloc] initWithFrame:CGRectMake(0, 0, parentView.frame.size.width, 50) appkey:appKey placementId:placementID];
    [parentView addSubview:self.gdtmobBannerView];
    self.gdtmobBannerView.delegate = self;
    self.gdtmobBannerView.currentViewController = rootViewController;
    [self.gdtmobBannerView loadAdAndShow];
    
    
}

//加载谷歌的全屏
- (void)showAdmobInterstitialToRootViewController:(UIViewController *)rootViewController
                             interstitialAdUnitID:(NSString *)interstitialAdUnitID{
    
    self.admobInterstitial = [[GADInterstitial alloc] initWithAdUnitID:interstitialAdUnitID];
    self.admobInterstitial.delegate = self;
    [self.admobInterstitial loadRequest:[GADRequest request]];
    self.mobRootController = rootViewController;
}

//加载广点通的全屏
- (void)showGDTmobInterstitialToRootViewController:(UIViewController *)rootViewController
                                            appKey:(NSString *)appKey
                                       placementID:(NSString *)placementID {
    self.gdtmobInterstitial = [[GDTMobInterstitial alloc] initWithAppkey:appKey placementId:placementID];
    self.gdtmobInterstitial.delegate = self;
    [self.gdtmobInterstitial loadAd];
    self.mobRootController = rootViewController;
}

#pragma mark - Admob Banner Delegate
- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"admob banner error: %@",error);
}
#pragma mark - GDTmob Banner Delegate
- (void)bannerViewDidReceived {
    
}

- (void)bannerViewFailToReceived:(NSError *)error {
    NSLog(@"gdtmob banner error:%@",error);
}

#pragma mark - Admob Interstitial Delegate
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    [ad presentFromRootViewController:self.mobRootController];
}


- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"Admob Interstitial error:%@",error);
}


#pragma mark - GDTmob Interstitial Delegate
- (void)interstitialSuccessToLoadAd:(GDTMobInterstitial *)interstitial {
    [interstitial presentFromRootViewController:self.mobRootController];
}

- (void)interstitialFailToLoadAd:(GDTMobInterstitial *)interstitial error:(NSError *)error {
    NSLog(@"GDT Interstitial error:%@",error);
}




@end
