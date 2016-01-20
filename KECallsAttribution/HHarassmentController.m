//
//  HHarassmentController.m
//  KECallsAttribution
//
//  Created by EverZones on 15/12/4.
//  Copyright © 2015年 K.BLOCK. All rights reserved.
//

#import "HHarassmentController.h"
#import "EZProtectCheckResultVC.h"
#import "HarassmentCell.h"
#import "HLocaleCell.h"
#import <sqlite3.h>
#import "HDefaults.h"
#import "UMSocial.h"
#import "HLocaleSettingsController.h"
#import "HMarkHistoryController.h"
#import "HVcardImporter.h"
#import "MBProgressHUD.h"
#import "MobClick.h"
static NSString * const HarassmentCellID = @"HarassmentCellID";
static NSString * const HLocaleCellID = @"HLocaleCellID";

@interface HHarassmentController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UIAlertViewDelegate,UITextFieldDelegate>{
    NSArray *index_tips;
    int tips_index;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *testHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *testWidthConstraint;




@property (weak, nonatomic) IBOutlet NSLayoutConstraint *kHeightConstranint;


@end

@implementation HHarassmentController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (IS_IOS7) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
    [self initialConstraint];
    
    [self initTips];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNumberPlate) name:@"updateNumberPlate" object:nil];
    

   
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [MobClick beginLogPageView:@"fangsaoraodianhua"];
}


- (void)viewWillDisappear:(BOOL)animated {
    [MobClick endLogPageView:@"fangsaoraodianhua"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {

}

#pragma mark - IBAction 

- (IBAction)backAction:(UIButton *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)openHarassment:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:@"openHarassment"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    sender.hidden = YES;
    [self.tableView reloadData];
    
    HLocaleSettingsController *localeController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HLocaleSettingsController"];
    [self.navigationController pushViewController:localeController animated:YES];
}


#pragma mark - Private
- (void)initialConstraint {
    if (SCREEN_HEIGHT == 480) {
        //4s 设备
        
        self.kHeightConstranint.constant = 180;
    }else {
        //非4s设备
       
        
    }
    [self.view updateConstraintsIfNeeded];
}

- (void)receiveKeyboardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)removeKeyboardNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)handleKeyboardWillShow:(NSNotification *)noti {
    double duration = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.indexMarginTopConstraint.constant = -40;
        [self.view updateConstraints];
    }];
}
- (void)handleKeyboardWillHide:(NSNotification *)noti {
    double duration = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.indexMarginTopConstraint.constant = 0;
        [self.view updateConstraints];
    }];
}
- (NSString *)filterIllegalCharacterWithNumber:(NSString *)number{
    NSCharacterSet *illegalCharacter = [NSCharacterSet characterSetWithCharactersInString:@"[]{}（#%-*+=_）\\|~(＜＞$%^&*;)_+ "];
    number = [[number componentsSeparatedByCharactersInSet:illegalCharacter] componentsJoinedByString:@""];
    return number;
}

// 更新号码库
- (void)updateNumberPlate {
    if (![HDefaults sharedDefaults].isOpenHarassment) {
        return;
    }
    if ([[HDefaults sharedDefaults].localeString isEqualToString:@""] || [HDefaults sharedDefaults].localeString == nil) {
        return;
    }
    
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstUpdate"]) {

        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstUpdate"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else {
        
        [HVcardImporter CheckAddressBookAuthorization:^(bool isAuthorized) {
            if (isAuthorized) {//已获取通讯录权限
                HVcardImporter *importer = [[HVcardImporter alloc] init];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                hud.mode = MBProgressHUDModeIndeterminate;
                hud.labelText = @"正在更新号码库";
                NSString *areaString = [HDefaults sharedDefaults].localeString;
                if ([areaString isEqualToString:@"北京"]) {
                    areaString = @"北京";
                }else if ([areaString isEqualToString:@"上海"]){
                    areaString = @"上海";
                }else if ([areaString isEqualToString:@"广州"]){
                    areaString = @"广州";
                }else if ([areaString isEqualToString:@"深圳"]){
                    areaString = @"深圳";
                }else if ([areaString isEqualToString:@"重庆"]){
                    areaString = @"重庆";
                }else if ([areaString isEqualToString:@"天津"]){
                    areaString = @"天津";
                }else if ([areaString isEqualToString:@"南京"]){
                    areaString = @"南京";
                }else if ([areaString isEqualToString:@"杭州"]){
                    areaString = @"杭州";
                }else if ([areaString isEqualToString:@"成都"]){
                    areaString = @"成都";
                }else if ([areaString isEqualToString:@"福州"]){
                    areaString = @"福州";
                }else if ([areaString isEqualToString:@"济南"]){
                    areaString = @"济南";
                }else {
                    areaString = @"其他城市";
                }
                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                    // Do something...
                    [importer deleteVCF];
                    [importer parseWithAreaString:areaString];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        hud.labelText = @"更新完毕";
                        [hud hide:YES];
                    });
                });
                
                
            }else {//弹出提示
                UIAlertView * alart = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请您设置允许APP访问您的通讯录\n设置>隐私>通讯录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alart show];
                
                NSLog(@"请开启通讯录权限");
            }
        }];
        
    }
}

- (void)initTips {
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(changeTips) userInfo:nil repeats:YES];
    tips_index=0;
    index_tips=@[@"利用大数据技术当前能为您识别90%可疑电话",@"已成功为1亿用户识别过可疑电话"];
}
- (void)changeTips {
    if (tips_index==index_tips.count) {
        tips_index=0;
    }
    NSString *tip=[index_tips objectAtIndex:tips_index];
    self.index_top_tips.text=tip;
    tips_index ++;
}


- (void)umShare {
    NSString * content = [NSString stringWithFormat:@"%@。\r\n%@",@"你的iphone也能防骚扰啦！陌生来电识别、防骚扰防诈骗，不信你也试试",[NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@?mt=8",APPLE_ID]];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMENG_APP_SHARE_ID
                                      shareText:content
                                     shareImage:[UIImage imageNamed:@"icon"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,nil]
                                       delegate:nil];
    [UMSocialData defaultData].extConfig.title = @"防骚扰电话";
    
}
#pragma mark - UITableView DataSource and Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        HarassmentCell *cell = [tableView dequeueReusableCellWithIdentifier:HarassmentCellID forIndexPath:indexPath];
        
        if ([[HDefaults sharedDefaults].localeString isEqualToString:@""] || [HDefaults sharedDefaults].localeString == nil ||[HDefaults sharedDefaults].isOpenHarassment == NO) {
            //已开启防骚扰模式
            cell.titleLabel.text = @"开启防骚扰模式";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.cellSwitch.hidden = NO;
        }else {
            
            cell.titleLabel.text = @"更新防骚扰号码库";
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.cellSwitch.hidden = YES;
            
        }
        cell.cellSwitch.on = [HDefaults sharedDefaults].isOpenHarassment;
        return cell;
    }else {
        HLocaleCell *cell = [tableView dequeueReusableCellWithIdentifier:HLocaleCellID forIndexPath:indexPath];
        
        switch (indexPath.row) {
            case 1:
            {
                cell.titleLabel.text = @"我的归属地";
                cell.localeLabel.text = [HDefaults sharedDefaults].localeString;
            }
                break;
                
            
            case 2:
            {
                cell.titleLabel.text = @"分享给小伙伴";
                cell.localeLabel.text = @"";
            }
                break;
                
        }
        
        return cell;
    }

    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            
            if ([[HDefaults sharedDefaults].localeString isEqualToString:@""] || [HDefaults sharedDefaults].localeString == nil) {
                [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            }else {
                [self updateNumberPlate];
                
            }

            
        }
            break;
        case 1:
        {
            HLocaleSettingsController *localeController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HLocaleSettingsController"];
            [self.navigationController pushViewController:localeController animated:YES];
        }
            break;
            
       
        case 2:
        {
            [self umShare];
            
        }
            break;
            
    }
    
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}




@end
