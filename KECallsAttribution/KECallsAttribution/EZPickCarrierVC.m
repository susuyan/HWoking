//
//  EZPickCarrierVC.m
//  KECallsAttribution
//
//  Created by 赵 进喜 on 14/11/24.
//  Copyright (c) 2014年 K.BLOCK. All rights reserved.
//

#import "EZPickCarrierVC.h"
#import "EZSmsInqueryVC.h"
//#import "EZChargeViewController.h"
@import GoogleMobileAds;
#import "GDTMobBannerView.h"
@interface EZPickCarrierVC ()<GADBannerViewDelegate,GDTMobBannerViewDelegate>
@property (nonatomic, strong)GADBannerView * gadBannerView;
@property (nonatomic, strong)GDTMobBannerView *gdtBannerView;
@end

@implementation EZPickCarrierVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString *path=[[NSBundle mainBundle]pathForResource:@"smsinfo" ofType:@"plist"];
    
    
    allInfos=[NSArray arrayWithContentsOfFile:path];
    
    
    
    self.gadView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    
    self.tableView.tableFooterView=self.gadView;
    
    NSString *type=[[NSUserDefaults standardUserDefaults]objectForKey:@"adtype"];
    
    if ([type isEqualToString:@"gdt"]) {
        
        
        
        _gdtBannerView = [[GDTMobBannerView alloc] initWithFrame:CGRectMake(0, 0, GDTMOB_AD_SUGGEST_SIZE_320x50.width,
                                                                            
                                                                            GDTMOB_AD_SUGGEST_SIZE_320x50.height) appkey:GDT_APP_ID
                                                     placementId:GDT_BANNER_APP_ID];
        
        
        
        _gdtBannerView.delegate = self; // 设置Delegate
        _gdtBannerView.currentViewController = self; //设置当前的ViewController
        _gdtBannerView.interval = 30; //【可选】设置刷新频率;默认30秒
        _gdtBannerView.isGpsOn = YES; //【可选】开启GPS定位;默认关闭
        _gdtBannerView.showCloseBtn = YES; //【可选】展⽰示关闭按钮;默认显⽰示
        _gdtBannerView.isAnimationOn = YES; //【可选】开启banner轮播和展现时的动画效果;默认开启
        _gdtBannerView.userInteractionEnabled=YES;
        [self.gadView addSubview:_gdtBannerView]; //添加到当前的view中
        [_gdtBannerView loadAdAndShow]; //加载⼲⼴广告并展⽰示
        
    }else
    {
        
        self.gadBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        self.gadBannerView.adUnitID = ADMOB_APP_ID;
        self.gadBannerView.rootViewController = self;
        self.gadBannerView.delegate  = self;
        
        
        
        [self.gadView addSubview:self.gadBannerView];
        
        
        [self.gadBannerView loadRequest:[GADRequest request]];
        
        
        
    }
    

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [MobClick beginLogPageView:@"yingyeting"];
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"yingyeting"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    
    UIButton *button=(UIButton *)sender;
    
    
//    if (button.tag==3) {
//        
//        
//        
////        EZChargeViewController *web=[segue destinationViewController];
////       
////        web.strUrl=@"http:www.baidu.com";
//        
//        
//        
//        
//        
//        
//        
//        
//        
//        
//    }else
//    {
    
    
        EZSmsInqueryVC *sms=[segue destinationViewController];
        
        
        
        
        NSArray *infos=[allInfos objectAtIndex:button.tag];
        
        
        
        sms.mItems=infos;
        
        
        NSString *num;
        
        if (button.tag==0) {
            num=@"10086";
        }else if (button.tag==1)
        {
            num=@"10010";
            
        }else
        {
            
            num=@"10001";
            
        }
        
        sms.carrierNum=num;

    
  //  }
    
    
    
    NSString *title;
    
    switch (button.tag) {
        case 0:
            title=@"移动";
            break;
        case 1:
            title=@"联通";
            break;
            
        case 2:
            title=@"电信";
            break;
            
        case 3:
            title=@"虚拟运营商";
            break;
            
            
        default:
            break;
    }
    
    
    
    sms.title=title;

    
    
    
    
    
    
}


- (IBAction)buttonPressed:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
