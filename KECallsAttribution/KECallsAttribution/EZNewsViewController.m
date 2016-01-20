//
//  EZNewsViewController.m
//  TestPushNews
//
//  Created by 赵 进喜 on 15/7/20.
//  Copyright (c) 2015年 everzones. All rights reserved.
//

#import "EZNewsViewController.h"
#import "CWStarRateView.h"
@interface EZNewsViewController ()

@end

@implementation EZNewsViewController

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNav];
    
    if (_currentType==EZNewsVCTypeFromPush) {
    
        
        
        
//        UIImageView *ad=[[UIImageView alloc]initWithFrame:CGRectMake(0, -240, SCREEN_WIDTH, 100)];
//        ad.image=[UIImage imageNamed:@"testad1"];
//        [self.webView.scrollView addSubview:ad];
      
//        _mAdmobNativeView=(GADNativeAppInstallAdView*)[[[NSBundle mainBundle]loadNibNamed:@"EZAdmobNativeView" owner:nil  options:nil]objectAtIndex:0];
        
        
        
               [self loadNativeAds];

        
    }else{
        
            self.webView.scrollView.delegate=self;
            
            [self loadBanner];

        
        
    }
    
    
    
    [self loadWithUrl:self.currentUrl];
    
    
}
-(void)initNav
{


    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    
    backButton.frame=CGRectMake(0, 0, 32, 32);
    
    
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(popToLast:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    
    UIButton *closeButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    closeButton.frame=CGRectMake(0, 0, 32, 32);
    //[closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"nav_close"] forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(backToRoot) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *closeItem=[[UIBarButtonItem alloc]initWithCustomView:closeButton];
    
    self.navigationItem.leftBarButtonItems=@[backItem,closeItem];

    
    

}
-(void)loadWithUrl:(NSString *)strUrl
{


    NSURL *url=[NSURL URLWithString:strUrl];
    
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    
    


}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{

    
   
    
    
    if (_currentType==EZNewsVCTypeFromPush) {
        self.navigationItem.title=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        
        NSDictionary * titelDictionary = @{UITextAttributeTextColor:[UIColor whiteColor],
                                           UITextAttributeTextShadowColor:[UIColor whiteColor],
                                           UITextAttributeFont:[UIFont boldSystemFontOfSize:15]};
        [self.navigationController.navigationBar setTitleTextAttributes:titelDictionary];
    }
    

    
  
    
    
    
    NSLog(@"%@",request.URL.absoluteString);
    
//    if (![[request.URL absoluteString]isEqualToString:self.currentUrl]) {
//        
//        
//        return NO;
//        
//    }
    
    return YES;
    
   


}
- (void)webViewDidStartLoad:(UIWebView *)webView
{

 [self.mLoading startAnimating];

}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{


    [self.mLoading stopAnimating];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)popToLast:(UIButton *)sender {
    
    
    if (self.currentType==EZNewsVCTypeFromClick) {
        
        if ([self.webView canGoBack]) {
            
            [self.webView goBack];
            
        }else {
        
         //   [self.navigationController popViewControllerAnimated:YES];
        
            [self backToRoot];
        }
        
        
    }else {
        
            //判断类别，搞笑娱乐还是其他,其他直接关掉页面
        
        if ([_pageCat isEqualToString:@"toutiao"]||[_pageCat isEqualToString:@"xiaoshuo"]||[_pageCat isEqualToString:@"qiubai"]) {
            
            EZNewsViewController *news=[self.storyboard instantiateViewControllerWithIdentifier:@"EZNewsViewController"];
            
            news.currentType = EZNewsVCTypeFromClick;
            
            
            if ([_pageCat isEqualToString:@"toutiao"]) {
                
                
                
                news.currentUrl=@"http://m.toutiao.com/";
                
                news.navigationItem.title=@"今日头条";
                
                
            }else if ([_pageCat isEqualToString:@"xiaoshuo"]) {
            
            
                news.currentUrl=@"http://m.shenmaxiaoshuo.com/";
                
                news.navigationItem.title=@"神马小说";
            
            
            
            }else if ([_pageCat isEqualToString:@"qiubai"]) {
            
                
                news.currentUrl=@"http://m.qiushibaike.com/";
                
                news.navigationItem.title=@"糗事百科";
            
            }
            
            
            
            
            NSMutableArray *temp=[self.navigationController.viewControllers mutableCopy];
            
            
            [temp replaceObjectAtIndex:temp.count-1 withObject:news];
            
            [self.navigationController setViewControllers:temp];

            
        }else {
        
        
            //[self.navigationController popViewControllerAnimated:YES];
        
            [self backToRoot];
        
        }
        
        
    }
    
    
}
-(void)backToRoot{

    if (self.navigationController.viewControllers.count>1) {
        
         [self.navigationController popViewControllerAnimated:YES];
        
    }else {
    
     [self dismissViewControllerAnimated:YES completion:nil];
    
    
    }
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (_currentType==EZNewsVCTypeFromClick) {
        
        
        if (scrollView.contentOffset.y-lastY>=20) {
            
            
            [UIView animateWithDuration:0.3 animations:^{
                
                
                
                _mBanner.transform=CGAffineTransformMakeTranslation(0, 50);
                
            } completion:^(BOOL finished) {
                
                if (finished) {
                    
                    
                    lastY=scrollView.contentOffset.y;
                    
                }
                
            }];
            
            
        }else if (lastY-scrollView.contentOffset.y>=20) {
        
            [UIView animateWithDuration:0.3 animations:^{
                
                _mBanner.transform=CGAffineTransformIdentity;
                
            } completion:^(BOOL finished) {
                
                if (finished) {
                    
                    
                    lastY=scrollView.contentOffset.y;
                    
                }
                
            }];
        
        }
        
     
    }

}

-(void)loadBanner {

    _mBanner.hidden=NO;

    GADBannerView *mBannerView=[[GADBannerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    [self.mBanner addSubview:mBannerView];
    mBannerView.adUnitID           = ADMOB_APP_ID;

    mBannerView.rootViewController = self;
    mBannerView.delegate = self;

    [mBannerView loadRequest:[GADRequest request]];




}
-(void)loadNativeAds {

    
 //临时用admob banner
    
    GADBannerView *mBannerView=[[GADBannerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    
    mBannerView.adUnitID           = ADMOB_APP_ID;
    
    mBannerView.rootViewController = self;
    mBannerView.delegate = self;
    
    [mBannerView loadRequest:[GADRequest request]];
    
    mBannerView.frame=CGRectMake(0, -50, SCREEN_WIDTH, 50);
    
    self.webView.scrollView.contentInset=UIEdgeInsetsMake(50, 0, 0, 0);
    
    [self.webView.scrollView addSubview:mBannerView];

    [self.webView.scrollView setContentOffset:CGPointMake(0, -50)];
    
    

//临时注释：等id下来后打开

//    self.mAdLoader=[[GADAdLoader alloc]initWithAdUnitID:@"ca-app-pub-3940256099942544/3986624511" rootViewController:self adTypes:@[kGADAdLoaderAdTypeNativeAppInstall] options:@[@(GADNativeAdImageAdLoaderOptionsOrientationLandscape)]];
//
//    self.mAdLoader.delegate=self;
//   
//
//    
//    GADRequest *request=[GADRequest request];
//    
//  
//    
//    [self.mAdLoader loadRequest:request];
    
    
    




}
-(void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(GADRequestError *)error {



}
- (void)adLoader:(GADAdLoader *)adLoader
didReceiveNativeAppInstallAd:(GADNativeAppInstallAd *)nativeAppInstallAd{

    
    if (_mAdmobNativeView==nil) {
        _mAdmobNativeView=(GADNativeAppInstallAdView*)[[[NSBundle mainBundle]loadNibNamed:@"TestAdmob" owner:nil options:nil]objectAtIndex:0];
        
        _mAdmobNativeView.frame=CGRectMake(0, -_mAdmobNativeView.frame.size.height, SCREEN_WIDTH, _mAdmobNativeView.frame.size.height);
        
        self.webView.scrollView.contentInset=UIEdgeInsetsMake(_mAdmobNativeView.frame.size.height, 0, 0, 0);
        
        [self.webView.scrollView addSubview:_mAdmobNativeView];

    }
    
    
    
    NSLog(@"%@",((GADNativeAdImage*)[nativeAppInstallAd.images firstObject]).imageURL);

    _mAdmobNativeView.nativeAppInstallAd=nativeAppInstallAd;
    
    _mAdmobNativeView.iconView.image=nativeAppInstallAd.icon.image;

    _mAdmobNativeView.headlineView.text=nativeAppInstallAd.headline;
    
    _mAdmobNativeView.bodyView.text=nativeAppInstallAd.body;
    
//    _mAdmobNativeView.imageView.image=((GADNativeAdImage *)[nativeAppInstallAd.images firstObject]).image;
//    
//    _mAdmobNativeView.priceView.text=nativeAppInstallAd.price;
//    
//    _mAdmobNativeView.storeView.text=nativeAppInstallAd.store;
//    
//    [_mAdmobNativeView.callToActionView setTitle:nativeAppInstallAd.callToAction forState:UIControlStateNormal];
//    
//    ((CWStarRateView*)_mAdmobNativeView.starRatingView).scorePercent=[nativeAppInstallAd.starRating floatValue]/5.0f;
    
    [self.webView.scrollView setContentOffset:CGPointMake(0, -self.mAdmobNativeView.frame.size.height)];

}
@end
