//
//  ImageViewController.m
//  wallpapers
//
//  Created by 赵 进喜 on 13-9-23.
//  Copyright (c) 2013年 everzones. All rights reserved.
//

#import "ImageViewController.h"
#import "UIImageView+WebCache.h"

#import "PXAlertView.h"


@interface ImageViewController ()<GADBannerViewDelegate>

@property (strong,nonatomic) GADBannerView *bannerView;

@end

@implementation ImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithItems:(NSMutableArray *)items AndImageIndex:(int)index
{

    if (self=[super init]) {
        
        
        mItems=items;
        imageIndex=index;
        
        
    }

    return self;

}
- (void)dealloc
{
    mScrollView =nil;
    //[backButton release];
    bottomBar=nil;
    //[currentImageview release];
    lockImageView =nil;
    menuImageview =nil;
    [mNetEngine closeAllConnections];
    //[interstitial_ release];
    myItem =nil;
   // [timer release];
   
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (IS_IOS7) {
        self.edgesForExtendedLayout=UIRectEdgeAll;
    }
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
//    MelonTabBarController *melon = [[MelonTabBarController alloc]init];
//    [melon customSetTabBarHidden:NO];
    self.navigationController.navigationBar.hidden=YES;
    [MobClick beginLogPageView:@"bizhi"];
    
}
-(void)viewWillDisappear:(BOOL)animated
{

    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"bizhi"];
    
//    self.navigationController.navigationBarHidden=NO;
//    [[UIApplication sharedApplication]setStatusBarHidden:NO];
}
////隐藏状态栏的方法
//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
//    //UIStatusBarStyleLightContent = 1; //白色文字，深色背景时使用
//}
//- (BOOL)prefersStatusBarHidden
//{
//    return YES; //返回NO表示要显示，返回YES将hiden
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
 
    
    
    //隐藏状态栏，方法调用
//    [self setNeedsStatusBarAppearanceUpdate];
//    //隐藏效果
//    [UIView animateWithDuration:0.5 animations:^{
//        [self setNeedsStatusBarAppearanceUpdate];
//    }];
    
//    MelonTabBarController *melon = [[MelonTabBarController alloc]init];
//    [melon customSetTabBarHidden:NO];
    
   

    [self.view setBackgroundColor:[UIColor blackColor]];
    [self initScrollView];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideAndShowNavBottom:)];
    [mScrollView addGestureRecognizer:tap];
    

    
    for (int i=0; i<mItems.count; i++) {
        
        
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(i*320, 20, 320, SCREEN_HEIGHT)];
        
        
        imageView.tag=i+1;
        
        //imageView.image=[UIImage imageNamed:@"default_bg"];
        NSString *thumb=[[mItems objectAtIndex:i]valueForKey:@"thu_path"];
        [imageView setImageWithURL:[NSURL URLWithString:thumb]];

        
        [mScrollView addSubview:imageView];
        
       
        
    }
    
    [self loadImageWithIndex:imageIndex];
    
    int imageHeight;
//    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
//        imageHeight=SCREEN_HEIGHT;
//    }else
//    {
        imageHeight=SCREEN_HEIGHT-20;
    
   // }
   // NSLog(@"%f",[[[UIDevice currentDevice]systemVersion]floatValue]);
    
    lockImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 20, 320, imageHeight)];
    lockImageView.image=[UIImage imageNamed:@"lock_bg"];
    [self.view addSubview:lockImageView];
    lockImageView.hidden=YES;
    
    
    menuImageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 20, 320, imageHeight)];
    menuImageview.image=[UIImage imageNamed:@"menu_bg"];
    [self.view addSubview:menuImageview];
    menuImageview.hidden=YES;

    if (SCREEN_HEIGHT==480) {
        
        
        lockImageView.image=[UIImage imageNamed:@"lock_bg_960"];
        menuImageview.image=[UIImage imageNamed:@"menu_bg_960"];
        
    }
    
    
    mNetEngine=[[MyNetEngine alloc]init];
   // timer=  [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timeFullAd) userInfo:nil repeats:YES];

    if (IS_IOS7) {
        mScrollView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    }
    [self initNavAndBottomBar];
	// Do any additional setup after loading the view.
}

-(void)loadImageWithIndex:(int)index
{
    //NSLog(@"%@",mItems);
    if (index<mItems.count) {
        currentImageview=(UIImageView *)[mScrollView viewWithTag:index+1];
        
        fullPath=[[mItems objectAtIndex:index]valueForKey:@"full_path"];
        thumbDanli = [[mItems objectAtIndex:index]valueForKey:@"thu_path"];
        
        NSLog(@"full = %@ , thu = %@",fullPath,thumbDanli);
        [currentImageview setImageWithURL:[NSURL URLWithString:fullPath] placeholderImage:currentImageview.image];
    }
}
-(void)initScrollView
{

    mScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT-20)];
    
    [self.view addSubview:mScrollView];
    mScrollView.contentSize=CGSizeMake(320*mItems.count, SCREEN_HEIGHT-20);
    if (IS_IOS7) {
        mScrollView.frame=CGRectMake(0, 0, 320, SCREEN_HEIGHT);
        mScrollView.contentSize=CGSizeMake(320*mItems.count, SCREEN_HEIGHT);
       
    }

    mScrollView.scrollEnabled=YES;
    mScrollView.pagingEnabled=YES;
    mScrollView.userInteractionEnabled=YES;
    mScrollView.delegate=self;
    mScrollView.contentOffset=CGPointMake(imageIndex*320,0);
    mScrollView.showsHorizontalScrollIndicator=NO;

}
-(void)initNavAndBottomBar
{
    //backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    //[backButton setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    //[backButton setBackgroundImage:[UIImage imageNamed:@"back_button_pressed"] forState:UIControlStateHighlighted];
    //backButton.frame=CGRectMake(10, 10, 38, 38);
    //[backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:backButton];
    /* GadBanner */
    self.bannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    if (IS_IOS7) {
        _bannerView.frame = CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50);
    }
    self.bannerView.adUnitID = ADMOB_APP_ID;
    self.bannerView.rootViewController = self;
    self.bannerView.delegate = self;
    [self.bannerView loadRequest:[GADRequest request]];
    [self.view addSubview:self.bannerView];
    
    /* bg */
    bottomBar=[[UIImageView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-20-44-49, 320, 44)];
    if (IS_IOS7) {
        bottomBar.frame=CGRectMake(0, SCREEN_HEIGHT-44-49, 320, 44);
        //backButton.frame=CGRectMake(10, 20, 38, 38);
    }

    //bottomBar.image=[UIImage imageNamed:@"dibu_bg"];
    bottomBar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bottomBar];
    bottomBar.userInteractionEnabled=YES;
    
    UIButton *preButton=[UIButton buttonWithType:UIButtonTypeCustom];
    preButton.frame=CGRectMake(15,0,45,45);
    [preButton setBackgroundImage:[UIImage imageNamed:@"back_wall"] forState:UIControlStateNormal];
    //[preButton setBackgroundImage:[UIImage imageNamed:@"left_button_pressed"] forState:UIControlStateHighlighted];
    [preButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:preButton];


//    collect_btn=[UIButton buttonWithType:UIButtonTypeCustom];
//    collect_btn.frame=CGRectMake(15+45+15,0, 45,45);
//    [collect_btn setBackgroundImage:[UIImage imageNamed:@"collect_button"] forState:UIControlStateNormal];
//    //[lockButton setBackgroundImage:[UIImage imageNamed:@"suo_button_hig"] forState:UIControlStateHighlighted];
//    [collect_btn addTarget:self action:@selector(collect_Action:) forControlEvents:UIControlEventTouchUpInside];
//    collect_btn.tag = 1011;
//    collect_btn.userInteractionEnabled = YES;
//    [bottomBar addSubview:collect_btn];
    
    
    
    UIButton *loadButton=[UIButton buttonWithType:UIButtonTypeCustom];
    loadButton.frame=CGRectMake(15+(45+15)*2,0,45,45);
    [loadButton setBackgroundImage:[UIImage imageNamed:@"save_button"] forState:UIControlStateNormal];
    [loadButton addTarget:self action:@selector(savePic) forControlEvents:UIControlEventTouchUpInside];
    //[loadButton setBackgroundImage:[UIImage imageNamed:@"save_button_pressed"] forState:UIControlStateHighlighted];
    [bottomBar addSubview:loadButton];

    UIButton *menuButton=[UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame=CGRectMake(15+(45+15)*3,0,45,45);
    [menuButton setBackgroundImage:[UIImage imageNamed:@"suo_button"] forState:UIControlStateNormal];
    //[menuButton setBackgroundImage:[UIImage imageNamed:@"ph_button_pressed"] forState:UIControlStateHighlighted];
    [menuButton addTarget:self action:@selector(showLockView) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:menuButton];
    menuButton.hidden=NO;


    UIButton *nextButton=[UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame=CGRectMake(15+(45+15)*4,0,45,45);
    [nextButton setBackgroundImage:[UIImage imageNamed:@"ph_button"] forState:UIControlStateNormal];
    //[nextButton setBackgroundImage:[UIImage imageNamed:@"right_button_pressed"] forState:UIControlStateHighlighted];
    [nextButton addTarget:self action:@selector(showMenuView) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:nextButton];
    
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"isPassed"]) {
        menuButton.hidden=YES;
        nextButton.hidden=YES;
    }
}
-(void)collect_Action:(UIButton *)sender{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    
  


}
-(void)showLockView
{
    pre_lock=!pre_lock;

    if (pre_lock) {
        
        //backButton.hidden=YES;
        bottomBar.hidden=YES;
        
        menuImageview.hidden=YES;
        lockImageView.hidden=NO;
        pre_menu=NO;
    }
    else
    {
        menuImageview.hidden=YES;
        lockImageView.hidden=YES;
        //backButton.hidden=NO;
        bottomBar.hidden=NO;
    }   
}



-(void)showMenuView
{
    pre_menu=!pre_menu;
    
    
    if (pre_menu) {
        
        //backButton.hidden=YES;
        bottomBar.hidden=YES;
        menuImageview.hidden=NO;
        lockImageView.hidden=YES;
        pre_lock=NO;
    }else
    {
        menuImageview.hidden=YES;
        lockImageView.hidden=YES;
        
        //backButton.hidden=NO;
        bottomBar.hidden=NO;
        
        
    }
    
    
    
    
}

-(void)preImage
{
    if (imageIndex!=0) {
        [UIView animateWithDuration:0.5 animations:^{
        
        
        mScrollView.contentOffset=CGPointMake(mScrollView.contentOffset.x-320, 0);
        
        
        
        }];
         
        imageIndex--;
        [self loadImageWithIndex:imageIndex];
    }
   


}
-(void)nextImage
{

    if (imageIndex!=mItems.count-1) {
        [UIView animateWithDuration:0.5 animations:^{
            
         mScrollView.contentOffset=CGPointMake(mScrollView.contentOffset.x+320, 0);
        
        }];
       
        imageIndex++;
        [self loadImageWithIndex:imageIndex];
    }

}
- (void)savePic {
    
    
    
    
	if (currentImageview.image == nil) return;
    
    
    
    
    
    
    
    UIImageWriteToSavedPhotosAlbum(currentImageview.image, nil, nil, nil);
    
    
    [PXAlertView showAlertWithTitle:@"图片已经保存到相册！"];
	
    
  
   // [self loadFullScreenAd];

}
-(void)loadFullScreenAd{
    interstitial_ = [[GADInterstitial alloc] init];
    interstitial_.delegate=self;
    interstitial_.adUnitID =ADMOB_SCREEN_APP_ID;
    [interstitial_ loadRequest:[GADRequest request]];

}
//-(void)timeFullAd
//{
//
//
//    interstitial_ = [[GADInterstitial alloc] init];
//    interstitial_.delegate=self;
//    interstitial_.adUnitID =Admob_timeFull_Id;
//    [interstitial_ loadRequest:[GADRequest request]];
//
//
//
//
//
//}
- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial
{
    
   // [[NSUserDefaults standardUserDefaults]setInteger:nowInterval forKey:@"lastPop"];
    
    [interstitial_ presentFromRootViewController:self];
    
    
}
- (void)interstitial:(GADInterstitial *)interstitial
didFailToReceiveAdWithError:(GADRequestError *)error
{
    
    
    
    
}

-(void)back
{

   
    [self.navigationController popViewControllerAnimated:YES];


}
-(void)hideAndShowNavBottom:(UITapGestureRecognizer *)tap
{

        
        bottomBar.hidden=!bottomBar.hidden;
        //backButton.hidden=!backButton.hidden;
    
   
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{

    contentoffsetX=scrollView.contentOffset.x;
    scrollToTop=NO;


}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{





}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    float newContentoffsetX=scrollView.contentOffset.x;

    
    
    if (newContentoffsetX<=0||newContentoffsetX>=scrollView.contentSize.width-320) {
        scrollToTop=YES;
    }
    else
    {
    
        scrollToTop=NO;
    
    
    }
    
    
    
    
    if (!scrollToTop) {
                
        if (newContentoffsetX>contentoffsetX) {
            imageIndex++;
            [self loadImageWithIndex:imageIndex];
            
            
        }else if (newContentoffsetX<contentoffsetX)
        {
            
            
            imageIndex--;
            [self loadImageWithIndex:imageIndex];
                       
            
            
            
        }else
        {
        
            [self loadImageWithIndex:imageIndex];
        
        
        }
        

    }
   
}
-(void)setInfo:(NSDictionary *)item WithChannelId:(NSString *)channel
{
    _channelId=channel;
    
    if (![item isKindOfClass:[NSDictionary class]]) {
        return;
    }
    myItem=item;
}
   
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
