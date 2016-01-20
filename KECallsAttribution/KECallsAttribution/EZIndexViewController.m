//
//  EZIndexViewController.m
//  KECallsAttribution
//
//  Created by 赵 进喜 on 15/4/21.
//  Copyright (c) 2015年 K.BLOCK. All rights reserved.
//

#import "EZIndexViewController.h"

#import "EZProtectVC.h"
#import <NotificationCenter/NotificationCenter.h>
#import "EZProtectCheckResultVC.h"
#import "KEAddressBookController.h"
#import <sqlite3.h>
@interface EZIndexViewController ()<UIGestureRecognizerDelegate,UIAlertViewDelegate,UITextFieldDelegate> {

    NSArray *index_tips;
    int tips_index;
    
    
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *testHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *testWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cityHeightConstranint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carrierTopConstranint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewTopConstranint;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *kHeightConstranint;


@property(copy,nonatomic)NSString *databaseFilePath;
@property(copy,nonatomic)NSString *query;
@end

@implementation EZIndexViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IS_IOS7) {
        self.navigationController.interactivePopGestureRecognizer.delegate=self;
    }

    
    
    
    
    [self initTips];
    
    
  //  [self initTopAnimation];
    
        if(IS_IOS8) {
    
            //内存插件
            NCWidgetController *lol = [NCWidgetController widgetController];
            [lol setHasContent:YES forWidgetWithBundleIdentifier:@"com.93app.shoujiguishudi.checknumber"];
    
    
//            NSString *urlStr = @"com.app72.laidianguishudi.phoneTodayWidget://";
//            [[self extensionContext] openURL:[NSURL URLWithString:urlStr] completionHandler:nil];
//    
//    
//            //快捷联系人
//    
//            NCWidgetController *quick = [NCWidgetController widgetController];
//            [quick setHasContent:YES forWidgetWithBundleIdentifier:@"com.app72.laidianguishudi.quickwidget"];
        
        }

  //  [NSTimer scheduledTimerWithTimeInterval:0.5 target:radarView selector:@selector(addOrReplaceItem) userInfo:nil repeats:YES];

    // Do any additional setup after loading the view.
    
    
    
    if (SCREEN_HEIGHT!=480) {
        
        
        self.top_icon_top.constant=40;
        self.top_icon_width.constant=105;
        
        
    }
    
    [self initialConstraint];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
}
-(void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
   // [self receiveKeyboardNotification];
    
    
}

- (void)dealloc {
    [self removeKeyboardNotification];
}

- (void)applicationWillEnterForeground {
    [self pasteboardNumber];
}
#pragma mark - Private
- (void)pasteboardNumber{
    NSString *pastString = [UIPasteboard generalPasteboard].string;
    self.phoneTxt.text = [self filterIllegalCharacterWithNumber:pastString];
    NSLog(@"---粘贴板号码：%@----",[self filterIllegalCharacterWithNumber:pastString]);
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
        self.indexMarginTopConstraint.constant = - 40;
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

- (void)initialConstraint {
    if (SCREEN_HEIGHT == 480) {
        //4s 设备
        self.testHeightConstraint.constant = 90;
        self.testWidthConstraint.constant = 90;
        self.cityHeightConstranint.constant = 8;
        self.carrierTopConstranint.constant = 6;
        self.kHeightConstranint.constant = 180;
        self.inputViewTopConstranint.constant = 8;
    }else {
        //非4s设备
        self.testHeightConstraint.constant = 115;
        self.testHeightConstraint.constant = 115;

    }
    [self.view updateConstraintsIfNeeded];
}

- (NSString *)filterIllegalCharacterWithNumber:(NSString *)number{
    NSCharacterSet *illegalCharacter = [NSCharacterSet characterSetWithCharactersInString:@"[]{}（#%-*+=_）\\|~(＜＞$%^&*;)_+ -"];
    
    number = [[number componentsSeparatedByCharactersInSet:illegalCharacter] componentsJoinedByString:@""];
    
    
    
    return number;
}

#pragma mark - 动态标签条
- (void)initTips {

    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(changeTips) userInfo:nil repeats:YES];


    tips_index=0;
    
    index_tips=@[@"利用大数据技术当前能为您识别90%可疑电话",@"已成功为1亿用户识别过可疑电话"];
    
    
}
-(void)changeTips {


    if (tips_index==index_tips.count) {
        tips_index=0;
    }
    
    
    NSString *tip=[index_tips objectAtIndex:tips_index];
    
    self.index_top_tips.text=tip;
    
    tips_index ++;
    
    

}

-(void)skipToQueryPage {

    EZProtectVC *query=[self.storyboard instantiateViewControllerWithIdentifier:@"EZProtectVC"];
    
    [self.navigationController pushViewController:query animated:YES];
}



#pragma mark - 查询
- (IBAction)queryNumber:(UIButton *)sender {
    
    [self hideKeyboard:nil];
    
    self.inquiryPhoneNumber = self.phoneTxt.text;
    
    EZProtectCheckResultVC *reslut=[self.storyboard instantiateViewControllerWithIdentifier:@"EZProtectCheckResultVC"];
    
    
    self.inquiryPhoneNumber = [self.inquiryPhoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    self.inquiryPhoneNumber = [self.inquiryPhoneNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    self.inquiryPhoneNumber = [self.inquiryPhoneNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    self.inquiryPhoneNumber = [self.inquiryPhoneNumber stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    self.inquiryPhoneNumber = [[self.inquiryPhoneNumber componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
    
    reslut.inquiryPhoneNumber=self.inquiryPhoneNumber;
    
    [self.navigationController pushViewController:reslut animated:YES];
}

- (IBAction)hideKeyboard:(UITapGestureRecognizer *)sender {
    
    [self.phoneTxt resignFirstResponder];
    
}

- (IBAction)myContactsAction:(id)sender {
    int __block tip=0;
    //声明一个通讯簿的引用
    ABAddressBookRef addBook =nil;
    //因为在IOS6.0之后和之前的权限申请方式有所差别，这里做个判断
    if ([[UIDevice currentDevice].systemVersion floatValue]>=6.0) {
        //创建通讯簿的引用
        addBook = ABAddressBookCreateWithOptions(NULL, NULL);
        //创建一个出事信号量为0的信号
        dispatch_semaphore_t sema=dispatch_semaphore_create(0);
        //申请访问权限
        ABAddressBookRequestAccessWithCompletion(addBook, ^(bool greanted, CFErrorRef error)        {
            //greanted为YES是表示用户允许，否则为不允许
            if (!greanted) {
                tip=1;
            }
            //发送一次信号
            dispatch_semaphore_signal(sema);
        });
        //等待信号触发
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }else{
        //IOS6之前
        addBook = ABAddressBookCreate();
    }
    if (tip) {
        //做一个友好的提示
        UIAlertView * alart = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请您设置允许APP访问您的通讯录\n设置>隐私>通讯录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alart show];
        return;
    }
    
    UINavigationController *controllerNav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ContactsNav"];
    
    [self.navigationController presentViewController:controllerNav animated:YES completion:nil];
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (&UIApplicationOpenSettingsURLString != NULL) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

#pragma mark - PhoneNumber Query

//固话查询
-(void)queryTelNum:(NSString *)telNum
{
    
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
            
            // NSString *postString=[[NSString alloc]initWithUTF8String:post];
            
            
            //NSString *areaName=@"";
            
            NSString *  strCarriersName = [[NSString stringWithUTF8String:carriersName]stringByReplacingOccurrencesOfString:@"固定电话" withString:@"固话"];
            //            if([provinceString isEqualToString:cityString]){
            //               areaName = provinceString;
            //            }else{
            //               areaName = [NSString stringWithFormat:@"%@%@",provinceString,cityString];
            //            }
            //            NSString *result = [NSString stringWithFormat:@"%@%@",areaName,strCarriersName];
            
            
            
            
            
            [UIView animateWithDuration:0.33 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                
                
                self.index_top_icon.image=[UIImage imageNamed:@"index_top_circle"];
                
                
                self.cityLabel.text=cityString;
                self.cityLabel.hidden=NO;
                
                self.provinceLabel.text=provinceString;
                self.provinceLabel.hidden=NO;
                
                
                self.carrierLabel.text=strCarriersName;
                self.carrierLabel.hidden=NO;
                                
                
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
            
            NSString *  strCarriersName = [[NSString stringWithUTF8String:carriersName]
                                           stringByReplacingOccurrencesOfString:@"固定电话"
                                           withString:@"固话"];
            
            
            
            [UIView animateWithDuration:0.33 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                
                
                self.index_top_icon.image=[UIImage imageNamed:@"index_top_circle"];
                
                
                self.cityLabel.text=cityString;
                self.cityLabel.hidden=NO;
                
                self.provinceLabel.text=provinceString;
                self.provinceLabel.hidden=NO;
                
                
                self.carrierLabel.text=strCarriersName;
                self.carrierLabel.hidden=NO;
                
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


#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    string = [self filterIllegalCharacterWithNumber:string];

    if (string.length > 7) {
        //处理粘贴
        
        self.phoneTxt.text = string;
        NSLog(@"---粘贴板号码1：%@----",string);
        NSString *pasteStr = [string substringToIndex:8];
        if ([pasteStr hasPrefix:@"0"]) {
            //固话
            [self queryTelNum:pasteStr];

        }else if ([pasteStr hasPrefix:@"1"]) {
            //手机
            self.inquiryPhoneNumber = [self filterIllegalCharacterWithNumber:pasteStr];
            [self inquiryWithNum];
        }
        
    }else {//处理输入
        if (![string isEqualToString:@""]) {
            
            self.inquiryPhoneNumber = [textField.text stringByAppendingString:string];
            
        }else {
            
            self.inquiryPhoneNumber = [textField.text substringToIndex:textField.text.length-1];
            
        }
        
        if ([self.inquiryPhoneNumber isEqualToString:@""]) {
            
            
            
        }else {
            
            
            
        }
        
        
        //号码识别
        
        if ([textField.text hasPrefix:@"0"]) {
            
            //固话查询
            if (range.location ==3||range.location ==2) {
                
                self.inquiryPhoneNumber = [NSString stringWithFormat:@"%@%@",self.phoneTxt.text,string];
                // self.phoneNumberTextField.text = self.inquiryPhoneNumber;
                NSString *telNum=[self.inquiryPhoneNumber substringToIndex:range.location+1];
                [self queryTelNum:telNum];
                
                
                
            }else if (range.location == 10) {
                self.inquiryPhoneNumber = [NSString stringWithFormat:@"%@%@",self.phoneTxt.text,string];
                //[self connectingNetworkInquiryPhoneNumber:nil];
                
                [self inquiryWithNum];
                
            }
            
            
            
        }else {
            
            if (range.location == 6) {
                self.inquiryPhoneNumber = [NSString stringWithFormat:@"%@%@",self.phoneTxt.text,string];
                
                
                [self inquiryWithNum];
            }
            
            if (range.location == 10) {
                
                self.inquiryPhoneNumber = [NSString stringWithFormat:@"%@%@",self.phoneTxt.text,string];
                
                
                [self inquiryWithNum];
            }
            
            
        }
        
        if ([self.inquiryPhoneNumber isEqualToString:@""]) {
            
            [UIView animateWithDuration:0.33 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                self.index_top_icon.image=[UIImage imageNamed:@"index_top_icon"];
                
                self.cityLabel.hidden=YES;
                self.cityLabel.text=@"";
                
                self.provinceLabel.hidden=YES;
                self.provinceLabel.text=@"";
                
                self.carrierLabel.hidden=YES;
                self.carrierLabel.text=@"";
                
            } completion:^(BOOL finished) {
                
                
            }];
            
            
        }
        
        if (range.location > 10) {
            return NO;
        }else{
            return YES;
        }

    }
    
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    self.inquiryPhoneNumber=@"";
    
    self.provinceLabel.hidden=YES;
    self.provinceLabel.text=@"";
    
    self.cityLabel.hidden=YES;
    self.cityLabel.text=@"";
    
    self.carrierLabel.hidden=YES;
    self.carrierLabel.text=@"";
    
    self.index_top_icon.image = [UIImage imageNamed:@"index_top_icon"];
    
    return YES;
    
}


@end
