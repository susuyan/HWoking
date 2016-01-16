//
//  ImageViewController.h
//  wallpapers
//
//  Created by 赵 进喜 on 13-9-23.
//  Copyright (c) 2013年 everzones. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNetEngine.h"
@import GoogleMobileAds;
@interface ImageViewController : UIViewController<UIScrollViewDelegate,GADInterstitialDelegate>
{
    NSString *fullPath;
    NSString *thumbDanli;
      int imageIndex;

      NSMutableArray *mItems;

    UIScrollView *mScrollView;
    
    //UIButton *backButton;
    
    UIImageView *bottomBar;

    UIImageView *currentImageview;
    BOOL scrollToTop;
    
    float contentoffsetX;
    
    UIImageView *lockImageView;
    UIImageView *menuImageview;
    
    GADInterstitial *interstitial_;
    
    NSTimer *timer;
    MyNetEngine *mNetEngine;
    
    BOOL pre_lock;
    BOOL pre_menu;

    NSDictionary *myItem;
    
    UIButton *collect_btn;
}
@property(strong,nonatomic)NSString *channelId;
-(id)initWithItems:(NSMutableArray *)items AndImageIndex:(int)index;
-(void)setInfo:(NSDictionary *)item WithChannelId:(NSString *)channel;
@end
