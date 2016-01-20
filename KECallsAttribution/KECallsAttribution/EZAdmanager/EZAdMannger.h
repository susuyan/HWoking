//
//  EZAdMannger.h
//  TestAd
//
//  Created by 赵 进喜 on 15/7/22.
//  Copyright (c) 2015年 everzones. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EZAdView.h"
@interface EZAdManager : NSObject
+(EZAdManager *)shareAdManager;
@property(strong,nonatomic)EZAdView *adView;
@property(copy,nonatomic)NSString *app_url;
-(void)showInView:(UIView *)mView;
-(void)hideAdView;

-(void)setAdInfo:(NSDictionary *)item withImageCompletion:(void(^)(UIImage *image))completion;
@end
