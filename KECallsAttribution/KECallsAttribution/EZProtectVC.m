//
//  EZProtectVC.m
//  MyContacts
//
//  Created by 赵 进喜 on 15/1/29.
//  Copyright (c) 2015年 everzones. All rights reserved.
//




#import "EZProtectVC.h"
#import "EZProtectCheckResultVC.h"
#import <sqlite3.h>
#import "Lunbo.h"
#import "MBProgressHUD.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "KEProgressHUD.h"
#import "HarassmentCell.h"
#import "HDefaults.h"
#import "HMarkHistoryCell.h"
#import "HLocaleCell.h"
#import "HMarkHistoryController.h"
#import "HVcardImporter.h"
#import "HLocaleSettingsController.h"
#import "HPromptView.h"

static NSString * const HarassmentCellID = @"HarassmentCellID";
static NSString * const HLocaleCellID = @"HLocaleCellID";
@interface EZProtectVC ()<UITableViewDelegate, UITableViewDataSource>



@end

@implementation EZProtectVC

#pragma mark - Life Cycle

-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self=[super initWithCoder:aDecoder]) {
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.numberText.delegate=self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateNumberPlate)
                                                 name:@"updateNumberPlate" object:nil];
    
    self.tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"saoraoshibie"];
    
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"saoraoshibie"];
    [self reloadData];
    
}
#pragma mark - IBAction

//- (IBAction)showProgram:(id)sender {
//    NSLog(@"1");
//    self.disBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.disBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    self.disBtn.backgroundColor =[UIColor blackColor];
//    self.disBtn.alpha = 0.2;
//    [self.view addSubview:self.disBtn];
//    [self.disBtn addTarget:self action:@selector(dismissLunbo) forControlEvents:UIControlEventTouchUpInside];
//    
////    UIView  *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
////    view.backgroundColor = [UIColor blackColor];
////    view.alpha = 0.2;
////    [self.view addSubview:view];
//    
//    self.lunbo = [[Lunbo alloc]initWithFrame:CGRectMake((SCREEN_WIDTH -220)/2, (SCREEN_HEIGHT - 320 - 64)/2, 220, 320)];
//    
//    NSMutableArray *arr = [NSMutableArray arrayWithArray:@[@"1",@"jc2",@"jc"]];
//     self.lunbo.imagearr = arr;
//    [self.view addSubview: self.lunbo];
//
//    
//    
//}
- (IBAction)hideKeyboard:(UITapGestureRecognizer *)sender {
    [self.numberText resignFirstResponder];
    
}

- (IBAction)checkNumber:(UIButton *)sender {
    [self hideKeyboard:nil];
    self.inquiryPhoneNumber=self.numberText.text;
    EZProtectCheckResultVC *reslut=[self.storyboard instantiateViewControllerWithIdentifier:@"EZProtectCheckResultVC"];
    
    self.inquiryPhoneNumber=[self.inquiryPhoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    self.inquiryPhoneNumber=[self.inquiryPhoneNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    self.inquiryPhoneNumber=[self.inquiryPhoneNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    self.inquiryPhoneNumber=[self.inquiryPhoneNumber stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    self.inquiryPhoneNumber = [[self.inquiryPhoneNumber componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
    
    reslut.inquiryPhoneNumber=self.inquiryPhoneNumber;
    
    [self.navigationController pushViewController:reslut animated:YES];
    
}

- (IBAction)backButtonPressed:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)openHarassment:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:@"openHarassment"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    sender.hidden = YES;
    [self.tableview reloadData];
    
    HLocaleSettingsController *localeController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HLocaleSettingsController"];
    [self.navigationController pushViewController:localeController animated:YES];
}
#pragma mark - Private
- (void)reloadData {
    NSIndexPath *indexPathFirst = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath *indexPathSecond = [NSIndexPath indexPathForRow:1 inSection:0];
    
    [self.tableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathFirst,indexPathSecond,nil] withRowAnimation:UITableViewRowAnimationNone];
    
}

- (void)dismissLunbo {
    self.disBtn.hidden = YES ;
    self.lunbo.hidden = YES;
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification {
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y;
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
  
   
    [UIView animateWithDuration:[duration floatValue] delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    
    //20随便取得，没有特殊意义，只是留个间隔
        
        if (keyBoardEndY>=338) {
            
            self.view.transform=CGAffineTransformMakeTranslation(0, -20);
            
        }else
        {
        
        self.view.transform=CGAffineTransformMakeTranslation(0, keyBoardEndY-338-20);
        
        }
    
    } completion:nil];
    
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification {

    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.view.transform=CGAffineTransformIdentity;
        
    } completion:nil];
   
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (![string isEqualToString:@""]) {
         self.inquiryPhoneNumber=[textField.text stringByAppendingString:string];
        
    }else{
        self.inquiryPhoneNumber=[textField.text substringToIndex:textField.text.length-1];
    
    }
    
  //号码识别

    if ([textField.text hasPrefix:@"0"]) {
        
        //固话查询
        if (range.location ==3||range.location ==2) {
            self.inquiryPhoneNumber = [NSString stringWithFormat:@"%@%@",self.numberText.text,string];
            // self.phoneNumberTextField.text = self.inquiryPhoneNumber;
            NSString *telNum=[self.inquiryPhoneNumber substringToIndex:range.location+1];
                [self queryTelNum:telNum];
            
            
        }else if (range.location == 10) {
         
            self.inquiryPhoneNumber = [NSString stringWithFormat:@"%@%@",self.numberText.text,string];
            //[self connectingNetworkInquiryPhoneNumber:nil];
            
            [self inquiryWithNum];
        }
        
        
        
    }else{
        
        if (range.location == 6) {
            self.inquiryPhoneNumber = [NSString stringWithFormat:@"%@%@",self.numberText.text,string];
            
            
            [self inquiryWithNum];
        }
        
        if (range.location == 10) {
           
            self.inquiryPhoneNumber = [NSString stringWithFormat:@"%@%@",self.numberText.text,string];
            //[self connectingNetworkInquiryPhoneNumber:nil];
            
            [self inquiryWithNum];
        }
        
        
    }
    
    if ([self.inquiryPhoneNumber isEqualToString:@""]) {
        [UIView animateWithDuration:0.33 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.top_icon.image=[UIImage imageNamed:@"protect_icon"];
            self.addressLbl.hidden=YES;
            self.addressLbl.text=@"";
            self.provinceLbl.hidden=YES;
            self.provinceLbl.text=@"";
            self.carrierLbl.hidden=YES;
            self.carrierLbl.text=@"";
            
        } completion:^(BOOL finished) {

            
        }];
    }

    if (range.location > 10) {
        return NO;
    }else{
        return YES;
    }

    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    self.inquiryPhoneNumber=@"";
 
    self.top_icon.image=[UIImage imageNamed:@"protect_icon"];
    self.addressLbl.hidden=YES;
    self.addressLbl.text=@"";
    self.provinceLbl.hidden=YES;
    self.provinceLbl.text=@"";
    self.carrierLbl.hidden=YES;
    self.carrierLbl.text=@"";
    return YES;

}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.33 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.top_icon.image=[UIImage imageNamed:@"protect_icon"];
        self.addressLbl.hidden=YES;
        self.addressLbl.text=@"";
        self.provinceLbl.hidden=YES;
        self.provinceLbl.text=@"";
        self.carrierLbl.hidden=YES;
        self.carrierLbl.text=@"";
    } completion:^(BOOL finished) {

    }];
    
}
//固话查询
-(void)queryTelNum:(NSString *)telNum {
    NSString *databaseFilePath=[[NSBundle mainBundle]pathForResource:@"Region" ofType:@"sqlite"];
    NSString *query=@"SELECT * FROM Region WHERE Number=? LIMIT 1";
    sqlite3 *database;
    if (sqlite3_open([databaseFilePath UTF8String], &database)
        != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"打开数据库失败！");
    }
    //执行查询
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement,nil) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [telNum UTF8String], -1, NULL);
        //依次读取数据库表格FIELDS中每行的内容，并显示在对应的TextField
        while (sqlite3_step(statement) == SQLITE_ROW) {
            //获得数据
            char *carriersName =(char *)sqlite3_column_text(statement, 4);
            
            char *province = (char *)sqlite3_column_text(statement, 2);
            char *shi = (char *)sqlite3_column_text(statement, 3);
            //char *post=(char *)sqlite3_column_text(statement, 4);
          
            //更新View
            NSString * provinceString = [[NSString alloc] initWithUTF8String:province];
            NSString * cityString = [[NSString alloc] initWithUTF8String:shi];
            NSString *  strCarriersName = [[NSString stringWithUTF8String:carriersName]stringByReplacingOccurrencesOfString:@"固定电话" withString:@"固话"];
            
            [UIView animateWithDuration:0.33 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.top_icon.image=[UIImage imageNamed:@"yuangkuang_chaxun"];
                self.addressLbl.text=cityString;
                self.addressLbl.hidden=NO;
                self.provinceLbl.text=provinceString;
                self.provinceLbl.hidden=NO;
                self.carrierLbl.text=strCarriersName;
                self.carrierLbl.hidden=NO;

            } completion:^(BOOL finished) {
                
            }];
        }
        sqlite3_finalize(statement);
    }    //关闭数据库
    sqlite3_close(database);
    
}
//手机号码本地查询
-(void)inquiryWithNum {
    self.inquiryPhoneNumber=[self.inquiryPhoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    self.inquiryPhoneNumber=[self.inquiryPhoneNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    self.inquiryPhoneNumber=[self.inquiryPhoneNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    self.inquiryPhoneNumber=[self.inquiryPhoneNumber stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    self.inquiryPhoneNumber = [[self.inquiryPhoneNumber componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
    //打开数据库
    self.databaseFilePath = [[NSBundle mainBundle] pathForResource:@"database"
                                                            ofType:@"sqlite3"];
    NSString * string = [self.inquiryPhoneNumber substringToIndex:7];
    if ([[self checkCarriers:string] isEqualToString:@"MOBILE130131"]) {
        self.query = @"SELECT * FROM MOBILE130131 WHERE phoneNmber=?";
    }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE132133"]) {
        self.query = @"SELECT * FROM MOBILE132133 WHERE phoneNmber=?";
    }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE134135"]) {
        self.query = @"SELECT * FROM MOBILE134135 WHERE phoneNmber=?";
    }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE136137"]) {
        self.query = @"SELECT * FROM MOBILE136137 WHERE phoneNmber=?";
    }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE138139"]) {
        self.query = @"SELECT * FROM MOBILE138139 WHERE phoneNmber=?";
    }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE145147"]) {
        self.query = @"SELECT * FROM MOBILE145147 WHERE phoneNmber=?";
    }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE150151"]) {
        self.query = @"SELECT * FROM MOBILE150151 WHERE phoneNmber=?";
    }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE152153"]) {
        self.query = @"SELECT * FROM MOBILE152153 WHERE phoneNmber=?";
    }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE155156"]) {
        self.query = @"SELECT * FROM MOBILE155156 WHERE phoneNmber=?";
    }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE157158"]) {
        self.query = @"SELECT * FROM MOBILE157158 WHERE phoneNmber=?";
    }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE159180"]) {
        self.query = @"SELECT * FROM MOBILE159180 WHERE phoneNmber=?";
    }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE181182"]) {
        self.query = @"SELECT * FROM MOBILE181182 WHERE phoneNmber=?";
    }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE183184"]) {
        self.query = @"SELECT * FROM MOBILE183184 WHERE phoneNmber=?";
    }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE185186"]) {
        self.query = @"SELECT * FROM MOBILE185186 WHERE phoneNmber=?";
    }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE187188189"]) {
        self.query = @"SELECT * FROM MOBILE187188189 WHERE phoneNmber=?";
    }else{
        return;
    }
    sqlite3 *database;
    if (sqlite3_open([self.databaseFilePath UTF8String], &database)
        != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"打开数据库失败！");
    }
    //执行查询
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [self.query UTF8String], -1, &statement,nil) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [string UTF8String], -1, NULL);
        //依次读取数据库表格FIELDS中每行的内容，并显示在对应的TextField
        while (sqlite3_step(statement) == SQLITE_ROW) {
            //获得数据
            char *carriersName = (char *)sqlite3_column_text(statement, 3);
            char *city = (char *)sqlite3_column_text(statement, 2);
            char *province = (char *)sqlite3_column_text(statement, 1);
            
            //更新View
            NSString * provinceString = [[NSString alloc] initWithUTF8String:province];
            NSString * cityString = [[NSString alloc] initWithUTF8String:city];
            NSString *  strCarriersName = [[NSString stringWithUTF8String:carriersName]stringByReplacingOccurrencesOfString:@"固定电话" withString:@"固话"];

            [UIView animateWithDuration:0.33 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.top_icon.image=[UIImage imageNamed:@"yuangkuang_chaxun"];
                self.addressLbl.text=cityString;
                self.addressLbl.hidden=NO;
                self.provinceLbl.text=provinceString;
                self.provinceLbl.hidden=NO;
                self.carrierLbl.text=strCarriersName;
                self.carrierLbl.hidden=NO;
                
            } completion:^(BOOL finished) {
                
            }];
        }
        sqlite3_finalize(statement);
    }    //关闭数据库
    sqlite3_close(database);
    
}
- (NSString*)checkCarriers:(NSString*)string{
    NSString * carriers = nil;
    if ([[string substringToIndex:3] isEqualToString:@"130"] || [[string substringToIndex:3] isEqualToString:@"131"]) {
        carriers = @"MOBILE130131";
    }else if ([[string substringToIndex:3] isEqualToString:@"132"] || [[string substringToIndex:3] isEqualToString:@"133"]) {
        carriers = @"MOBILE132133";
    }else if ([[string substringToIndex:3] isEqualToString:@"134"] || [[string substringToIndex:3] isEqualToString:@"135"]) {
        carriers = @"MOBILE134135";
    }else if ([[string substringToIndex:3] isEqualToString:@"136"] || [[string substringToIndex:3] isEqualToString:@"137"]) {
        carriers = @"MOBILE136137";
    }else if ([[string substringToIndex:3] isEqualToString:@"138"] || [[string substringToIndex:3] isEqualToString:@"139"]) {
        carriers = @"MOBILE138139";
    }else if ([[string substringToIndex:3] isEqualToString:@"145"] || [[string substringToIndex:3] isEqualToString:@"147"]) {
        carriers = @"MOBILE145147";
    }else if ([[string substringToIndex:3] isEqualToString:@"150"] || [[string substringToIndex:3] isEqualToString:@"151"]) {
        carriers = @"MOBILE150151";
    }else if ([[string substringToIndex:3] isEqualToString:@"152"] || [[string substringToIndex:3] isEqualToString:@"153"]) {
        carriers = @"MOBILE152153";
    }else if ([[string substringToIndex:3] isEqualToString:@"155"] || [[string substringToIndex:3] isEqualToString:@"156"]) {
        carriers = @"MOBILE155156";
    }else if ([[string substringToIndex:3] isEqualToString:@"157"] || [[string substringToIndex:3] isEqualToString:@"158"]) {
        carriers = @"MOBILE157158";
    }else if ([[string substringToIndex:3] isEqualToString:@"159"] || [[string substringToIndex:3] isEqualToString:@"180"]) {
        carriers = @"MOBILE159180";
    }else if ([[string substringToIndex:3] isEqualToString:@"181"] || [[string substringToIndex:3] isEqualToString:@"182"]) {
        carriers = @"MOBILE181182";
    }else if ([[string substringToIndex:3] isEqualToString:@"183"] || [[string substringToIndex:3] isEqualToString:@"184"]) {
        carriers = @"MOBILE183184";
    }else if ([[string substringToIndex:3] isEqualToString:@"185"] || [[string substringToIndex:3] isEqualToString:@"186"]) {
        carriers = @"MOBILE185186";
    }else if ([[string substringToIndex:3] isEqualToString:@"187"] || [[string substringToIndex:3] isEqualToString:@"188"]|| [[string substringToIndex:3] isEqualToString:@"189"]) {
        carriers = @"MOBILE187188189";
    }
    return carriers;
}

// 更新号码库
- (void)updateNumberPlate {
    if (![HDefaults sharedDefaults].isOpenHarassment) {
        return;
    }
    if ([[HDefaults sharedDefaults].localeString isEqualToString:@""] || [HDefaults sharedDefaults].localeString == nil) {
        return;
    }
    
    
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

#pragma mark - UITableView Delegate & DataSource
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
                cell.titleLabel.text = @"我的标记历史";
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
                    [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
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
                HMarkHistoryController *markHistoryController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HMarkHistoryController"];
                [self.navigationController pushViewController:markHistoryController animated:YES];
            }
            break;
        
    }
            
            
    [self.tableview deselectRowAtIndexPath:indexPath animated:YES];


}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
@end
