//
//  EZMainLocalVC.h
//  KECallsAttribution
//
//  Created by 赵 进喜 on 14/12/8.
//  Copyright (c) 2014年 K.BLOCK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SVProgressHUD.h"
@import GoogleMobileAds;
@interface EZMainLocalVC : UITableViewController<CLLocationManagerDelegate,UITextFieldDelegate,GADBannerViewDelegate>
{

    double mlng;
    
    double mlat;
    
    NSString *category;



}

- (IBAction)hideKeyboard:(UITapGestureRecognizer *)sender;
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (nonatomic, strong) CLLocationManager * locationManager;
@property (nonatomic, strong) CLGeocoder*  currentLocationGeocoder;
@property (nonatomic, copy) NSString * cityName;
@property (weak, nonatomic) IBOutlet UIButton *cityButton;

@property (weak, nonatomic) IBOutlet UIView *bannerContainer;
- (IBAction)selectSearchCat:(UIButton *)sender;
- (IBAction)backButtonPressed:(UIButton *)sender;
- (IBAction)searchAction:(UIButton *)sender;
@end
