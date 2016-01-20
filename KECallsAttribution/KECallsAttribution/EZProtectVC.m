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

@implementation EZProtectVC


#pragma mark - Lifecycle
-(id)initWithCoder:(NSCoder *)aDecoder {

    if (self=[super initWithCoder:aDecoder]) {
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;

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
    
}


-(void)viewDidLoad {

    [super viewDidLoad];
    

    self.edgesForExtendedLayout=UIRectEdgeAll;
    
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

    
  


}

#pragma mark - Custom Accessors
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification {
    //获取键盘的高度
//    NSDictionary *userInfo = [aNotification userInfo];
//    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [aValue CGRectValue];
//    int height = keyboardRect.size.height;
    
    
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


#pragma mark - IBActions/Event Response
- (IBAction)hideKeyboard:(UITapGestureRecognizer *)sender {
    
    [self.view endEditing:YES];
    
    
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

#pragma mark -UITextField delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
  replacementString:(NSString *)string {

    if (![string isEqualToString:@""]) {
        
        self.inquiryPhoneNumber=[textField.text stringByAppendingString:string];
        
        
    }else {
    
        self.inquiryPhoneNumber=[textField.text substringToIndex:textField.text.length-1];
    
    
    }
    
    if ([self.inquiryPhoneNumber isEqualToString:@""]) {
        
        
        
        [self.checkButton setImage:[UIImage imageNamed:@"check_button"] forState:UIControlStateNormal];
        
    }else {
    
        [self.checkButton setImage:[UIImage imageNamed:@"check_button_high"] forState:UIControlStateNormal];
        
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
        
        
        
    }else {
        
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

    [self.checkButton setImage:[UIImage imageNamed:@"check_button"] forState:UIControlStateNormal];

    
    self.top_icon.image=[UIImage imageNamed:@"protect_icon"];
    
    
    
    self.addressLbl.hidden=YES;
    
    self.addressLbl.text=@"";
    
    self.provinceLbl.hidden=YES;
    
    self.provinceLbl.text=@"";
    
    self.carrierLbl.hidden=YES;
    
    self.carrierLbl.text=@"";


    return YES;

}
- (void)textFieldDidBeginEditing:(UITextField *)textField; {
    
    
    
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


@end
