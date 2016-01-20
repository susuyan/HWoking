//
//  EZNativeView.m
//  RingTones
//
//  Created by 赵 进喜 on 15/7/29.
//  Copyright (c) 2015年 zmj. All rights reserved.
//





#import "EZNativeView.h"
#import "UIImageView+WebCache.h"
#define ADWO_PUBLISH_ID_        @"0d1a575886cd4425a1d5e14cb091c753"
static NSString* const adwoResponseErrorInfoList[] = {
    @"操作成功",
    @"广告初始化失败",
    @"当前广告已调用了加载接口",
    @"不该为空的参数为空",
    @"参数值非法",
    @"非法广告对象句柄",
    @"代理为空或adwoGetBaseViewController方法没实现",
    @"非法的广告对象句柄引用计数",
    @"意料之外的错误",
    @"广告请求太过频繁",
    @"广告加载失败",
    @"全屏广告已经展示过",
    @"全屏广告还没准备好来展示",
    @"全屏广告资源破损",
    @"开屏全屏广告正在请求",
    @"当前全屏已设置为自动展示",
    @"当前事件触发型广告已被禁用",
    @"没找到相应合法尺寸的事件触发型广告",
    
    @"服务器繁忙",
    @"当前没有广告",
    @"未知请求错误",
    @"PID不存在",
    @"PID未被激活",
    @"请求数据有问题",
    @"接收到的数据有问题",
    @"当前IP下广告已经投放完",
    @"当前广告都已经投放完",
    @"没有低优先级广告",
    @"开发者在Adwo官网注册的Bundle ID与当前应用的Bundle ID不一致",
    @"服务器响应出错",
    @"设备当前没连网络，或网络信号不好",
    @"请求URL出错"
};

@implementation EZNativeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/




-(id)initWithFrame:(CGRect)frame{
    
    if (self=[super initWithFrame:frame]) {
        
        
        self.hidden=YES;
       
        
        self.adViewSize=CGSizeMake(SCREEN_WIDTH, 70);
        
        
       // self.frame=CGRectMake(0, 0, self.adViewSize.width, self.adViewSize.height);
        
        
        [self initSubViews];
        
        
    }
    
    
    return self;
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
       // self.hidden = YES;
        self.adViewSize=CGSizeMake(SCREEN_WIDTH, 70);
        [self initSubViews];
    }
    return self;
}
-(void)initSubViews {
   // [self setBackgroundColor:[UIColor redColor]];
    
    
    float iconwidth=50;
    
    
    float iconheight=50;
    
    
    mIcon=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, iconwidth, iconheight)];
    mIcon.image=[UIImage imageNamed:@"dazahui"];
    
    
//    mIcon.layer.masksToBounds = YES;
//    mIcon.layer.cornerRadius = 25;
    
    
    [self addSubview:mIcon];
    
        
    mTitle=[[UILabel alloc]initWithFrame:CGRectMake(mIcon.frame.size.width+10+15, 10, self.adViewSize.width-mIcon.frame.size.width-10-10-15, 21)];
    [mTitle setFont:[UIFont systemFontOfSize:17]];
    
    mTitle.text=@"   ";
    
    [self addSubview:mTitle];
    
    
    mSummry=[[UILabel alloc]initWithFrame:CGRectMake(mTitle.frame.origin.x, 10+21+10, mTitle.frame.size.width, 21)];
    [mSummry setFont:[UIFont systemFontOfSize:14]];
    mSummry.numberOfLines=0;
   
    
    
    [self addSubview:mSummry];
    

}


- (void)loadAWAdWithBlock:(void (^)(void))block {
    adShowBlock = block;
    UIView *adView = AdwoAdCreateImplantAd(ADWO_PUBLISH_ID_, YES, self, nil,ADWOSDK_IMAD_SHOW_FORM_COMMON);
    NSTimeInterval interval = AdwoAdGetImplantRequestInterval();
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"loadAdLastTime"];
    if (!AdwoAdLoadImplantAd(adView,&interval)) {
        NSLog(@"原生广告加载失败，由于：%@", adwoResponseErrorInfoList[AdwoAdGetLatestErrorCode()]);
        if (!IS_IOS8) {
            // 移除原生广告对象
            if(adView != nil) {
                AdwoAdRemoveAndDestroyImplantAd(adView);
                adView = nil;
            }
        }else {
            AdwoAdRemoveAndDestroyImplantAd(adView);
            if (!adView) {
                adView = nil;
            }
        }
    }else {
        NSLog(@"加载成功");
    }

    NSLog(@"%d",AdwoAdGetLatestErrorCode());
    
}

- (void)loadAdwoAD {
    
    UIView *adView = AdwoAdCreateImplantAd(ADWO_PUBLISH_ID_, YES, self, nil,ADWOSDK_IMAD_SHOW_FORM_COMMON);
    NSTimeInterval interval=AdwoAdGetImplantRequestInterval();
    if (!AdwoAdLoadImplantAd(adView,&interval)) {
        NSLog(@"原生广告加载失败，由于：%@", adwoResponseErrorInfoList[AdwoAdGetLatestErrorCode()]);
        if (!IS_IOS8) {
            // 移除原生广告对象
            if(adView != nil) {
                AdwoAdRemoveAndDestroyImplantAd(adView);
                adView = nil;
            }
        }else {
            AdwoAdRemoveAndDestroyImplantAd(adView);
            if (adView != nil) {
                
                adView = nil;
            }
        }
    }else{
        NSLog(@"加载成功");
    }
    
    NSLog(@"%d",AdwoAdGetLatestErrorCode());
}
#pragma mark -Adwo Ad delegates
- (UIViewController*)adwoGetBaseViewController {
    
    return self.window.rootViewController;
    
    
}
- (void)adwoAdViewDidFailToLoadAd:(UIView*)adView {
    NSLog(@"原生广告请求失败，由于：%@", adwoResponseErrorInfoList[AdwoAdGetLatestErrorCode()]);
}

- (void)adwoAdViewDidLoadAd:(UIView*)adView {
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"loadAdLastTime"];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    //获取AdInfo中的广告信息
    //将adInfo转化为Dictionary格式，方便提取
    NSString *str = AdwoAdGetAdInfo(adView);
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSLog(@"adinfo is :%@",dic);
    
    //开发者在这里做图片提取与视图模板组织工作
    
    
    //    // 原生广告尺寸默认是当前屏幕大小，这里开发者可以根据需求自己设置广告的尺寸
    //    CGSize size = CGSizeMake(200, 200);
    //
    //    // 然后根据当前尺寸，可以设定植入性广告的位置
    //    adView.frame = CGRectMake((self.view.frame.size.width - size.width) * 0.5f, self.view.frame.size.height - size.height - 50.0f, size.width, size.height);
    
    adInfo = dic;
    mTitle.text = adInfo[@"title"];
    mSummry.text = adInfo[@"summary"];
    
    NSString *strIcon = adInfo[@"icon"];
    
    [mIcon sd_setImageWithURL:[NSURL URLWithString:strIcon] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon%d",arc4random()%5+1]]];
    
    
    
    adView.frame = self.frame;
    

    
    self.userInteractionEnabled = YES;
    
    // 现在可以将其进行展示了。当然，展示也可稍后再做
    AdwoAdShowImplantAd(adView, self);
    
    // 激活原生广告
    AdwoAdImplantAdActivate(adView);
    self.hidden=NO;
    
//    adShowBlock();
}


//-(id)initWithInfo:(NSDictionary *)info{
//
//    if (self=[super init]) {
//        
//        
//        
//        float width=[info[@"imgwidth"]floatValue];
//        float height=[info[@"imgheight"]floatValue];
//        
//        mScale = SCREEN_WIDTH/width;
//        
//        
//        adInfo=info;
//        
//        self.adViewSize=[EZNativeView getAdSizeWithSize:width height:height];
//        
//        
//        self.frame=CGRectMake(0, 0, self.adViewSize.width, self.adViewSize.height);
//        
//        
//        [self initSubViews];
//        
//        
//        
//    }
//
//
//    return self;
//
//}
//
//-(void)initSubViews
//{
//
//
//    
//    float iconwidth=[adInfo[@"iconwidth"]floatValue];
//    
//    
//    float iconheight=[adInfo[@"iconheight"]floatValue];
//    
//    
//    NSString *stricon=adInfo[@"icon"];
//    
//    
//    
//    
//
//    UIImageView *icon=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mScale*iconwidth, mScale*iconheight)];
//    
//    
//    [icon sd_setImageWithURL:[NSURL URLWithString:stricon] placeholderImage:nil];
//    
//    [self addSubview:icon];
//    
//    
//    
//    NSString *imgurl=adInfo[@"img"];
//    
//    
//    [self sd_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:nil];
//    
//    
//    UILabel *titlelbl=[[UILabel alloc]initWithFrame:CGRectMake(icon.frame.size.width+10, 10, self.adViewSize.width-icon.frame.size.width-10-10, 21)];
//    [titlelbl setFont:[UIFont systemFontOfSize:20]];
//    
//    titlelbl.text=adInfo[@"title"];
//    
//    [self addSubview:titlelbl];
//
//
//    UILabel *summaryLbl=[[UILabel alloc]initWithFrame:CGRectMake(titlelbl.frame.origin.x, 10+21+10, titlelbl.frame.size.width, 40)];
//    [summaryLbl setFont:[UIFont systemFontOfSize:14]];
//    summaryLbl.numberOfLines=0;
//    summaryLbl.text=adInfo[@"summary"];
//    
//    
//    [self addSubview:summaryLbl];
//
//
//    
//    
//    UIButton *downloadButton=[UIButton buttonWithType:UIButtonTypeCustom];
//    
//    downloadButton.frame=CGRectMake(self.adViewSize.width-10-80, self.adViewSize.height-10-25, 80, 25);
//    [downloadButton setTitle:adInfo[@"ext"][@"button"] forState:UIControlStateNormal];
//    [downloadButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
//    [downloadButton setBackgroundColor:[UIColor colorWithRed:114.0f/255.0f green:190.0f/255.0f blue:85.0f/255.0f alpha:1]];
//    
//    [self addSubview:downloadButton];
//    
//    
//    
//    UILabel *descLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, self.adViewSize.height-25-10-10-21, self.adViewSize.width-10-10, 21)];
//    
//    descLbl.text=adInfo[@"desc"];
//    
//    [self addSubview:descLbl];
//    
//    
//    
//
//}
//
//
//+(CGSize)getAdSizeWithSize:(float)width  height:(float)height
//{
//
//
//    float mwidth=SCREEN_WIDTH;
//    
//    
//    
//    float mheight=(SCREEN_WIDTH/width)*height;
//    
//    
//    
//    
//    return CGSizeMake(mwidth, mheight);
//    
//    
//
//}
//

@end
