//
//  ECFindViewController.m
//  KECallsAttribution
//
//  Created by 赵 进喜 on 14-10-20.
//  Copyright (c) 2014年 K.BLOCK. All rights reserved.
//

#import "ECFindViewController.h"
#import "ECWeChatActivity.h"
#import "UMSocial.h"
@interface ECFindViewController ()

@end

@implementation ECFindViewController
-(void)dealloc
{

    
    _mapView.showsUserLocation=NO;
    [_mapView removeOverlay:mCircle];
    [_mapView removeFromSuperview];
    mCircle=nil;
    _mapView=nil;
   
    self.view=nil;

}
-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    
    
    [MobClick beginLogPageView:@"findpeople"];


}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
    [MobClick endLogPageView:@"findpeople"];


}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _locationManager=[[CLLocationManager alloc]init];
    _locationManager.delegate=self;
    
    if (IS_IOS8) {
        
        
        //[self.locationManager requestAlwaysAuthorization];
        [self.locationManager requestWhenInUseAuthorization];
        
        
    }

    
    
    _mapView.delegate=self;
    
    _mapView.showsUserLocation=YES;
    
   
    
    
    
    // Do any additional setup after loading the view.
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{

    if (mCircle) {
        [_mapView removeOverlay:mCircle];
        
        mCircle=nil;

    }
    
    
    
    
    CLLocation *location=userLocation.location;
    
    myLocation=location;
  
    CLLocationCoordinate2D corrdinate2D=CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude);
    
    
    [_mapView setCenterCoordinate:corrdinate2D animated:YES];
    
    
    latitude=[NSString stringWithFormat:@"%f",location.coordinate.latitude];
     longtitude=[NSString stringWithFormat:@"%f",location.coordinate.longitude];
    
    
    
    
    MKCoordinateSpan theSpan;
    //地图的范围 越小越精确
    theSpan.latitudeDelta=0.05;
    theSpan.longitudeDelta=0.05;
    MKCoordinateRegion theRegion;
    theRegion.center=corrdinate2D;
    theRegion.span=theSpan;
    [mapView setRegion:theRegion animated:YES];
    
    
   mCircle=[MKCircle circleWithCenterCoordinate:corrdinate2D radius:(1000)];
    
    [mapView addOverlay:mCircle];
    
    
    CLGeocoder *clGeocoder=[[CLGeocoder alloc]init];
    
    CLGeocodeCompletionHandler handle=^(NSArray *placemarks, NSError *error)
    {
    
        for (CLPlacemark *placeMark in placemarks) {
            
            
           
            NSDictionary *addressDic=placeMark.addressDictionary;
            
            NSLog(@"%@",addressDic);
            
            address=[[addressDic objectForKey:@"FormattedAddressLines"]objectAtIndex:0];

            _addressField.text=address;
//           _mapView.showsUserLocation = NO;
        }
    
    
    };

    [clGeocoder reverseGeocodeLocation:location completionHandler:handle];


}
//-(void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
//{
//
//    _mapView.showsUserLocation=NO;
//
//
//}
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKCircle class]])
    {
        
        
        MKCircleView* circleView = [[MKCircleView alloc] initWithOverlay:overlay];
        
        
        
        circleView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:0.2];
        circleView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        circleView.lineWidth = 0.5;
        return circleView;
    }
    
    return nil;
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

- (IBAction)backButtonPressed:(UIButton *)sender {
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)getLocation:(UIButton *)sender {
    _mapView.showsUserLocation=NO;
    
    _mapView.showsUserLocation=YES;
    
}

- (IBAction)hideKeyboard:(UITapGestureRecognizer *)sender {
    
    
    
    
    [self.view endEditing:YES];
    
    
    
}

- (IBAction)chooseMap:(UIButton *)sender {
    
    
    UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:@"发送我的GPS坐标位置给对方" delegate:self cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:@"对方使用系统自带地图", @"对方使用百度地图",@"对方使用谷歌地图",@"对方使用高德地图导航",nil];
    
    [action showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    
    NSString *url;

    switch (buttonIndex) {
        case 0:
            
            url=[NSString stringWithFormat:@"http://maps.apple.com/?q=%@",address];//系统自带地图
            
            break;
        case 1:
            url=[NSString stringWithFormat:@"baidumap://map/marker?location=%@,%@&title=我在这里&content=%@&src=%@",latitude,longtitude,address,@"手机归属地"];
            
            break;
            
        case 2:
            url=[NSString stringWithFormat:@"comgooglemaps://?center=%@,%@&zoom=14&views=transit&directionsmode=transit",latitude,longtitude];
            break;
            
        case 3:
            url=[NSString stringWithFormat:@"iosamap://navi?sourceApplication=手机归属地&backScheme=com.93app.bohaozhushou&poiid=BGVIS&lat=%@&lon=%@&dev=0&style=3",latitude,longtitude];
            break;
        case 4:
            [actionSheet dismissWithClickedButtonIndex:4 animated:YES];
            
            return;
            break;
            
    
        default:
            break;
    }

    
    url=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSString *title=@"我在这里：";
    
    
    
    
//    ECWeChatActivity *wechat=[[ECWeChatActivity alloc]initWithTitle:@"微信" withImage:[UIImage imageNamed:@"wechat"] withType:@"wechat" withBlock:^{
//    
//        NSLog(@"微信点击了");
//        
//        
//        NSString *content=[NSString stringWithFormat:@"我在这里：%@\n%@\n位置信息来自：来电归属地助手，快来下载哦：%@",url,address,@"https://itunes.apple.com/cn/app/id800391219?mt=8"];
//        
////        [UMSocialSnsService presentSnsIconSheetView:self
////                                             appKey:UMENG_APP_SHARE_ID
////                                          shareText:content
////                                         shareImage:nil
////                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,nil]
////                                           delegate:nil];
//        //[UMSocialData defaultData].extConfig.title = @"来电归属地助手";
//
//        
//        
//        
//        [[UMSocialDataService defaultDataService]postSNSWithTypes:[NSArray arrayWithObjects:UMShareToWechatSession,nil] content:content image:nil location:myLocation urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
//            
//            
//            
//            if (response.responseCode == UMSResponseCodeSuccess) {
//                NSLog(@"分享成功！");
//            }
//            
//            
//        }];
//        
//    
//    }];
//    
//    
//    ECWeChatActivity *qq=[[ECWeChatActivity alloc]initWithTitle:@"QQ" withImage:[UIImage imageNamed:@"qq"] withType:@"qq" withBlock:^{
//        
//        NSLog(@"QQ点击了");
//        
//        
//        
//        
//         NSString *content=[NSString stringWithFormat:@"我在这里：%@\n%@\n位置信息来自：来电归属地助手，快来下载哦：%@",url,address,@"https://itunes.apple.com/cn/app/id800391219?mt=8"];
//        
//        [[UMSocialDataService defaultDataService]postSNSWithTypes:[NSArray arrayWithObjects:UMShareToQQ,nil] content:content image:nil location:myLocation urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
//            
//            
//            
//            if (response.responseCode == UMSResponseCodeSuccess) {
//                NSLog(@"分享成功！");
//            }
//            
//            
//        }];
//
//        
//    }];
//
//
//    
//    
//    NSArray *activities=[[NSArray alloc]initWithObjects:wechat,qq, nil];
    
    
    UIActivityViewController *activity=[[UIActivityViewController alloc]initWithActivityItems:@[title,url,[NSString stringWithFormat:@"\n%@\n位置信息来自：来电归属地助手,快来下载哦：%@",address,@"https://itunes.apple.com/cn/app/id800391219?mt=8"]] applicationActivities:nil];
    
    
    
    
    
    
    
    [self.navigationController presentViewController:activity animated:YES completion:nil];
    
    
    
    
    


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

@end
