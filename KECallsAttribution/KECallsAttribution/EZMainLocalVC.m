//
//  EZMainLocalVC.m
//  KECallsAttribution
//
//  Created by 赵 进喜 on 14/12/8.
//  Copyright (c) 2014年 K.BLOCK. All rights reserved.
//

#import "EZMainLocalVC.h"
#import "ECLocalLifeViewController.h"
#import "GDTMobBannerView.h"
@interface EZMainLocalVC ()<GDTMobBannerViewDelegate>

@end

@implementation EZMainLocalVC
- (void)dealloc
{
    _currentLocationGeocoder=nil;
    _locationManager=nil;
    
    [SVProgressHUD dismiss];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [MobClick beginLogPageView:@"locallife"];
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"locallife"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cityName=@"北京";
    
    category=nil;
    [self getCurrentLocation];
    [self loadBanner];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//
//    // Return the number of rows in the section.
//    return 0;
//}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    
    return 0;

}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==0) {
        
        return 5;
        
    }else if (section==2) {
        return 80;
    }
    
    return 20;

}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)hideKeyboard:(UITapGestureRecognizer *)sender {
    
    
    [self.view endEditing:YES];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    if ([self.searchText isFirstResponder]) {
        [self.searchText resignFirstResponder];
    }


}


-(void)getCurrentLocation
{
    
    [SVProgressHUD showWithStatus:@"正在定位..."];
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    
    
    
    
    
    self.currentLocationGeocoder = [[CLGeocoder alloc] init];
    self.locationManager.delegate = self;
    
    
    if (IS_IOS8) {
        
        
        //[self.locationManager requestAlwaysAuthorization];
        [self.locationManager requestWhenInUseAuthorization];
        
        
    }
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    self.locationManager.distanceFilter = 1000.0f;//用来控制定位服务更新频率。单位是“米”
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;//这个属性用来控制定位精度，精度越高耗电量越大。
    
    
    
    
    
    
    [self.locationManager startUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [SVProgressHUD dismiss];
}
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    [manager stopUpdatingLocation];
    CLLocationDegrees longtitude = newLocation.coordinate.longitude;
    CLLocationDegrees latitude = newLocation.coordinate.latitude;
    [self.currentLocationGeocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark* placeMark = [placemarks objectAtIndex:0];
        
        
        NSLog(@"%@_________%@",placeMark.locality,placeMark.administrativeArea);
        NSString * cityName;
        if (placeMark.locality == NULL) {
            cityName = placeMark.administrativeArea;
        }else{
            cityName = placeMark.locality;
        }
        
        
        //        if (IS_IOS8) {
        //
        //
        //
        //            if ([cityName rangeOfString:@"市辖区"].location!=NSNotFound) {
        //
        //
        //                 cityName = placeMark.administrativeArea;
        //
        //            }
        //
        //
        //
        //        }
        
        cityName=[cityName stringByReplacingOccurrencesOfString:@"市辖区" withString:@""];
        
        cityName=[cityName stringByReplacingOccurrencesOfString:@"特別行政區" withString:@""];
        
        cityName = [cityName stringByReplacingOccurrencesOfString:@"市" withString:@""];
        
        
        [SVProgressHUD dismiss];
        
        mlng=longtitude;
        
        mlat=latitude;
        
        self.cityName=cityName;
        
       // [self getDataWithLng:longtitude Lat:latitude City:cityName];
        // [SVProgressHUD showWithStatus:@"正在加载..."];
        [self.cityButton setTitle:self.cityName forState:UIControlStateNormal];
    }];
}


#ifdef __IPHONE_8_0
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    switch (status) {
            
        case kCLAuthorizationStatusNotDetermined:
            
            if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                
                [self.locationManager requestWhenInUseAuthorization];
                
            }
            
            break;
            
        default:  
            
            break;  
            
    }  
    
    
}  
#endif

//搜索
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
//    mPage=1;
//    
//    [mEngine searchBusinessWithCity:self.cityName Query:_searchText.text Category:category Type:type Lng:mlng Lat:mlat Page:mPage];
//    
//    [SVProgressHUD showWithStatus:@"正在加载..."];
    
    
    
    ECLocalLifeViewController *local=[self.storyboard instantiateViewControllerWithIdentifier:@"ECLocalLifeViewController"];
  //  local.category=category;
    local.mlat=mlat;
    local.mlng=mlng;
    local.cityName=self.cityName;
    local.searchKeyword=self.searchText.text;
    
    [self.navigationController pushViewController:local animated:YES];

    
    
    [self.view endEditing:YES];
    
    return YES;
}


- (IBAction)selectSearchCat:(UIButton *)sender {
    
    //旅游  scenic
    //家装
    ECLocalLifeViewController *local=[self.storyboard instantiateViewControllerWithIdentifier:@"ECLocalLifeViewController"];
    
    //
    switch (sender.tag) {
        case 0:
            category=@"美食";//food_u@3x
            break;
            
        case 1:
            category=@"休闲娱乐";//bar_o@2x
            break;
            
        case 2:
            category=@"酒店";//hotel_o@2x
            break;
            
        case 3:
            category=@"购物";//shopping_o@2x
            break;
            
        case 4:
            category=@"丽人";//beauty
            break;
        case 5:
            category=@"结婚";//marry
            break;
            
        case 6:
            category=@"亲子";//baby亲子
            break;
        case 7:
            category=@"运动健身";
            break;
            
        case 8:
            category=@"爱车";//汽车服务
            break;
            
        case 9:
            category=@"生活服务";
            break;
        case 10:
            category=@"景点郊游";//
            break;

        case 11:
            category=@"家装";
            break;

        case 12:
            category=@"电影院";
            break;

        case 13:
            category=@"火锅";
            break;

        case 14:
            category=@"KTV";
            break;

        case 15:
            category=@"咖啡";
            break;
       
            
            
            
        default:
            break;
    }
    
    
    local.category=category;
    local.mlat=mlat;
    local.mlng=mlng;
    local.cityName=self.cityName;
   // local.searchKeyword=self.searchText.text;
    
    [self.navigationController pushViewController:local animated:YES];
    
    
    
    
}

- (IBAction)backButtonPressed:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)searchAction:(UIButton *)sender {
    
    
    ECLocalLifeViewController *local=[self.storyboard instantiateViewControllerWithIdentifier:@"ECLocalLifeViewController"];
    //  local.category=category;
    local.mlat=mlat;
    local.mlng=mlng;
    local.cityName=self.cityName;
    local.searchKeyword=self.searchText.text;
    
    [self.navigationController pushViewController:local animated:YES];
    
    
    
    [self.view endEditing:YES];

}
-(void)loadBanner
{
    
    
    
    NSString *type=[[NSUserDefaults standardUserDefaults]objectForKey:@"adtype"];
    
    if ([type isEqualToString:@"gdt"]) {
        
        
        
       GDTMobBannerView *   _gdtBannerView = [[GDTMobBannerView alloc] initWithFrame:CGRectMake(0, 0, GDTMOB_AD_SUGGEST_SIZE_320x50.width,
                                                                            
                                                                            GDTMOB_AD_SUGGEST_SIZE_320x50.height) appkey:GDT_APP_ID
                                                     placementId:GDT_BANNER_APP_ID];
        
        
        
        _gdtBannerView.delegate = self; // 设置Delegate
        _gdtBannerView.currentViewController = self; //设置当前的ViewController
        _gdtBannerView.interval = 30; //【可选】设置刷新频率;默认30秒
        _gdtBannerView.isGpsOn = YES; //【可选】开启GPS定位;默认关闭
        _gdtBannerView.showCloseBtn = YES; //【可选】展⽰示关闭按钮;默认显⽰示
        _gdtBannerView.isAnimationOn = YES; //【可选】开启banner轮播和展现时的动画效果;默认开启
        [self.self.bannerContainer addSubview:_gdtBannerView]; //添加到当前的view中
        [_gdtBannerView loadAdAndShow]; //加载⼲⼴广告并展⽰示
        
    }else
    {
        
        GADBannerView *mBannerView=[[GADBannerView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
        [self.bannerContainer addSubview:mBannerView];
        mBannerView.adUnitID = ADMOB_APP_ID;
        
        mBannerView.rootViewController = self;
        mBannerView.delegate  = self;
        
        [mBannerView loadRequest:[GADRequest request]];
        
        
        
    }

    
    
    
  


}
@end
