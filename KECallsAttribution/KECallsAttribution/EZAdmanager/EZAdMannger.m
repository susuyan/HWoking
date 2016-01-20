//
//  EZAdManager.m
//  TestAd
//
//  Created by 赵 进喜 on 15/7/22.
//  Copyright (c) 2015年 everzones. All rights reserved.
//

#import "EZAdMannger.h"
static EZAdManager *adManager;
@implementation EZAdManager

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

+(EZAdManager *)shareAdManager
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        
        
        adManager=[[EZAdManager alloc]init];
        
        [adManager initViews];
        
    });
    
    
    
    return adManager;
    
    
}
-(void)initViews
{


    

    _adView=[[[NSBundle mainBundle]loadNibNamed:@"EZAdView" owner:0 options:nil]objectAtIndex:0];
    
    
   
    
    
    _adView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);

    
    
     __weak  EZAdManager *blockself=(EZAdManager *)self;
    
    _adView.tapBlock=^{
        [blockself jumpToAppStore];
    
    };




}

-(void)showInView:(UIView *)mView
{





    [_adView showInView:mView];



}
-(void)hideAdView
{



    [_adView hideView];



}


-(void)setAdInfo:(NSDictionary *)item withImageCompletion:(void (^)(UIImage *))completion
{

    NSString *img_url=[item objectForKey:@"img_url"];
    
    


    if (img_url==nil||[img_url isEqualToString:@""]) {
        return;
    }


    _app_url=[item objectForKey:@"url"];


    [self downloadImageWithUrl:img_url withImageCompletion:completion];


    
}

-(void)downloadImageWithUrl:(NSString *)url withImageCompletion:(void (^)(UIImage *))completion
{






    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    
    
    
        NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
        
        
            UIImage *image=[UIImage imageWithData:data];
            
            
            if (image) {
                
                
                
               

                [self.adView.adImageView setImage:image];
                
                completion(image);

            }
            
            
        
        
        });
        
        
    
    
    
    });






}
-(void)jumpToAppStore
{


 [[UIApplication sharedApplication]openURL:[NSURL URLWithString:_app_url]];


}
@end
