//
//  HAdvertisementManager.m
//  TrueCaller
//
//  Created by EverZones on 16/1/15.
//  Copyright © 2016年 susuyan. All rights reserved.
//

#import "HAdvertisementManager.h"

@interface HAdvertisementManager()<GADBannerViewDelegate,GADInterstitialDelegate>


//rootcontroller
@property (nonatomic, strong) UIViewController *mobRootController;

@end

@implementation HAdvertisementManager

+ (instancetype)shareManager {
    static HAdvertisementManager *manager;
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
           
            
        }
            break;
        case kGDTmobType:
        {
           
        }
            break;
    }
    
}
#pragma mark - private
- (void)initPlatformType {
    //NSString *platformTypeString = [[NSUserDefaults standardUserDefaults] objectForKey:@"ad_banner"];

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





#pragma mark - Admob Banner Delegate
- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"admob banner error: %@",error);
}


#pragma mark - Admob Interstitial Delegate
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    [ad presentFromRootViewController:self.mobRootController];
}


- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"Admob Interstitial error:%@",error);
}



@end
