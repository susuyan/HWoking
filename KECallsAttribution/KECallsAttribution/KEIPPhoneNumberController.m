//
//  KEIPPhoneNumberController.m
//  KECallsAttribution
//
//  Created by lichenWang on 14-1-6.
//  Copyright (c) 2014年 KERNEL. All rights reserved.
//

#import "KEIPPhoneNumberController.h"
#import <AddressBookUI/AddressBookUI.h>
@import GoogleMobileAds;
#import "GDTMobBannerView.h"
@interface KEIPPhoneNumberController ()<UIAlertViewDelegate,ABPeoplePickerNavigationControllerDelegate,GADBannerViewDelegate,GDTMobBannerViewDelegate>
@property (nonatomic, strong)UIAlertView * alerView;
@property (nonatomic, copy)NSString * ip;
@property (nonatomic, copy)NSString * phoneNumber;
@property (nonatomic, strong)GADBannerView * gadBannerView;
@property (nonatomic, strong)GDTMobBannerView *gdtBannerView;
@end

@implementation KEIPPhoneNumberController
- (void)dealloc
{
    _gdtBannerView.delegate=nil;
    _gdtBannerView.currentViewController=nil;
    _gdtBannerView=nil;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    
    
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"IPdianhua"];
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"IPdianhua"];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
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
    

    
    
    
    
//    self.gadBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
//    self.gadBannerView.adUnitID = ADMOB_APP_ID;
//    self.gadBannerView.rootViewController = self;
//    self.gadBannerView.delegate  = self;
//    CGRect frame = self.gadBannerView.frame;
//    frame.origin.x = 0;
//    frame.origin.y = 0;
//    frame.size = self.gadView.frame.size;
//    self.gadBannerView.frame = frame;
//    [self.gadView addSubview:self.gadBannerView];
//    [self.gadBannerView loadRequest:[GADRequest request]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    self.ip = cell.detailTextLabel.text;
    ABPeoplePickerNavigationController *picker =[[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    [self presentViewController:picker animated:YES completion:nil];


}
-(void) peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}
-(BOOL) peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    //获取联系人电话
    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    int index = ABMultiValueGetIndexForIdentifier(phoneMulti, identifier);
    self.phoneNumber=(__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneMulti, index);
    NSString *name = (__bridge NSString*)ABRecordCopyCompositeName(person);
    
    
    
    
    self.alerView = [[UIAlertView alloc] initWithTitle:name
                                               message:nil
                                              delegate:self
                                     cancelButtonTitle:@"取消"
                                     otherButtonTitles:@"拨打", nil];
    //self.alerView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [self.alerView show];

    
    
    
//    NSMutableArray *phones = [[NSMutableArray alloc] init];
//    int i;
//    for (i = 0; i < ABMultiValueGetCount(phoneMulti); i++) {
//        NSString *aPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phoneMulti, i);
//        NSString *aLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(phoneMulti, i);
//        aPhone = [aPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
//        aPhone = [aPhone stringByReplacingOccurrencesOfString:@"(" withString:@""];
//        aPhone = [aPhone stringByReplacingOccurrencesOfString:@")" withString:@""];
//        aPhone = [aPhone stringByReplacingOccurrencesOfString:@" " withString:@""];
//        aPhone = [aPhone stringByReplacingOccurrencesOfString:@"+" withString:@""];
//        NSLog(@"PhoneLabel:%@ Phone#:%@",aLabel,aPhone);
//        self.phoneNumber = aPhone;
//        CFStringRef compositeNameRef = ABRecordCopyCompositeName(person);
//        NSString * name = [NSString stringWithFormat:@"给%@打电话",(__bridge NSString *)(compositeNameRef)];
//        self.alerView = [[UIAlertView alloc] initWithTitle:name
//                                                   message:nil
//                                                  delegate:self
//                                         cancelButtonTitle:@"取消"
//                                         otherButtonTitles:@"拨打", nil];
//        //self.alerView.alertViewStyle = UIAlertViewStylePlainTextInput;
//        [self.alerView show];
//
//
//        if([aLabel isEqualToString:@"_$!<Mobile>!$_"]){
//            [phones addObject:aPhone];
//        }
//    }
//    if([phones count]>0){
//        NSString *mobileNo = [phones objectAtIndex:0];
//        NSLog(@"---%@",mobileNo);
//    }
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
    return NO;
    
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
-(void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    
   
    
    
    //获取联系人电话
    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    
    int index = ABMultiValueGetIndexForIdentifier(phoneMulti, identifier);
    self.phoneNumber=(__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneMulti, index);
    NSString *name = (__bridge NSString*)ABRecordCopyCompositeName(person);
    
    self.alerView = [[UIAlertView alloc] initWithTitle:name
                                               message:nil
                                              delegate:self
                                     cancelButtonTitle:@"取消"
                                     otherButtonTitles:@"拨打", nil];
    //self.alerView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [self.alerView show];

    
    
    
//    NSMutableArray *phones = [[NSMutableArray alloc] init];
//    int i;
//    for (i = 0; i < ABMultiValueGetCount(phoneMulti); i++) {
//        NSString *aPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phoneMulti, i);
//        NSString *aLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(phoneMulti, i);
//        aPhone = [aPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
//        aPhone = [aPhone stringByReplacingOccurrencesOfString:@"(" withString:@""];
//        aPhone = [aPhone stringByReplacingOccurrencesOfString:@")" withString:@""];
//        aPhone = [aPhone stringByReplacingOccurrencesOfString:@" " withString:@""];
//        aPhone = [aPhone stringByReplacingOccurrencesOfString:@"+" withString:@""];
//        NSLog(@"PhoneLabel:%@ Phone#:%@",aLabel,aPhone);
//        self.phoneNumber = aPhone;
//        CFStringRef compositeNameRef = ABRecordCopyCompositeName(person);
//        NSString * name = [NSString stringWithFormat:@"给%@打电话",(__bridge NSString *)(compositeNameRef)];
//        self.alerView = [[UIAlertView alloc] initWithTitle:name
//                                                   message:nil
//                                                  delegate:self
//                                         cancelButtonTitle:@"取消"
//                                         otherButtonTitles:@"拨打", nil];
//        //self.alerView.alertViewStyle = UIAlertViewStylePlainTextInput;
//        [self.alerView show];
//        
//        
//        if([aLabel isEqualToString:@"_$!<Mobile>!$_"]){
//            [phones addObject:aPhone];
//        }
//    }
//    if([phones count]>0){
//        NSString *mobileNo = [phones objectAtIndex:0];
//        NSLog(@"---%@",mobileNo);
//    }
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];

    
    
    
    
    
}
#endif

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@%@",self.ip,self.phoneNumber]];
        NSLog(@"%@",url);
        [[UIApplication sharedApplication] openURL:url];
    }
}
//-(BOOL)peoplePickerNavigationController: (ABPeoplePickerNavigationController *)peoplePicker
//     shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
//    return NO;
//}

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
