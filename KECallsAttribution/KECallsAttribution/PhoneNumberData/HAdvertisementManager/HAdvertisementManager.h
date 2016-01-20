//
//  HAdvertisementManager.h
//  
//
//  Created by 余胜民 on 15/11/29.
//
//

#import <Foundation/Foundation.h>
#import "GDTMobBannerView.h"
#import "GDTMobInterstitial.h"
@import GoogleMobileAds;

typedef NS_ENUM(NSUInteger, platformType) {
    kDefaultType, //没有广告
    kAdmobType, //谷歌广告
    kGDTmobType,//广电通广告
};

@interface HAdvertisementManager : NSObject

@property (nonatomic, assign) platformType platformType;
//banner
@property (nonatomic, strong) GADBannerView *admobBannerView;
@property (nonatomic, strong) GDTMobBannerView *gdtmobBannerView;
//interstitial
@property (nonatomic, strong) GADInterstitial *admobInterstitial;
@property (nonatomic, strong) GDTMobInterstitial *gdtmobInterstitial;

+ (instancetype)shareManager;

//展示banner广告
- (void)showBannerToParentView:(UIView *)parentView
            rootViewController:(UIViewController *)rootViewController
                bannerAdUnitID:(NSString *)bannerAdUnitID
                        appKey:(NSString *)appKey
                   placementID:(NSString *)placementID;

//展示全屏广告
- (void)showInterstitialToRootViewController:(UIViewController *)rootViewController
                        interstitialAdUnitID:(NSString *)interstitialAdUnitID
                                      appKey:(NSString *)appKey
                                 placementID:(NSString *)placementID;


@end
