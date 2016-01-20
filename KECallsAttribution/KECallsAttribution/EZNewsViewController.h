//
//  EZNewsViewController.h
//  TestPushNews
//
//  Created by 赵 进喜 on 15/7/20.
//  Copyright (c) 2015年 everzones. All rights reserved.
//




#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@import GoogleMobileAds;
typedef enum : NSUInteger {
    EZNewsVCTypeFromClick,//列表页
    EZNewsVCTypeFromPush,//详细页
    
} EZNewsVCType;





@interface EZNewsViewController : UIViewController<UIWebViewDelegate,GADBannerViewDelegate,UIScrollViewDelegate,GADAdLoaderDelegate,GADNativeAppInstallAdLoaderDelegate> {


    float lastY;


}
@property(assign,nonatomic)EZNewsVCType currentType;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property(copy,nonatomic)NSString *currentUrl;
@property(copy,nonatomic)NSString *pageCat;
@property (weak, nonatomic) IBOutlet GADBannerView *mBanner;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *mLoading;
@property(strong,nonatomic)GADAdLoader *mAdLoader;
@property(strong,nonatomic)GADNativeAppInstallAdView *mAdmobNativeView;
- (IBAction)popToLast:(UIButton *)sender;
@end





