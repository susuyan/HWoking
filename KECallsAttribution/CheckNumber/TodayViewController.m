//
//  TodayViewController.m
//  CheckNumber
//
//  Created by 赵 进喜 on 15/7/7.
//  Copyright (c) 2015年 K.BLOCK. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>
{
    
    
    NSString *copyNumber;
    NSString *currentKey;
    NSString *currentSign;
    
    
}
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self getCopyString];
    
    currentKey=@"12994";
    currentSign=@"7dda216c0f371003681e03736feb3de2";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    
    
    
    
    self.tipsLbl.hidden=NO;
    
    
    
    self.loadingLbl.hidden=YES;
    
    
    self.showResultView.hidden=YES;
    
    
    self.markLbl.text=@"";
    
    self.addressAndCarrierLbl.text=@"";
    
    
    
    
    [self getCopyString];
    
    
    
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    
    
    
    
    
    NSLog(@"%@",copyNumber);
    
    
    copyNumber=[copyNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    copyNumber=[copyNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    copyNumber=[copyNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    copyNumber=[copyNumber stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    copyNumber = [[copyNumber componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
    
    
    
    if ([self matchNumber:copyNumber]) {
        
        
        self.tipsLbl.hidden=YES;
        
        
        self.loadingLbl.text=[NSString stringWithFormat:@"正在查询 %@",copyNumber];
        
        
        self.loadingLbl.hidden=NO;
        
        
        
        [self inqueryNumber];
        
        
        
    }
    
    
    completionHandler(NCUpdateResultNewData);
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
    
}


-(void)getCopyString {
    
    
    UIPasteboard *board=[UIPasteboard generalPasteboard];
    
    copyNumber=board.string;
    
}



-(BOOL)matchNumber:(NSString *)str {
    
    
    
    NSString *regEx=@"^[0-9]+$";
    
    
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEx];
    
    
    
    BOOL isMatch   = [predicate evaluateWithObject:str];
    
    
    return isMatch;
    
    
}

-(void)inqueryNumber {
    
    [self getBlacklistData];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSString * string = [NSString stringWithFormat:@"http://api.k780.com:88/?app=phone.get&phone=%@&appkey=%@&sign=%@&format=json",copyNumber,currentKey,currentSign];
        NSURL * formUrl = [NSURL URLWithString:string];
        NSLog(@"%@",string);
        NSURLRequest * request = [NSURLRequest requestWithURL:formUrl];
        NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            //[self.activityIndicatorView stopAnimating];
            if (data == nil) {
                
                
                self.loadingLbl.hidden=YES;
                
                self.showResultView.hidden=NO;
                
                self.tipsLbl.hidden=YES;
                
                
                
                //  self.markLbl.text=@"未发现骚扰行为";
                
                
                self.numberLbl.text=copyNumber;
                
                
                return ;
            }
            NSDictionary * dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSLog(@"%@",dictionary);
            
            if ([dictionary[@"success"] integerValue] == 1) {
                
                
                
                
                
                // cell2.textLabel.text = [NSString stringWithFormat:@"中国%@",dictionary[@"result"][@"operators"]];
                
                
                NSArray *addressArr=[dictionary[@"result"][@"style_simcall"]componentsSeparatedByString:@","];
                
                
                NSString *address=[addressArr lastObject];
                
                NSString *carrier=dictionary[@"result"][@"operators"];
                
                
                
                self.addressAndCarrierLbl.text = [NSString stringWithFormat:@"%@ %@",address,carrier];
                
                
                
                
                
                
                self.loadingLbl.hidden=YES;
                
                self.showResultView.hidden=NO;
                
                self.tipsLbl.hidden=YES;
                
                
                
                //                self.markLbl.text=@"未发现骚扰行为";
                
                
                self.numberLbl.text=copyNumber;
                
                
                
                
            }else{
                
                
                
                
                
                
                
                
                self.loadingLbl.hidden=YES;
                
                self.showResultView.hidden=NO;
                
                self.tipsLbl.hidden=YES;
                
                
                
                //                self.markLbl.text=@"未发现骚扰行为";
                
                
                self.numberLbl.text=copyNumber;
                
                
                
                
                
            }
            
            
            
            
            
            
        });
    });
    
    
    
    
    
    
    
}





-(void)getBlacklistData
{
    
    
    
    
    
    
    __block  NSString *dataString;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        
        
        
        
        
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.so.com/s?ie=utf-8&shb=1&src=360sou_home&q=%@",copyNumber]];
        
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
            
            self.markLbl.text=@"未发现骚扰行为";
            
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([dataDic[@"status"] integerValue] == 1){
                
                
                
                
                
                int count=[dataDic[@"user_record_times"] intValue];
                
                
                if (count>0) {
                    
                    
                    NSString *type  =dataDic[@"phone_number_type"];
                    
                    
                    
                    
                    
                    NSString *strCount=[NSString stringWithFormat:@"%d",count];
                    
                    NSMutableAttributedString *mark=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ 被标记 %d 次",type,count]];
                    
                    NSRange range=NSMakeRange(type.length+5, strCount.length);
                    
                    
                    [mark addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
                    
                    //   cell3.detailTextLabel.text = [NSString stringWithFormat:@"\n该号码被标记 %d 次",count];
                    
                    self.markLbl.attributedText = mark;
                    
                    
                    
                    
                    
                    
                }else
                {
                    
                    
                    
                    
                    self.markLbl.text=@"未发现骚扰行为";
                    
                    
                    
                }
                
                
                
                UIPasteboard *board=[UIPasteboard generalPasteboard];
                board.string=@"";
                
                
                
                
            }
        });
    });
    
    
    
    
}
- (NSString *)URLEncodeString:(NSString *)string {
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR("% '\"?=&+<>;:-"), kCFStringEncodingUTF8));
    return result;
}

- (IBAction)quitCkeck:(UIButton *)sender {
    
    
    self.tipsLbl.hidden=NO;
    
    
    
    self.loadingLbl.hidden=YES;
    
    
    self.showResultView.hidden=YES;
    
    
    self.markLbl.text=@"";
    
    self.addressAndCarrierLbl.text=@"";
    
    
    
    
    
}

- (IBAction)dailNumber:(UIButton *)sender {
    
    
    NSString *deviceType = [UIDevice currentDevice].model;
    if([deviceType  isEqualToString:@"iPod touch"]||[deviceType  isEqualToString:@"iPad"]||[deviceType  isEqualToString:@"iPhone Simulator"]){
        
        
        
        //        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"您的设备不支持电话功能" message:nil preferredStyle:UIAlertControllerStyleAlert];
        //
        //
        //
        //        [self presentViewController:alert animated:YES completion:nil];
        //
        //        return;
        
    }
    
    
    
    
    
    NSExtensionContext *context=[self extensionContext];
    
    //[context openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",number]] completionHandler:nil];
    
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",copyNumber]] ;
    
    
    
    
    
    
    [context openURL:url completionHandler:^(BOOL success) {
        
        
        
        
        
    }];
    
    
}
- (IBAction)goToHost:(UITapGestureRecognizer *)sender {
    
    
    NSExtensionContext *context=[self extensionContext];
    
    //[context openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",number]] completionHandler:nil];
    
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@://",@"com.93app.shoujiguishudi"]] ;
    
    [context openURL:url completionHandler:^(BOOL success) {
        
        
        
        
        
    }];
    
}
@end
