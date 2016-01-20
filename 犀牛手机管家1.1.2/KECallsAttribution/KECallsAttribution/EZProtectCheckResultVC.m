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
#import "HVcardImporter.h"
#import "HNumberForRequestManager.h"
@implementation EZProtectCheckResultVC
#pragma mark - LifeCycle
-(void)viewDidLoad
{

    [super viewDidLoad];
    
    _mReach=[Reachability reachabilityForInternetConnection];
    
    currentKey=@"12994";
    currentSign=@"7dda216c0f371003681e03736feb3de2";

    
    self.markLbl.alpha = 0;
    
    self.infoLbl.alpha=0;
    
    self.markButton.alpha=0;

    
    NSArray *images=[NSArray arrayWithObjects:[UIImage imageNamed:@"saorao"],[UIImage imageNamed:@"zhapian"],[UIImage imageNamed:@"fangdichan"],[UIImage imageNamed:@"guanggao"],[UIImage imageNamed:@"kuaidi"], nil];

    _resultImageView.animationImages = images;
    //按照原始比例缩放图片，保持纵横比
    _resultImageView.contentMode = UIViewContentModeScaleAspectFit;
    //切换动作的时间3秒，来控制图像显示的速度有多快，
    _resultImageView.animationDuration = 0.5;
    //动画的重复次数，想让它无限循环就赋成0
    _resultImageView.animationRepeatCount = 0;
    
    [self checkNumber];
    

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
    
    [MobClick endLogPageView:@"haomabiaoji"];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"haomabiaoji"];
    
    
}

-(void)startAnimation
{
     [self.resultImageView startAnimating];

}

-(void)stopAnimation
{
    [self.resultImageView stopAnimating];
}
-(void)checkNumber
{
    
    
    if ([_mReach currentReachabilityStatus] == NotReachable) {
      UIAlertView *alert= [ [UIAlertView alloc]initWithTitle:@"网络无法连接" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        
        [self stopAnimation];
        
        self.loadingLbl.text=@"网络无法连接";
        
        
        self.resultImageView.image=[UIImage imageNamed:@"error_icon"];
        
        
        [alert show];
        return;
        
        
    }
    
    if (![self isMobileNumber:_inquiryPhoneNumber]) {
        
        
        
//        UIAlertView *alert= [ [UIAlertView alloc]initWithTitle:@"号码格式不对!" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        
        [self stopAnimation];
        
        
        self.loadingLbl.text=@"手机或固话号码格式不对！";
        
        
        self.resultImageView.image=[UIImage imageNamed:@"error_icon"];
        
        
       // [alert show];
        return;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               

        
        
        
    }
    
    if ([_inquiryPhoneNumber hasPrefix:@"0"]) {
        
        [self startAnimation];
        //TODO: 处理固话的骚扰号码信息
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
                self.infoLbl.alpha=1.0;
                self.infoLbl.text=[NSString stringWithFormat:@"%@ 未发现标记行为",self.inquiryPhoneNumber];
                self.resultImageView.image=[UIImage imageNamed:@"error_icon"];
            }

            [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{

                    self.markLbl.alpha = 1.0;
                    self.infoLbl.alpha=1.0;
                    self.markButton.alpha=1.0;
                    self.loadingLbl.alpha=0;
                
            } completion:nil];
            
        } completionBlockWithFailure:^(NSError *error) {
            self.loadingLbl.text=@"查询失败";
            [self stopAnimation];
            
        }];
        
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
                    }else
                    {
                    
                        address=[NSString stringWithFormat:@"%@ %@",address,addressArr[i]];
                    
                    }
                }
                
                
              
                
                self.markLbl.text = address;
                
                self.infoLbl.text=[NSString stringWithFormat:@"%@ 未发现标记行为",self.inquiryPhoneNumber];
                
            }else{
                
                if (![self.inquiryPhoneNumber hasPrefix:@"0"]) {
                    
                    
                    [SVProgressHUD showErrorWithStatus:@"出现错误，请稍后再试"];
                    self.loadingLbl.text=@"查询失败";
                  
                    [self stopAnimation];
                    
                    
                    self.resultImageView.image=[UIImage imageNamed:@"error_icon"];
                    
                    
                }
                
                
            }
            
            
            
        });
    });








}


- (void)test {
    [self startAnimation];
    
    NSString *urlStringFor360 = [NSString stringWithFormat:@"http://www.so.com/s?ie=utf-8&shb=1&src=360sou_home&q=%@",self.inquiryPhoneNumber];
    NSString *urlStringFork780 = [NSString stringWithFormat:@"http://api.k780.com:88/?app=phone.get&phone=%@&appkey=%@&sign=%@&format=json",self.inquiryPhoneNumber,currentKey,currentSign];
    HNumberForRequestManager *manager = [HNumberForRequestManager shareInstance];
    [manager queryNumberMarkedInfoForURL:urlStringFor360 completionBlockWithSuccess:^(id responseObject) {
        [self stopAnimation];
        NSLog(@"responseObject---%@",responseObject);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            int count = [responseObject[@"user_record_times"] intValue];
            if (count>0) {
                self.markLbl.text = responseObject[@"phone_number_type"];
                NSString *strCount=[NSString stringWithFormat:@"%d",count];
                NSMutableAttributedString *mark=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"已被%d人标记 %@",count,self.inquiryPhoneNumber]];
                NSRange range=NSMakeRange(2, strCount.length);
                [mark addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
                self.infoLbl.attributedText = mark;
                if (check_result) {
                    [self setResultShowIcon:self.markLbl.text];
                }
                [self uploadNumberInfoWithPhoneNumber:self.inquiryPhoneNumber typeName:self.markLbl.text count:count];
                
                [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    
                    if (check_result) {
                        
                        self.markLbl.alpha = 1.0;
                        
                        self.infoLbl.alpha=1.0;
                        
                        
                        self.markButton.alpha=1.0;
                        
                        
                    }
                    
                } completion:nil];
                
            }else {
                [self stopAnimation];
                if (check_result) {
                    self.resultImageView.image=[UIImage imageNamed:@"result_icon"];
                }
                
            }
            
        });
        
        
    } completionBlockWithFailure:^(NSError *error) {
        [self stopAnimation];
        
        self.loadingLbl.text=@"查询失败";
        self.resultImageView.image=[UIImage imageNamed:@"error_icon"];
    }];
    
    [manager queryPhoneNumberLocaleInfoForURL:urlStringFork780 completionBlockWithSuccess:^(id responseObject) {
        NSLog(@"------%@",responseObject);
        [self startAnimation];
        
        if ([responseObject[@"success"] intValue] == 1) {
            
            check_result = YES;
            
            NSArray *addressArr=[responseObject[@"result"][@"style_simcall"]componentsSeparatedByString:@","];
            NSString *address=@"";
            for (int i=0; i<addressArr.count; i++) {
                if (i==0) {
                    address=addressArr[i];
                }else {
                    
                    address=[NSString stringWithFormat:@"%@ %@",address,addressArr[i]];
                    
                }
            }
            
            self.markLbl.text = address;
        }else {
            [SVProgressHUD showErrorWithStatus:@"出现错误，请稍后再试"];
            self.loadingLbl.text=@"查询失败";
            
            [self stopAnimation];
            
            
            self.resultImageView.image=[UIImage imageNamed:@"error_icon"];
        }
        
    } completionBlockWithFailure:^(NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"出现错误，请稍后再试"];
        self.loadingLbl.text=@"查询失败";
        
        [self stopAnimation];
        
        
        self.resultImageView.image=[UIImage imageNamed:@"error_icon"];
        
    }];

}



-(void)getBlacklistData {
    
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
-(void)getDataFromServerWith:(NSString *)dataString
{
    
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
        NSString* len = [NSString stringWithFormat:@"%d",[body length]];
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
                    
                    
                }else
                {
                
                    [self stopAnimation];
                    
                    
                    if (check_result) {
                        self.resultImageView.image=[UIImage imageNamed:@"result_icon"];
                    }
                    
//                    else
//                    {
//                    
//                        self.resultImageView.image=[UIImage imageNamed:@"error_icon"];
//                    
//                    
//                    }
                    
                    
                
                
                
                
                }
                
                
                
                
                
                [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    
                    
                    
                    if (check_result) {
                        
                        
                        self.markLbl.alpha = 1.0;
                        
                        self.infoLbl.alpha=1.0;
                        
                        
                        self.markButton.alpha=1.0;

                        
                    }
                    
                    
                    self.loadingLbl.alpha=0;
                    
                } completion:nil];

                
                
                
            }else
            {
            
            
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




-(void)setResultShowIcon:(NSString *)typeName
{



    NSString *imageName;
    
    
    
    if ([typeName isEqualToString:@"骚扰电话"]) {
        
        
         imageName=@"saorao";
        
    }else if ([typeName isEqualToString:@"快递送餐"]) {
        
        
        
         imageName=@"kuaidi";
        
        
    }else if ([typeName isEqualToString:@"广告推销"]) {
        
        
         imageName=@"guanggao";
        
        
    }else if ([typeName isEqualToString:@"房产中介"]) {
        
       
         imageName=@"fangdichan";
        
        
    }else if ([typeName isEqualToString:@"疑似诈骗电话"]) {
        
       
        imageName=@"zhapian";
        
    }else{
        
        imageName=@"zhapian";
        
    }



    self.resultImageView.image=[UIImage imageNamed:imageName];


}




- (IBAction)markNumber:(UIButton *)sender {
    
    [self showAddMarkView];
    
}

- (IBAction)backButtonPressed:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark 添加标记

-(void)showAddMarkView
{
    
    
    
    EZCustomActionView *action=[[EZCustomActionView alloc]init];
    
    action.touchMenuBlock=^(int tag){
        
        
        
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
        
        
        AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
        
        [manager setRequestSerializer:[AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted]];
        [manager setResponseSerializer:[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers]];
        manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html", nil];
        
        
        [manager GET:[NSString stringWithFormat:@"http://www.93app.com/laidianguishu/record_user_report_number_action.php?ucode=%@&version=%@&number=%@&type=%@",UID,VERSION,self.inquiryPhoneNumber,type] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            
            NSLog(@"%@",responseObject);
            
            
            if ([[responseObject objectForKey:@"status"]intValue]==1) {
                
                
                [SVProgressHUD showSuccessWithStatus:@"标记成功！"];
                
            }else
            {
                
                
                [SVProgressHUD showErrorWithStatus:@"标记失败！"];
                
            }
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
            [SVProgressHUD showErrorWithStatus:@"标记失败！"];
            
        }];
        
        
        
        
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


//*手机号码验证 MODIFIED BY HELENSONG*/
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    
    
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
    }else
    {
        
        return NO;
        
    }
    
    
    
}



-(void)uploadNumberInfoWithPhoneNumber:(NSString *)phoneNumber typeName:(NSString *)typeName count:(int)count
{
    
    
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
        
    }else
    {
        
        type=@"is_harass";
        
    }
    
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers]];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html", nil];
    
    [manager GET:[NSString stringWithFormat:@"http://www.93app.com/laidianguishu/record_user_query_number_action.php?ucode=%@&version=%@&number=%@&count=%d&type=%@",UID,VERSION,phoneNumber,count,type] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSLog(@"%@",responseObject);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
    
    
    
    
}



@end
