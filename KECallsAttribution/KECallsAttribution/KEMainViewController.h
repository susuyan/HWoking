//
//  KEMainViewController.h
//  KECallsAttribution
//
//  Created by lichenWang on 14-1-4.
//  Copyright (c) 2014年 KERNEL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KEMainViewController : UIViewController
//- (IBAction)tuijian:(UIButton *)sender;
//- (IBAction)biaoqing:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *gadView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *hideView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//@property (weak, nonatomic) IBOutlet UIButton *taoBaoButton;
//- (IBAction)goToWallPapper:(UIButton *)sender;
- (IBAction)removeAds:(UIButton *)sender;
//- (IBAction)aliBuyButtonPressed:(UIButton *)sender;
//- (IBAction)goToTaoBao:(UIButton *)sender;



//button

@property (weak, nonatomic) IBOutlet UIButton *guishudi;
@property (weak, nonatomic) IBOutlet UIButton *tongxunlu;
@property (weak, nonatomic) IBOutlet UIButton *changyong;
@property (weak, nonatomic) IBOutlet UIButton *youbian;
@property (weak, nonatomic) IBOutlet UIButton *ipdianhua;
@property (weak, nonatomic) IBOutlet UIButton *saomabijia;
@property (weak, nonatomic) IBOutlet UIButton *shenghuohuangye;
@property (weak, nonatomic) IBOutlet UIButton *kuaijielianxiren;
@property (weak, nonatomic) IBOutlet UIButton *wannianli;
//@property (weak, nonatomic) IBOutlet UIButton *chepai;
@property (weak, nonatomic) IBOutlet UIButton *heimingdan;
@property (weak, nonatomic) IBOutlet UIButton *kaixinyike;

//@property (weak, nonatomic) IBOutlet UIButton *baoxiuchaxun;
@property (weak, nonatomic) IBOutlet UIButton *findPeople;
//@property (weak, nonatomic) IBOutlet UIButton *myTuijianButton;
@property (weak, nonatomic) IBOutlet UIButton *haomabaoguang;
@property (weak, nonatomic) IBOutlet UIButton *wangshnagyingyeting;
//@property (weak, nonatomic) IBOutlet UIButton *callWidget;
//
//
//@property (weak, nonatomic) IBOutlet UIButton *appTuiJIanButton;
@end
