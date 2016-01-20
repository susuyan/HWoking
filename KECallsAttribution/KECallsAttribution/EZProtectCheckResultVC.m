//
//  EZProtectCheckResultVC.m
//  MyContacts
//
//  Created by 赵 进喜 on 15/1/30.
//  Copyright (c) 2015年 everzones. All rights reserved.
//

#import "EZProtectCheckResultVC.h"
#import "SVProgressHUD.h"
#import "EZCustomActionView.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "KEProgressHUD.h"
#import "YUVcardImporter.h"
#import <sqlite3.h>

#import "YUABHelper.h"
#import "HVcardImporter.h"
#define CONTACTS_ID @"CONTACTS_ID"
#define CONTACTS_LABELS @"CONTACTS_LABELS"
#define CONTACTS_PHONES @"CONTACTS_PHONES"
#import "HAdvertisementManager.h"
#import "HNumberForRequestManager.h"
#import "UMSocial.h"
@interface EZProtectCheckResultVC () <UIAlertViewDelegate> {
    BOOL _areaCodeLenIsThree;
}

@end

@implementation EZProtectCheckResultVC

#pragma mark - LifeCycle
-(void)viewDidLoad {

    [super viewDidLoad];
    
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    
    _mReach=[Reachability reachabilityForInternetConnection];
    
    currentKey=@"12994";
    currentSign=@"7dda216c0f371003681e03736feb3de2";

    
    self.markLbl.alpha = 0;
    self.infoLbl.alpha = 0;
    self.markButton.alpha = 0;
    self.shareButton.alpha = 0;

    
    NSArray *images=[NSArray arrayWithObjects:[UIImage imageNamed:@"saorao"],[UIImage imageNamed:@"zhapian"],[UIImage imageNamed:@"fangdichan"],[UIImage imageNamed:@"guanggao"],[UIImage imageNamed:@"kuaidi"], nil];

    _resultImageView.animationImages = images;
    //按照原始比例缩放图片，保持纵横比
    _resultImageView.contentMode = UIViewContentModeScaleAspectFit;
    //切换动作的时间3秒，来控制图像显示的速度有多快，
    _resultImageView.animationDuration = 0.5;
    //动画的重复次数，想让它无限循环就赋成0
    _resultImageView.animationRepeatCount = 0;

    
    //暂时将图片位置改变放大
    self.resultImageView.transform = CGAffineTransformMakeTranslation(0, 35);
    self.resultImageView.transform = CGAffineTransformScale(self.resultImageView.transform, 1.6, 1.6);
    self.loadingLbl.transform = CGAffineTransformMakeTranslation(0, 60);
    
    self.adCell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    
    [self checkNumber];

  //  [self loadNativeAds];
    
//    [self loadBanner];
    [self loadAdwoNativeAd];

//    [self performSelector:@selector(loadAdwoNativeAd) withObject:nil afterDelay:10];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"haomabiaoji"];
    
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"haomabiaoji"];
    
}


-(void)startAnimation {
    
     [self.resultImageView startAnimating];
   
}


-(void)stopAnimation {

    [self.resultImageView stopAnimating];


}

-(void)checkNumber {

    if ([_mReach currentReachabilityStatus] == NotReachable) {
        
        UIAlertView *alert= [ [UIAlertView alloc]initWithTitle:@"网络无法连接" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        
        [self stopAnimation];
        
        
        self.loadingLbl.text=@"网络无法连接";
        
        
        self.resultImageView.image=[UIImage imageNamed:@"error_icon"];
        
        
        [alert show];

        
        
        return;
        
        
    }

    
    if ([_inquiryPhoneNumber hasPrefix:@"0"]) {
        
        [self startAnimation];
        //TODO: 加固话标记信息查询
        NSString *urlStringFor360 = [NSString stringWithFormat:@"http://www.so.com/s?ie=utf-8&shb=1&src=360sou_home&q=%@",self.inquiryPhoneNumber];
        HNumberForRequestManager *manager = [HNumberForRequestManager shareInstance];
        [manager queryNumberMarkedInfoForURL:urlStringFor360 completionBlockWithSuccess:^(id responseObject) {
            
            int count=[responseObject[@"user_record_times"] intValue];
            if (count>0) {
                self.markLbl.text=responseObject[@"phone_number_type"];
                NSString *strCount=[NSString stringWithFormat:@"%d",count];
                NSMutableAttributedString *mark=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"已被%d人标记 %@",count,self.inquiryPhoneNumber]];
                NSRange range=NSMakeRange(2, strCount.length);
                [mark addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
                self.infoLbl.attributedText = mark;
                [self stopAnimation];
                
                [self setResultShowIcon:self.markLbl.text];
                
                [self uploadNumberInfoWithPhoneNumber:self.inquiryPhoneNumber typeName:self.markLbl.text count:count];
                
                
            }else {
                [self stopAnimation];
                if (check_result) {
                    self.resultImageView.image=[UIImage imageNamed:@"result_icon"];
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.infoLbl.alpha=1.0;
                    self.infoLbl.text=[NSString stringWithFormat:@"%@ 未发现标记行为",self.inquiryPhoneNumber];
                    self.resultImageView.image=[UIImage imageNamed:@"result_icon"];
                });
                
            }
            
            [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                self.markLbl.alpha = 1.0;
                self.infoLbl.alpha=1.0;
                self.markButton.alpha=1.0;
                self.shareButton.alpha = 1.0;
                self.loadingLbl.alpha=0;
                
            } completion:nil];
            
        } completionBlockWithFailure:^(NSError *error) {
            self.loadingLbl.text=@"查询失败";
            [self stopAnimation];
            
        }];
        

        return;
        
        
    }
    
    
    
    if (![self isMobileNumber:_inquiryPhoneNumber]) {
                
        [self stopAnimation];
        
        
        self.loadingLbl.text=@"手机或固话号码格式不对！";
        self.resultImageView.image=[UIImage imageNamed:@"error_icon"];
        isadderror=YES;
        
       // [alert show];
        return;
        
    }
    
    [self startAnimation];

    [self getBlacklistData];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSString * string = [NSString stringWithFormat:@"http://api.k780.com:88/?app=phone.get&phone=%@&appkey=%@&sign=%@&format=json",self.inquiryPhoneNumber,currentKey,currentSign];
        NSURL * formUrl = [NSURL URLWithString:string];
        NSLog(@"%@",string);
        NSURLRequest * request = [NSURLRequest requestWithURL:formUrl];
        NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            //[self.activityIndicatorView stopAnimating];
            if (data == nil) {
                return ;
            }
            NSDictionary * dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSLog(@"%@",dictionary);
            
            if ([dictionary[@"success"] integerValue] == 1) {
                
                
                check_result=YES;
                
                
               // cell2.textLabel.text = [NSString stringWithFormat:@"中国%@",dictionary[@"result"][@"operators"]];
                
                
                NSArray *addressArr=[dictionary[@"result"][@"style_simcall"]componentsSeparatedByString:@","];
                
                
                NSString *address=@"";
                
                
                
                for (int i=0; i<addressArr.count; i++) {
                    if (i==0) {
                        address=addressArr[i];
                    }else {
                    
                        address=[NSString stringWithFormat:@"%@ %@",address,addressArr[i]];
                    
                    }
                }
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 更UI
                    self.markLbl.text = address;
                    
                    self.infoLbl.text=[NSString stringWithFormat:@"%@ 未发现标记行为",self.inquiryPhoneNumber];
                });
                
                
                
            }else{
                
                if (![self.inquiryPhoneNumber hasPrefix:@"0"]) {
                    
                    
                    [SVProgressHUD showErrorWithStatus:@"出现错误，请稍后再试"];
                    
                  
                    [self stopAnimation];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 更UI
                        self.loadingLbl.text=@"查询失败";
                        self.resultImageView.image=[UIImage imageNamed:@"error_icon"];

                    });
                    isadderror=YES;
                    
                }
                
                
            }
            
        });
    });


}

#pragma mark - 离线查询
- (void)offlineQueryNumber:(NSString *)number{
    if ([number hasPrefix:@"0"]) {//固话
        
        if (number.length < 3) {
            self.loadingLbl.text=@"手机或固话号码格式不对！";
            self.loadingLbl.hidden = NO;
            self.resultImageView.image=[UIImage imageNamed:@"error_icon"];
            isadderror = YES;
            return;
        }else {
            if (number.length == 3) {
                number = [number substringToIndex:3];
                [self queryLandline:number];
            }
            if (number.length == 4) {
                number = [number substringToIndex:4];
            }
            
        }
        
        [self queryLandline:number];
        
        
        
        
    }else if([number hasSuffix:@"1"]){//手机
        [self queryPhoneNumber:number];
    }
    
    
}
- (void)queryPhoneNumber:(NSString *)number {
    number = [number stringByReplacingOccurrencesOfString:@"-" withString:@""];
    number = [number stringByReplacingOccurrencesOfString:@"(" withString:@""];
    number = [number stringByReplacingOccurrencesOfString:@")" withString:@""];
    number = [number stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    number = [[number componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
    if (number.length < 7) {
        self.loadingLbl.text=@"手机或固话号码格式不对！";
        self.loadingLbl.hidden = NO;
        self.resultImageView.image=[UIImage imageNamed:@"error_icon"];
        isadderror = YES;
        return;
    }
    
    //打开数据库
    self.databaseFilePath = [[NSBundle mainBundle] pathForResource:@"database"
                                                            ofType:@"sqlite3"];
    NSString * string = [number substringToIndex:7];
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
                self.markLbl.text = [NSString stringWithFormat:@"%@ %@",provinceString,cityString];
                self.infoLbl.text = [NSString stringWithFormat:@"%@",strCarriersName];
                
            } completion:^(BOOL finished) {
                
            }];
        }
        sqlite3_finalize(statement);
    }    //关闭数据库
    sqlite3_close(database);
}
- (void)queryLandline:(NSString *)number {
    
    NSString *databaseFilePath=[[NSBundle mainBundle]pathForResource:@"Region" ofType:@"sqlite"];
    
    
   // NSString *query=@"SELECT * FROM Region WHERE Number=? LIMIT 1";
    NSString *query=@"SELECT * FROM Region WHERE Number=? OR Number=?";
    sqlite3 *database;
    if (sqlite3_open([databaseFilePath UTF8String], &database)
        != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"打开数据库失败！");
    }
    //执行查询
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement,nil) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [number UTF8String], -1, NULL);
        //依次读取数据库表格FIELDS中每行的内容，并显示在对应的TextField
        while (sqlite3_step(statement) == SQLITE_ROW) {
            //获得数据
            char *carriersName =(char *)sqlite3_column_text(statement, 4);
            char *province = (char *)sqlite3_column_text(statement, 2);
            char *shi = (char *)sqlite3_column_text(statement, 3);
            
            //更新View
            NSString * provinceString = [[NSString alloc] initWithUTF8String:province];
            NSString * cityString = [[NSString alloc] initWithUTF8String:shi];
            
            NSString *  strCarriersName = [[NSString stringWithUTF8String:carriersName]stringByReplacingOccurrencesOfString:@"固定电话" withString:@"固话"];
            
            [UIView animateWithDuration:0.33 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                self.markLbl.text = [NSString stringWithFormat:@"%@ %@",provinceString,cityString];
                self.infoLbl.text = [NSString stringWithFormat:@"%@",strCarriersName];
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


- (void)getBlacklistData {
    
    __block  NSString *dataString;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.so.com/s?ie=utf-8&shb=1&src=360sou_home&q=%@",self.inquiryPhoneNumber]];
        
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        
        
        NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        if (data) {
            dataString=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            [self getDataFromServerWith:dataString];
            
        }else{
                
            return;
        }
       
    
    });
    
    
    
}
-(void)getDataFromServerWith:(NSString *)dataString {
    
    __block   NSDictionary *dataDic;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
                
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://93app.com/laidianguishu/phone_number_checker.php"]];
        
        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
        
        [request setTimeoutInterval:30];
        [request setHTTPMethod:@"POST"];
        
        [request setValue:@"application/x-www-form-urlencoded"forHTTPHeaderField:@"Content-Type"];//???
        
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];//???
        
        
        NSString *bodyStr=[NSString stringWithFormat:@"content=%@",[self URLEncodeString:dataString]];
        
        // NSString *bodyStr=[NSString stringWithFormat:@"{content:%@}",[self URLEncodeString:dataString]];
        
        
        
        
        NSData *body=[bodyStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        
        
        [request setHTTPBody:body];
        
        
        //得到提交数据的长度
        NSString* len = [NSString stringWithFormat:@"%lu",(unsigned long)[body length]];
        //添加一个http包头告诉服务器数据长度是多少
        [request setValue:len forHTTPHeaderField:@"Content-Length"];//???
        
        
        NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        if (data) {
            
            
            NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
            
            dataDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        }else{
            
            
            
            self.loadingLbl.text=@"查询失败";
            
            
            [self stopAnimation];
            
            
            self.resultImageView.image=[UIImage imageNamed:@"error_icon"];
            
             isadderror=YES;

            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([dataDic[@"status"] integerValue] == 1){
                
                //                [self.markLoading stopAnimating];
                
                int count=[dataDic[@"user_record_times"] intValue];
                
                NSLog(@"%@",dataDic[@"phone_number_type"]);
                
                if (count>0) {

                    self.markLbl.text=dataDic[@"phone_number_type"];
                    
                    NSString *strCount=[NSString stringWithFormat:@"%d",count];
                    
                    NSMutableAttributedString *mark=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"已被%d人标记 %@",count,self.inquiryPhoneNumber]];
                    
                    NSRange range=NSMakeRange(2, strCount.length);
                    
                    [mark addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
                    
                    self.infoLbl.attributedText = mark;

                    [self stopAnimation];
                    
                    if (check_result) {
                         [self setResultShowIcon:self.markLbl.text];
                    }
                    
                      [self uploadNumberInfoWithPhoneNumber:self.inquiryPhoneNumber typeName:self.markLbl.text count:count];
                    
                }else {
                
                    [self stopAnimation];
                    
                    
                    if (check_result) {
                        self.resultImageView.image=[UIImage imageNamed:@"result_icon"];
                    }
                    
                
                }
                
                
                if (!isadderror) {
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        
                        
                        self.resultImageView.transform=CGAffineTransformIdentity;
                        self.loadingLbl.transform=CGAffineTransformIdentity;
                        
                        
                        
                    }];
                    
                    
                    
                    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        
                        
                        if (check_result) {
                            
                            
                            self.markLbl.alpha = 1.0;
                            
                            self.infoLbl.alpha=1.0;
                            
                            
                            self.markButton.alpha = 1.0;
                            self.shareButton.alpha = 1.0;
                            
                        }
                       
                        
                        self.loadingLbl.alpha=0;
                        
                    } completion:nil];
                    

                    
                }
                
            }else {
            
            
                self.loadingLbl.text=@"查询失败";
                
                
                [self stopAnimation];
                
                
                self.resultImageView.image=[UIImage imageNamed:@"error_icon"];
            
            
            
            }
            
        });
    });
    
}
- (NSString *)URLEncodeString:(NSString *)string {
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR("% '\"?=&+<>;:-"), kCFStringEncodingUTF8));
    return result;
}


-(void)setResultShowIcon:(NSString *)typeName {

    NSString *imageName;
    
    if ([typeName isEqualToString:@"骚扰电话"]) {
        
         imageName=@"saorao";
        
    }else if ([typeName isEqualToString:@"快递送餐"]) {
        
        
        
         imageName=@"kuaidi";
        
        
    }else if ([typeName isEqualToString:@"广告推销"]) {
        
        
         imageName=@"guanggao";
        
        
    }else if ([typeName isEqualToString:@"房产中介"]) {
        
       
         imageName=@"fangdichan";
        
        
    }else if ([typeName isEqualToString:@"疑似诈骗电话"]||[typeName isEqualToString:@"诈骗电话"]) {
        
       
        imageName=@"zhapian";
        
    }else {
        
        imageName=@"骚扰电话";
        
    }



    self.resultImageView.image=[UIImage imageNamed:imageName];
    
    
    [UIView animateWithDuration:0.3 animations:^{
    
    
        self.resultImageView.transform=CGAffineTransformIdentity;
        self.loadingLbl.transform=CGAffineTransformIdentity;

    
    
    }];

}


#pragma mark - IBAction

- (IBAction)markNumber:(UIButton *)sender {
    
    [MobClick event:@"markNumberAction"];
    [self showAddMarkView];
    
    
    
}

- (IBAction)backButtonPressed:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)umShare:(UIButton *)sender {
    [MobClick event:@"umfenxiangAction"];
    NSString * content = [NSString stringWithFormat:@"%@。\r\n%@",@"你的iphone也能防骚扰啦！陌生来电识别、防骚扰防诈骗，不信你也试试",[NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@?mt=8",APPLE_ID]];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMENG_APP_SHARE_ID
                                      shareText:content
                                     shareImage:[UIImage imageNamed:@"icon120"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,nil]
                                       delegate:nil];
    [UMSocialData defaultData].extConfig.title = @"手机归属地";
}


#pragma mark 添加标记

- (void)showAddMarkView {
    
    EZCustomActionView *action=[[EZCustomActionView alloc]init];
    
    action.touchMenuBlock=^(int tag){
        
        [MobClick event:@"realMarkNumber"];
        NSLog(@"你点了按钮：%d",tag);
        
        
        NSString *type;
        NSString *markCategory;
        
        switch (tag) {
            case 0:
                type = @"is_harass";
                markCategory = @"骚扰电话";
                break;
            case 1:
                type = @"is_delivery";
                markCategory = @"快递送餐";
                break;
            case 2:
                type = @"is_market";
                markCategory = @"广告推销";
                break;
            case 3:
                type = @"is_agent";
                markCategory = @"房产中介";
                break;
            case 4:
                type = @"is_cheater";
                markCategory = @"疑似诈骗电话";
                break;
                
            default:
                break;
        }
        
        [self uploadMarkPhoneNumber:type];
       // [self writeToContact:markCategory];
        
        [HVcardImporter CheckAddressBookAuthorization:^(bool isAuthorized) {
            if (isAuthorized) {
                HVcardImporter *importer = [[HVcardImporter alloc] init];
                [importer markMessageSaveToContacts:markCategory phoneNumber:self.inquiryPhoneNumber];
            }else {
                //TODO: 标记号码时，通讯录的权限提醒
                UIAlertView * alart = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请您设置允许APP访问您的通讯录\n设置>隐私>通讯录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alart show];
            }
        }];

    };
    
    [action showInView:self.view];
    
}



#pragma mark - 标记号码写入通讯录
- (void)writeToContact:(NSString *)markCategory {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        ABAddressBookRef addressBook = ABAddressBookCreate();
        
        __block BOOL accessGranted = NO;
        if (&ABAddressBookRequestAccessWithCompletion != NULL) {
            
            // we're on iOS 6
            NSLog(@"on iOS 6 or later, trying to grant access permission");
            
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                accessGranted = granted;
                dispatch_semaphore_signal(sema);
            });
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            
        }
        
        if (!accessGranted) {
            return;
        }
        
        ABRecordRef  blackPerson=[self checkPeopleExsit:self.inquiryPhoneNumber];
        
        if (blackPerson==nil) {
            
            [self AddPeopleWithNumber:_inquiryPhoneNumber];
            
        }else {
            
            ABAddressBookRef iPhoneAddressBook = ABAddressBookCreateWithOptions(NULL, NULL);
            CFErrorRef error = NULL;
            
            //phone number
            ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
            
            ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)(_inquiryPhoneNumber), (__bridge CFTypeRef)markCategory, NULL);
            
            ABMultiValueRef  phones = ABRecordCopyValue(blackPerson, kABPersonPhoneProperty);
            
            for(int i = 0; i < ABMultiValueGetCount(phones); i++) {
                
                CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(phones, i);
                
                ABMultiValueAddValueAndLabel(multiPhone, phoneNumberRef, (__bridge CFTypeRef)markCategory, NULL);
                
            }
            
            ABRecordSetValue(blackPerson, kABPersonPhoneProperty, multiPhone, &error);
            CFRelease(multiPhone);
            
            //picture
            ABAddressBookAddRecord(iPhoneAddressBook, blackPerson, &error);
            ABAddressBookSave(iPhoneAddressBook, &error);
            ABRecordID markedContactID = ABRecordGetRecordID(blackPerson);
            [[NSUserDefaults standardUserDefaults] setObject:@(markedContactID) forKey:@"markedContactID"];
            
            CFRelease(blackPerson);
            CFRelease(iPhoneAddressBook);
            
        }
        
    });
    

}
- (ABRecordRef)checkPeopleExsit:(NSString *)number {
    
    ABAddressBookRef addressBook =  ABAddressBookCreateWithOptions(NULL, NULL);
    CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(addressBook);
    for(int i = 0; i < CFArrayGetCount(results); i++) {
        ABRecordRef person = CFArrayGetValueAtIndex(results, i);
        //读取firstname
        NSString *firstName = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        if(firstName != nil) {
            if ([firstName isEqualToString:@"Z被标记的号码"]) {
                return person;
                
            }
            
        }
        
    }
    return nil;
    
}


- (void)AddPeopleWithNumber:(NSString *)number {
    //name
    ABAddressBookRef iPhoneAddressBook = ABAddressBookCreate();
    ABRecordRef newPerson = ABPersonCreate();
    CFErrorRef error = NULL;
    ABRecordSetValue(newPerson, kABPersonFirstNameProperty, @"#0被标记的号码", &error);
    
    //phone number
    ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    
    ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)(number), kABPersonPhoneMobileLabel, NULL);
    ABRecordSetValue(newPerson, kABPersonPhoneProperty, multiPhone, &error);
    CFRelease(multiPhone);
    
    
    //picture
    NSData *dataRef = UIImagePNGRepresentation([UIImage imageNamed:@"contact_icon"]);
    ABPersonSetImageData(newPerson, (__bridge CFDataRef)dataRef, &error);
    ABAddressBookAddRecord(iPhoneAddressBook, newPerson, &error);
    ABAddressBookSave(iPhoneAddressBook, &error);
    
    ABRecordID markedContactID = ABRecordGetRecordID(newPerson);
    [[NSUserDefaults standardUserDefaults] setObject:@(markedContactID) forKey:@"markedContactID"];

    
    CFRelease(newPerson);
    CFRelease(iPhoneAddressBook);
    
    
}


- (void)markWriteToContact:(NSString *)markCategory {
    
//    switch ([YUABHelper existPhone:self.inquiryPhoneNumber]) {
//        case ABHelperCanNotConncetToAddressBook: {
//            [YUABHelper addContactName:@"Z被标记的号码" phoneNum:self.inquiryPhoneNumber withLabel:markCategory];
//        }
//            
//            break;
//            
//        case ABHelperExistSpecificContact: {
//            [YUABHelper addContactName:@"Z被标记的号码" phoneNum:self.inquiryPhoneNumber withLabel:markCategory];
//        }
//            
//            
//            break;
//        case ABHelperNotExistSpecificContact:
//            
//            break;
//
//        default:
//            break;
//    }
    
    /**
     * 获取读写通讯录的权限
     *
     * 1. 在系统通讯录添加一个联系人“#被标记的号码” （第一次标记的时候是添加，后边的则是在这个联系人里追加）
     * 2. 新建联系人，添加标签，添加号码
     * 3. 联系人追加号码和标签。
     *
     */
    /**
     *  要使用Address Book，声明一个ABAddressBookRef实例，并用ABAddressBookCreate函数设置其值。
     *  重要提示：ABAddressBookRef实例不能在多个线程中共用。每个线程必须有其自己的实例。
     */
    
    NSError *error;
    CFErrorRef castError = (__bridge CFErrorRef)error;
    ABAddressBookRef addressBook=ABAddressBookCreateWithOptions(NULL, &castError);
    
    if (addressBook == nil) {
        return;
    }
    __block BOOL accessAllowed = NO;
    
    /**
     *  //信号量基于计数器的一种多线程同步机制。在多个线程访问共有资源时候，会因为多线程的特性而引发数据出错的问题。
     */
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    //获取读取通讯的权限
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        
        accessAllowed = granted;
        dispatch_semaphore_signal(sema);
        
    });
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    if (!accessAllowed) {
        //不允许则做出提示。
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults boolForKey:@"notFirst"]) {
        [defaults setBool:YES forKey:@"notFirst"];
        
        NSString *firstName = @"Z被标记的号码";
        //第一次的时候，要创建联系人
        ABRecordRef markedPerson=ABPersonCreate();//创建联系人
        //  后台执行：
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // something
            ABRecordSetValue(markedPerson, kABPersonFirstNameProperty,(__bridge CFStringRef)firstName, NULL);
            
            ABMultiValueRef markTexts = ABMultiValueCreateMutable(kABMultiStringPropertyType);
            
            //标签数组
            NSMutableArray *labels = [NSMutableArray arrayWithObjects:@"Z被标记的号码",markCategory, nil];
            //电话号码数组
            NSMutableArray *phones = [NSMutableArray arrayWithObjects:@"",self.inquiryPhoneNumber, nil];
            
            for (int i = 0; i < phones.count; i++) {
                ABMultiValueIdentifier multiID = ABMultiValueAddValueAndLabel(markTexts, (__bridge CFStringRef)[phones objectAtIndex:i], (__bridge CFStringRef)[labels objectAtIndex:i], &multiID);
            }
            ABRecordSetValue(markedPerson, kABPersonPhoneProperty, markTexts, NULL);
            if (markTexts) {
                CFRelease(markTexts);
            }
            ABAddressBookAddRecord(addressBook, markedPerson, NULL);
            ABAddressBookSave(addressBook, NULL);
            if (addressBook) {
                CFRelease(addressBook);
            }

        });
        
    }else {
        //追加

        //获取通讯录中的所有人
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
        //    //通讯录中人数
        //    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
        ABMultiValueRef markTexts = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        NSArray *arr = (__bridge NSArray *)allPeople;
        
        for (id obj in arr) {
            
            ABRecordRef person = (__bridge ABRecordRef)obj;
            NSString *firstName = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
            if ([firstName isEqualToString:@"Z被标记的号码"]) {
                NSMutableArray * phoneArr = [[NSMutableArray alloc] init];
                NSMutableArray * labelArr = [[NSMutableArray alloc] init];
                ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
               
                for (NSInteger j = 0; j < ABMultiValueGetCount(phones); j++) {
                    [phoneArr addObject:(__bridge NSString *)(ABMultiValueCopyValueAtIndex(phones, j))];
                    [labelArr addObject:(__bridge id)(ABMultiValueCopyLabelAtIndex(phones, j))];
                }
                //  后台执行：
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    // something
                    //TODO: 需要添加一个写入操作，看看怎么抽调出一个方法出来。
                    [phoneArr insertObject:self.inquiryPhoneNumber atIndex:1];
                    [labelArr insertObject:markCategory atIndex:1];
                    for (int i = 0; i < phoneArr.count; i++) {
                        ABMultiValueIdentifier multiID = ABMultiValueAddValueAndLabel(markTexts, (__bridge CFStringRef)[phoneArr objectAtIndex:i], (__bridge CFStringRef)[labelArr objectAtIndex:i], &multiID);
                    }
                    ABRecordSetValue(person, kABPersonPhoneProperty, markTexts, NULL);
                    ABAddressBookAddRecord(addressBook, person, NULL);
                    ABAddressBookSave(addressBook, NULL);

                    if (phones) {
                        CFRelease(phones);
                    }
                    if (markTexts) {
                        CFRelease(markTexts);
                    }
                   
                });
                
            }
            if (NULL != arr) {
                CFRelease((__bridge CFTypeRef)(arr));
            }
        }
        if (addressBook) {
            CFRelease(addressBook);
        }

    }
    
}


#pragma mark - 标记号码上传至服务器 
/**
 *  将标记的号码上传至服务器
 *
 *  @param markCategory 标记的类别
 */
- (void)uploadMarkPhoneNumber:(NSString *)markCategory {
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers]];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html", nil];
    
    
    [manager GET:[NSString stringWithFormat:@"http://www.93app.com/laidianguishu/record_user_report_number_action.php?ucode=%@&version=%@&number=%@&type=%@",UID,VERSION,self.inquiryPhoneNumber,markCategory] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSLog(@"%@",responseObject);
        
        
        if ([[responseObject objectForKey:@"status"]intValue]==1) {
            
            
            [SVProgressHUD showSuccessWithStatus:@"标记成功！"];
            
        }else {
            
            
            [SVProgressHUD showErrorWithStatus:@"标记失败！"];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"标记失败！"];
    }];
}


//*手机号码验证 MODIFIED BY HELENSONG*/
- (BOOL)isMobileNumber:(NSString *)mobileNum {
    
    mobileNum = [mobileNum stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNum = [mobileNum stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNum = [mobileNum stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNum = [mobileNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNum = [mobileNum stringByReplacingOccurrencesOfString:@"+" withString:@""];
    //    if (mobileNum.length>0&&[[mobileNum substringToIndex:2] isEqualToString:@"86"]) {
    //        mobileNum = [mobileNum stringByReplacingOccurrencesOfString:@"86" withString:@""];
    //    }
    
    if ([mobileNum hasPrefix:@"86"]) {
        
        mobileNum=[mobileNum substringFromIndex:2];
    }
    if (mobileNum.length==11) {
        return YES;
    }else {
        
        return NO;
        
    }

}

- (void)uploadNumberInfoWithPhoneNumber:(NSString *)phoneNumber typeName:(NSString *)typeName count:(int)count {
    NSString *type;
    if ([typeName isEqualToString:@"骚扰电话"]) {
        
        type=@"is_harass";
        
        
    }else if ([typeName isEqualToString:@"快递送餐"]) {
        
        type=@"is_delivery";
        
    }else if ([typeName isEqualToString:@"广告推销"]) {
        
        type=@"is_market";
        
    }else if ([typeName isEqualToString:@"房产中介"]) {
        
        type=@"is_agent";
        
    }else if ([typeName isEqualToString:@"疑似诈骗电话"]) {
        
        type=@"is_cheater";
        
    }else {
        
        type=@"is_harass";
        
    }
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers]];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html", nil];
    
    [manager GET:[NSString stringWithFormat:@"http://www.93app.com/laidianguishu/record_user_query_number_action.php?ucode=%@&version=%@&number=%@&count=%d&type=%@",UID,VERSION,phoneNumber,count,type] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}


#pragma mark - 谷歌原生广告
- (void)loadNativeAds {
    
    self.mAdLoader=[[GADAdLoader alloc]initWithAdUnitID:@"ca-app-pub-3940256099942544/3986624511" rootViewController:self adTypes:@[kGADAdLoaderAdTypeNativeAppInstall] options:@[@(GADNativeAdImageAdLoaderOptionsOrientationLandscape)]];
    
    self.mAdLoader.delegate=self;
    
    GADRequest *request=[GADRequest request];
    
    [self.mAdLoader loadRequest:request];
}
- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(GADRequestError *)error {
    
    
}
- (void)adLoader:(GADAdLoader *)adLoader
didReceiveNativeAppInstallAd:(GADNativeAppInstallAd *)nativeAppInstallAd {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        
        [self.tableView beginUpdates];
        
        adcellHeight = 80;
        
        [self.tableView endUpdates];
        
    
    }];
    
    
    self.adCell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    
    if (_mAdmobNativeView==nil) {
        _mAdmobNativeView=(GADNativeAppInstallAdView*)[[[NSBundle mainBundle]loadNibNamed:@"TestAdmob" owner:nil options:nil]objectAtIndex:0];
        
        _mAdmobNativeView.frame=CGRectMake(0, 0, SCREEN_WIDTH, _mAdmobNativeView.frame.size.height);
        
        [self.adCell.contentView addSubview:_mAdmobNativeView];
        
    }
    
    
    
    NSLog(@"%@",((GADNativeAdImage*)[nativeAppInstallAd.images firstObject]).imageURL);
    
    _mAdmobNativeView.nativeAppInstallAd=nativeAppInstallAd;
    
    _mAdmobNativeView.iconView.image=nativeAppInstallAd.icon.image;
    
    _mAdmobNativeView.headlineView.text=nativeAppInstallAd.headline;
    
    _mAdmobNativeView.bodyView.text=nativeAppInstallAd.body;
    
    
}

#pragma mark - 安沃原生广告
- (void)loadAdwoNativeAd {
//    [_mAdwoNativeView loadAWAdWithBlock:^{
//        
//    }];
//    NSDate *lastDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"loadAdLastTime"];
//    NSTimeInterval loadAdInterval = [[NSDate date] timeIntervalSinceDate:lastDate];
//    
//    if (loadAdInterval > 10 || lastDate == nil) {
//        [_mAdwoNativeView loadAdwoAD];
//    }else {
//        NSLog(@"需要加载缓存广告数据");
//    }
    
    HAdvertisementManager *manager = [HAdvertisementManager shareManager];
    [manager showBannerToParentView:_mAdwoNativeView rootViewController:self bannerAdUnitID:ADMOB_APP_ID appKey:nil placementID:nil];
}



#pragma mark - tableview delegate && datasource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section==2) {
        
        
        NSString *url=@"https://itunes.apple.com/cn/app/id999256279?mt=8";
        
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];

        
    }

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {


    if (indexPath.section==0) {
        
        return 304;
        
    }else if (indexPath.section==2) {
        return 80;
    
    }else if (indexPath.section==1) {
    
        if (indexPath.row==1) {
            return 50;//临时添加谷歌广告
        }

        return 50;
    }

    return 44;

}
- (void)loadBanner {
    
    GADBannerView *mBannerView=[[GADBannerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    [self.bannerView addSubview:mBannerView];
    mBannerView.adUnitID           = ADMOB_APP_ID;
    
    mBannerView.rootViewController = self;
    mBannerView.delegate = self;
    
    [mBannerView loadRequest:[GADRequest request]];
}
#pragma mark - 更新骚扰号码库

- (IBAction)updateNumberPlate:(UIButton *)sender {

    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"号码库更新"
                                                        message:@"最大概率的为您提示陌生骚扰来电>>"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"更新", nil];
    [alertview show];
    
    
}
#pragma mark - UIAlertView delegate 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 1) {
        if (![self isUpdateNumberPlate]) {
          
            NSLog(@"-----------更新骚扰号码库------");
            MBProgressHUD *progress=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            progress.labelText=[NSString stringWithFormat:@"正在载入号码库"];
            
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                YUVcardImporter *importer = [[YUVcardImporter alloc] init];
                [importer parse];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [progress setRemoveFromSuperViewOnHide:YES];
                    
                    progress.labelText = @"更新完毕！";
                    
                    [progress hide:YES];
                    
                });
//                [progress setRemoveFromSuperViewOnHide:YES];
//                
//                [progress hide:YES];

            });

        }else {
             [KEProgressHUD mBProgressHUD:self.view :@"号码库已更新到最新！"];
        }
       
        
    }
    
}
- (BOOL)isUpdateNumberPlate {
    BOOL isUpdated = NO;
    NSError *error;
    CFErrorRef castError = (__bridge CFErrorRef)error;
    ABAddressBookRef addressBook=ABAddressBookCreateWithOptions(NULL, &castError);
    
    __block BOOL accessAllowed = NO;
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    //获取读取通讯的权限
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        
        accessAllowed = granted;
        dispatch_semaphore_signal(sema);
        
    });
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    if (accessAllowed) {
        //获取通讯录中的所有人
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
        //    //通讯录中人数
        //    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
        
        
        NSArray *arr = (__bridge NSArray *)allPeople;
        //遍历所有联系人
        for (id obj in arr) {
            
            ABRecordRef people = (__bridge ABRecordRef)obj;
            ABMultiValueRef phone = ABRecordCopyValue(people, kABPersonPhoneProperty);
            NSString *number = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phone,0);
        
            if ([number isEqualToString:@"#SRhaoma0\n"] ||
                [number isEqualToString:@"#SRhaoma1\n"] ||
                [number isEqualToString:@"#SRhaoma2\n"] ||
                [number isEqualToString:@"#SRhaoma3\n"] ||
                [number isEqualToString:@"#SRhaoma4\n"] ||
                [number isEqualToString:@"#SRhaoma5\n"] ) {
              
                isUpdated = YES;
              
            }
        }
        ABAddressBookSave(addressBook, NULL);

    }
    // 释放通讯录对象的内存
    if (addressBook) {
        CFRelease(addressBook);
    }
    
    
    return isUpdated;
}
/**
 *  获取骚扰电话号码库的文件路径
 *
 *  @return path 字符串
 */
- (NSString *)getNumberPlatePath{
    
    NSString * path = [[NSBundle mainBundle]pathForResource:@"Contacts" ofType:@"vcf"];
    
    return path;
    
}

/**
 *  将骚扰号码数据写入系统通讯录
 *
 *  @param data 骚扰号码数据
 */
- (void)importVcardToContact:(CFDataRef)data {
 
    /**
     *  要使用Address Book，声明一个ABAddressBookRef实例，并用ABAddressBookCreate函数设置其值。
     *  重要提示：ABAddressBookRef实例不能在多个线程中共用。每个线程必须有其自己的实例。
     */
    
    NSError *error;
    CFErrorRef castError = (__bridge CFErrorRef)error;
    ABAddressBookRef addressBook=ABAddressBookCreateWithOptions(NULL, &castError);
    
    if (addressBook == nil) {
        return;
    }
    __block BOOL accessAllowed = NO;
    
    /**
     *  //信号量基于计数器的一种多线程同步机制。在多个线程访问共有资源时候，会因为多线程的特性而引发数据出错的问题。
     */
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    //获取读取通讯的权限
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        
        accessAllowed = granted;
        dispatch_semaphore_signal(sema);
        
    });
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    if (!accessAllowed) {
        //不允许则做出提示。
        return;
    }
    
    ABRecordRef ref = ABAddressBookCopyDefaultSource(addressBook);
    CFArrayRef contacts=ABPersonCreatePeopleInSourceWithVCardRepresentation(ref, data);
    
    for (CFIndex index = 0; index < CFArrayGetCount(contacts); index++) {
        
        ABRecordRef person = CFArrayGetValueAtIndex(contacts, index);
        ABAddressBookAddRecord(addressBook, person, NULL);
        ABAddressBookSave(addressBook, NULL);
        
        CFRelease(person);
    }
    
    
    //释放内存
    CFRelease(ref);
    CFRelease(addressBook);

}

@end
