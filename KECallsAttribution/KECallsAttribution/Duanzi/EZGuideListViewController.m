//
//  EZGuideListViewController.m
//  GameGuide
//
//  Created by lichenWang on 13-12-9.
//  Copyright (c) 2013年 EverZones. All rights reserved.
//

#import "EZGuideListViewController.h"
#import "Reachability.h"
#import "KEProgressHUD.h"
#import "EZGuideCell.h"
#import "EZGuide.h"
#import "UIImageView+WebCache.h"
@import GoogleMobileAds;
#import "UMSocial.h"
#import "GDTMobBannerView.h"
typedef NS_ENUM(NSInteger, EZURLRequestState){
    EZURLRequestRefreshState,
    EZURLRequestLoadMoreState
};
@interface EZGuideListViewController ()<NSURLConnectionDelegate,GADBannerViewDelegate,GDTMobBannerViewDelegate>
@property (nonatomic, strong)NSDictionary * dictionary;
@property (nonatomic)NSInteger currentPage;
@property (nonatomic, strong)NSMutableData * mutableData;
@property (nonatomic, strong)NSURLConnection * connectionRefresh;
@property (nonatomic, strong)NSURLConnection * connectionLoadMore;
@property (nonatomic, strong)NSMutableArray * array;
@property (nonatomic)BOOL isFistRefesh;
@property (nonatomic, strong)GADBannerView * gadBannerView;
@property (nonatomic, strong)GDTMobBannerView *gdtBannerView;
@end

@implementation EZGuideListViewController

/*
 
 获取当前网络环境 并进行判断
 
 */
- (void)dealloc
{
    _gdtBannerView.delegate=nil;
    _gdtBannerView.currentViewController=nil;
    _gdtBannerView=nil;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
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

    
    
    
//    self.gadBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
//    self.gadBannerView.adUnitID = ADMOB_APP_ID;
//    self.gadBannerView.rootViewController = self;
//    self.gadBannerView.delegate  = self;
//    [self.gadView addSubview:self.gadBannerView];
//    [self.gadBannerView loadRequest:[GADRequest request]];
    
    
    
    
    
    
    
    self.array = [NSMutableArray array];
    self.mutableData = [NSMutableData data];
    self.dictionary = [NSDictionary dictionary];//初始化数组和字典
    [self.pullTableView registerNib:[UINib nibWithNibName:@"EZGuideCell" bundle:nil] forCellReuseIdentifier:@"Cell"];//注册自定义cell
   // [self.view setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"cellBackground"]]];
    
    
    self.pullTableView.pullArrowImage = [UIImage imageNamed:@"blackArrow"];
    self.pullTableView.pullBackgroundColor = [UIColor whiteColor];
    self.pullTableView.pullTextColor = [UIColor blackColor];
    self.pullTableView.delegate=self;
    if(!self.pullTableView.pullTableIsRefreshing) {
        [self refesh];
    }
    
    
    
//    BOOL isPassed = [[NSUserDefaults standardUserDefaults] boolForKey:@"isPassed"];
//    if (!isPassed) {
        self.pullTableView.tableHeaderView=nil;
//    }
}
- (void)refesh{
    self.isFistRefesh = YES;
    self.pullTableView.pullTableIsRefreshing = YES;
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:0.5f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.pullTableView reloadData];
    NSLog(@"网络已连接");//执行网络正常时的代码
    
    [MobClick beginLogPageView:@"duanzi"];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setPullTableView:nil];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.connectionLoadMore cancel];
    [self.connectionRefresh cancel];
    
    [MobClick endLogPageView:@"duanzi"];
    
}

- (void) refreshTable
{
    /*
     
     Code to actually refresh goes here.
     
     */
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [self networkAnomaly];
        self.pullTableView.pullTableIsRefreshing = NO;
    }else{
        self.currentPage = 1;
        [self sendRequest:EZURLRequestRefreshState];
        [self.connectionLoadMore cancel];
        self.pullTableView.pullLastRefreshDate = [NSDate date];
        self.pullTableView.pullTableIsLoadingMore = NO;
    }

}
- (void)networkAnomaly{
    [KEProgressHUD mBProgressHUD:self.view :@"网络异常,请检查网络连接!"];
}
- (void) loadMoreDataToTable
{
    /*
     
     Code to actually load more data goes here.
     
     */
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [self networkAnomaly];
        self.pullTableView.pullTableIsLoadingMore = NO;
    }else{
        self.currentPage++;
        [self sendRequest:EZURLRequestLoadMoreState];
        [self.connectionRefresh cancel];
        self.pullTableView.pullTableIsRefreshing = NO;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EZGuide * guide = self.array[indexPath.row];
    return [EZGuideCell heightForMessage:guide];
}
- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:0.5f];
}
- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:0.5f];
}
- (void)sendRequest:(EZURLRequestState)uRLRequestState{
    switch (uRLRequestState) {
        case 0://下拉刷新最新的数据
        {
            NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://93app.com/bunengmei/threads.php?id=com.93app.shenhufu&type=joke&tab=new&page=%d&email=a@a.com&version=%@",self.currentPage,VERSION]];
            NSLog(@"++++++%@",url);
            NSURLRequest * request = [NSURLRequest requestWithURL:url];
            self.connectionRefresh = [NSURLConnection connectionWithRequest:request delegate:self];
        }
            break;
        case 1://加载更多的数据
        {
            NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://93app.com/bunengmei/threads.php?id=com.93app.shenhufu&type=joke&tab=new&page=%d&email=a@a.com&version=%@",self.currentPage,VERSION]];
            NSLog(@"========%@",url);
            NSURLRequest * request = [NSURLRequest requestWithURL:url];
            self.connectionLoadMore = [NSURLConnection connectionWithRequest:request delegate:self];
        }
            break;
        default:
            break;
    }
}
- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response
{
    
    if(self.mutableData.length){
        self.mutableData.length = 0;
    }
}

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data
{
    NSLog(@"data.length:%lu",(unsigned long)data.length);
    if(data){
        [self.mutableData appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (self.mutableData) {
        if (connection == self.connectionRefresh) {
            if (self.array.count) {
                [self.array removeAllObjects];
            }
            [self dataSwitchObject:self.mutableData];
            self.pullTableView.pullTableIsRefreshing = NO;
        }else if (connection == self.connectionLoadMore) {
            [self dataSwitchObject:self.mutableData];
            self.pullTableView.pullTableIsLoadingMore = NO;
        }
        [self.pullTableView reloadData];
    }else{
        self.pullTableView.pullTableIsRefreshing = NO;
    }
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
}

- (void)dataSwitchObject:(NSData*)data{//将请求到的数据解析为对象，并且加入到数组self.searchArray
    self.dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if([self.dictionary[@"status"] integerValue] == 1){
        [self.dictionary[@"thread_list"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            EZGuide * guide = [[EZGuide alloc] init];
            guide.userName = obj[@"the_user"][@"nickname"];
            guide.headPortrait = obj[@"avatar_info"][@"thu_url"];
            guide.content = obj[@"detail"];
            guide.dateInformation = obj[@"create_time"];
            [self.array addObject:guide];
        }];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    EZGuideCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.guide =self.array[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    EZGuide *guide=self.array[indexPath.row];
    [self shareAction:guide.content];


}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)goToDuanZi:(UITapGestureRecognizer *)sender {
    
    
    
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://itunes.apple.com/app/id804456296"]];
    
    
}

- (void)shareAction:(NSString *)text {
   
    NSString * content = [NSString stringWithFormat:@"%@ \r\n  %@。\r\n%@",text,[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"],[NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@?mt=8",APPLE_ID]];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMENG_APP_SHARE_ID
                                      shareText:content
                                     shareImage:nil
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,nil]
                                       delegate:nil];
    
    [UMSocialData defaultData].extConfig.title = @"手机归属地";
}

@end
