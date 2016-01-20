//
//  EZProtectCheckResultVC.h
//  MyContacts
//
//  Created by 赵 进喜 on 15/1/30.
//  Copyright (c) 2015年 everzones. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
@import GoogleMobileAds;
#import "CWStarRateView.h"
#import "AdwoAdSDK.h"
#import "EZNativeView.h"

@interface EZProtectCheckResultVC : UITableViewController<GADAdLoaderDelegate,GADNativeAppInstallAdLoaderDelegate,GADBannerViewDelegate>
{

    NSString *currentKey;
    
    NSString *currentSign;

    BOOL check_result;
    
    float adcellHeight;
    
    BOOL  isadderror;
    
}

@property (weak, nonatomic) IBOutlet EZNativeView *mAdwoNativeView;

@property(strong,nonatomic)NSString *inquiryPhoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *markLbl;
@property (weak, nonatomic) IBOutlet UILabel *infoLbl;
@property(strong,nonatomic)Reachability *mReach;

@property (weak, nonatomic) IBOutlet UIButton *markButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;


@property (weak, nonatomic) IBOutlet UILabel *loadingLbl;
@property (weak, nonatomic) IBOutlet UIImageView *resultImageView;
@property(strong,nonatomic)GADAdLoader *mAdLoader;
@property(strong,nonatomic)GADNativeAppInstallAdView *mAdmobNativeView;
@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (weak, nonatomic)  UITableViewCell *adCell;

@property(copy,nonatomic)NSString *databaseFilePath;
@property(copy,nonatomic)NSString *query;

- (IBAction)markNumber:(UIButton *)sender;
- (IBAction)backButtonPressed:(UIButton *)sender;
@end
