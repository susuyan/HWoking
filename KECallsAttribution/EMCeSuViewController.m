//
//  EMCeSuViewController.m
//  NetMonitor
//
//  Created by dyw on 14/12/4.
//  Copyright (c) 2014年 Everzones. All rights reserved.
//

#import "EMCeSuViewController.h"
#import "MeterView.h"
#import "WMGaugeView.h"

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

//#import "GADBannerView.h"
@import GoogleMobileAds;
@interface EMCeSuViewController ()<NSURLConnectionDelegate,NSURLConnectionDataDelegate,GADBannerViewDelegate>
{
    MeterView *meterView;
    NSMutableData *tempData;
    long long dataLength;
    long long currentLength;
    NSDate *date1;
    NSDate *date2;
    NSDate *date3;
    NSTimeInterval time1;
    NSTimeInterval time2;
    NSMutableArray *dataArray;
    NSMutableArray *timeArray;
    UILabel *labelTime;
    UILabel *labelMin;
    UILabel *labelMax;
    UILabel *labelMiddle;
    GADBannerView *bannerView;
}

@end

@implementation EMCeSuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *tittle=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    [tittle setBackgroundColor:[UIColor clearColor]];
    [tittle setTextColor:[UIColor whiteColor]];
    tittle.text=@"网络测速";
    [tittle setTextAlignment:NSTextAlignmentCenter];
    [tittle setFont:[UIFont systemFontOfSize:24]];
    self.navigationItem.titleView=tittle;

    [self addGaugeView];
    //[self saveData];
    [self addBannerView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"cesu"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"cesu"];
}
-(void)addBannerView{
    bannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50-64, SCREEN_WIDTH, 50)];
    bannerView.adUnitID = ADMOB_APP_ID;
    bannerView.rootViewController = self;
    bannerView.delegate = self;
    [bannerView loadRequest:[GADRequest request]];
    [self.view addSubview:bannerView];
}
-(void)addGaugeView{
//    labelTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 40)];
//    [self.view addSubview:labelTime];
//    labelMiddle = [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 150, 40)];
//    [self.view addSubview:labelMiddle];
//    labelTime.text = @"网络延迟:0s";
//    labelMiddle.text = @"下载速度:0KB/s";
    
    

//    meterView = [[MeterView alloc] initWithFrame:CGRectMake(50, 20, 222, 210)];
//    [self.view addSubview:meterView];
//   meterView.backgroundColor = [UIColor whiteColor];
////  meterView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"biaopan"]];
//    meterView.startAngle = 3.0 * M_PI / 4.0;
//    meterView.textLabel.text = @"kb/s";
//    meterView.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:12.0];
//    meterView.minNumber = 0;
//    meterView.maxNumber = 2000;
//    meterView.lineWidth = 1;
//    meterView.minorTickLength = 15.0;
//    meterView.needle.width = 2.0;
//   // meterView.needle.tintColor = [UIColor brownColor];
//    meterView.textLabel.textColor = [UIColor colorWithRed:0/255.0 green:160/255.0 blue:255/255.0 alpha:1.0];
//    //  meterView.textLabel.textColor = [UIColor clearColor];
     _gaugeView2 = [[WMGaugeView alloc] initWithFrame:CGRectMake(50, 120, 222, 210)];
    _gaugeView2.backgroundColor = [UIColor clearColor];
    _gaugeView2.maxValue = 2000.0;
    _gaugeView2.scaleDivisions = 10;
    _gaugeView2.scaleSubdivisions = 5;
    _gaugeView2.scaleStartAngle = 45;
    _gaugeView2.scaleEndAngle = 315;
    _gaugeView2.innerBackgroundStyle = WMGaugeViewInnerBackgroundStyleFlat;
    _gaugeView2.showScaleShadow = NO;
    _gaugeView2.scaleFont = [UIFont fontWithName:@"AvenirNext-UltraLight" size:0.065];
    _gaugeView2.scalesubdivisionsaligment = WMGaugeViewSubdivisionsAlignmentCenter;
    _gaugeView2.scaleSubdivisionsWidth = 0.002;
    _gaugeView2.scaleSubdivisionsLength = 0.04;
    _gaugeView2.scaleDivisionsWidth = 0.007;
    _gaugeView2.scaleDivisionsLength = 0.07;
    _gaugeView2.needleStyle = WMGaugeViewNeedleStyleFlatThin;
    _gaugeView2.needleWidth = 0.012;
    _gaugeView2.needleHeight = 0.4;
    _gaugeView2.needleScrewStyle = WMGaugeViewNeedleScrewStylePlain;
    _gaugeView2.needleScrewRadius = 0.05;
    [self.view addSubview:_gaugeView2];
//
//    [NSTimer scheduledTimerWithTimeInterval:2.0
//                                     target:self
//                                   selector:@selector(gaugeUpdateTimer:)
//                                   userInfo:nil
//                                    repeats:YES];
}
- (IBAction)btn_CeSu:(UIButton *)sender {
    [self saveData];
}
- (IBAction)btn_Back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveData{
    dataArray = [[NSMutableArray alloc] init];
    timeArray = [[NSMutableArray alloc] init];
    //    @"http://f.hiphotos.baidu.com/image/pic/item/fd039245d688d43f5a0f54f37f1ed21b0ef43b09.jpg",@"http://img1.gtimg.com/9/905/90559/9055926_640x640_225.jpg",@"http://www.sinaimg.cn/dy/slidenews/68_img/2014_46/57338_85260_483447.jpg",@"http://tupian.enterdesk.com/2013/lxy/06/22/1.jpg.680.510.jpg",@"http://img.ivsky.com/img/bizhi/pre/201411/13/the_book_of_life-006.jpg";
    NSArray *arr = @[@"http://121.199.62.75/i/weicall/key_ios_gq.zip",@"http://121.199.62.75/i/weicall/iso_key_wlrs.zip",@"http://121.199.62.75/i/weicall/iso_key_sd.zip",@"http://121.199.62.75/i/weicall/iso_key_qz.zip",@"http://121.199.62.75/i/weicall/iso_key_yyrs.zip",@"http://121.199.62.75/i/weicall/key_ios_gq.zip",@"http://121.199.62.75/i/weicall/iso_key_wlrs.zip",@"http://121.199.62.75/i/weicall/iso_key_sd.zip",@"http://121.199.62.75/i/weicall/iso_key_qz.zip",@"http://121.199.62.75/i/weicall/iso_key_yyrs.zip"];
    NSString *temp = [[NSUserDefaults standardUserDefaults] objectForKey:@"num"];
    if (temp == nil) {
        temp = @"1";
    }
    NSLog(@"%@",temp);
    for (int i = 0; i < [arr count]; i++) {
        date1 = [NSDate date];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?a=%@",arr[i],temp]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        // NSURLRequestReloadRevalidatingCacheData
        // NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:0];
        [NSURLConnection connectionWithRequest:request delegate:self];
        
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",[temp integerValue] +1] forKey:@"num"];
    
    
    
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    date2 = [NSDate date];
    tempData = [[NSMutableData alloc] init];
    dataLength = 0;
    dataLength = [response expectedContentLength];
    currentLength = 0;
    
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [tempData appendData:data];
    currentLength += [data length];
    
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    date3 = [NSDate date];
    time1 = [date2 timeIntervalSinceDate:date1];
    time2 = [date3 timeIntervalSinceDate:date2];
   
    float kbData = dataLength/(float)1024;
    float flow = kbData/time2;
    NSLog(@"%f",time1);
    _gaugeView2.value = flow;
    
    
    [dataArray addObject:[NSString stringWithFormat:@"%f",flow]];
    [timeArray addObject:[NSString stringWithFormat:@"%f",time1]];
    //    NSLog(@"dataLength = %lld",dataLength);
    //    NSLog(@"kbData = %f",kbData);
    //    NSLog(@"time2 = %f",time2);
    //    NSLog(@"flow = %f",flow);
    if ([dataArray count] == 10) {
        for (int i = 0; i < [dataArray count] -1; i++) {
            for (int j = 0; j < [dataArray count] -1- i; j++) {
                if ([dataArray[j] floatValue] > [dataArray[j+1] floatValue]) {
                    //                [dataArray replaceObjectAtIndex:i withObject:dataArray[j]];
                    //                [dataArray replaceObjectAtIndex:j withObject:dataArray[i]];
                    NSString *temp ;
                    temp = dataArray[j];
                    dataArray[j] = dataArray[j+1];
                    dataArray[j+1] = temp;
                    
                    
                }
            }
        }
        NSLog(@"%@",dataArray);
        
        float middle =[dataArray[0] floatValue] + [dataArray[1] floatValue]+ [dataArray[2] floatValue]+[dataArray[3] floatValue]+[dataArray[4] floatValue]+ [dataArray[5] floatValue]+ [dataArray[6] floatValue]+ [dataArray[7] floatValue]+ [dataArray[8] floatValue]+ [dataArray[9] floatValue];
        //        NSLog(@"%f",middle);
        float time = [timeArray[0] floatValue] + [timeArray[1] floatValue]+ [timeArray[2] floatValue]+[timeArray[3] floatValue]+[timeArray[4] floatValue] + [timeArray[5] floatValue] + [timeArray[6] floatValue] + [timeArray[7] floatValue] + [timeArray[8] floatValue] + [timeArray[9] floatValue];
        NSLog(@"time = %f",time);
          self.timeLabel.text = [NSString stringWithFormat:@"%.2fs",time/10];
       
        _gaugeView2.value = middle/10;
        if (middle/10 >= 2000) {
            [self saveData];
        }else{
            if (middle/10>=1000) {
                self.speedLabel.text = [NSString stringWithFormat:@"%.2fM/s",middle/10/1000];
            }else{
                self.speedLabel.text = [NSString stringWithFormat:@"%.fKB/s",middle/10];
            }
            NSString *time = [self dateFromNow];
//            for (NSMutableDictionary *dic in self.singleton.flowArray) {
//                if ([[dic objectForKey:@"time"] isEqualToString:time]) {
//                    [dic setObject:labelMiddle.text forKey:@"flow"];
//                }else{
//                   
//
//                }
//            }
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            
            [dic setObject:time forKey:@"time"];
            [dic setObject:[NSString stringWithFormat:@"下载速度:%@",self.speedLabel.text] forKey:@"flow"];
            }
        }
        
        
}



-(NSString *)dateFromNow{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd hh:mm:ss"];
    NSString *newtime = [formatter stringFromDate:[NSDate date]];
    return newtime;
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

@end
