//
//  EZNativeView.h
//  RingTones
//
//  Created by 赵 进喜 on 15/7/29.
//  Copyright (c) 2015年 zmj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdwoAdSDK.h"
typedef void(^AdShowBlock)(void);
@interface EZNativeView : UIImageView<AWAdViewDelegate>
{

    NSDictionary *adInfo;
    
    
    float mScale;
    
    
    UIImageView *mIcon;
    
    UILabel *mTitle;
    
    
    UILabel *mSummry;
    

     AdShowBlock adShowBlock;
   
}
@property(assign,nonatomic)CGSize adViewSize;

@property (nonatomic) NSDate *loadAdLastTime;


- (void)loadAWAdWithBlock:(void(^)(void))block;

- (void)loadAdwoAD;
@end
