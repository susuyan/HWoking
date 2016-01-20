//
//  HAdvertisementManager.h
//  TrueCaller
//
//  Created by EverZones on 16/1/15.
//  Copyright © 2016年 susuyan. All rights reserved.
//

#import <Foundation/Foundation.h>

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

//interstitial
@property (nonatomic, strong) GADInterstitial *admobInterstitial;

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
