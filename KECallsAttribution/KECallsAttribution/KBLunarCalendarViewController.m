//
//  KBLunarCalendarViewController.m
//  KECallsAttribution
//
//  Created by lichenWang on 14-4-3.
//  Copyright (c) 2014年 K.BLOCK. All rights reserved.
//

#import "KBLunarCalendarViewController.h"
#import "TFHpple.h"
#import "Reachability.h"
#import "KEProgressHUD.h"
#import "KBLunarCalendarCell.h"
#import "MBProgressHUD.h"
@interface KBLunarCalendarViewController ()
@property (nonatomic, strong)NSMutableArray * contentArray;
@end

@implementation KBLunarCalendarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.contentArray = [NSMutableArray array];
    NSDictionary * dic = [self getTimeWithDate:[NSDate date]];
    self.yearAndMonthLabel.text = [NSString stringWithFormat:@"%@ 年 %@月",dic[@"Year"],dic[@"Month"]];
    self.dayLabel.text = dic[@"Day"];
    self.weekLabel.text = dic[@"Week"];
    
    
    _strPath =@"http://laohuangli.51240.com/";
    
    // Do any additional setup after loading the view.
}


-(void)initDatePicker_iOS8
{

  UIDatePicker  *_datePicker=[[UIDatePicker alloc]init];
    _datePicker.datePickerMode=UIDatePickerModeDate;
    
   
    
    //定义最小日期
    NSDateFormatter *formatter_minDate = [[NSDateFormatter alloc] init];
    [formatter_minDate setDateFormat:@"yyyy-MM-dd"];
    NSDate *minDate = [formatter_minDate dateFromString:@"2008-01-01"];


    //最大日期是今天
    NSDateFormatter *formatter_maxDate = [[NSDateFormatter alloc] init];
    [formatter_maxDate setDateFormat:@"yyyy-MM-dd"];
    NSDate *maxDate = [formatter_minDate dateFromString:@"2030-12-31"];

    
    [_datePicker setMinimumDate:minDate];
    [_datePicker setMaximumDate:maxDate];
       
    
    
    
    
    
  UIAlertController*  _dateActionView=[UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
   
   [_dateActionView addAction:[UIAlertAction actionWithTitle:@"确认日期" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
       
       
       NSDate *date=_datePicker.date;
       
       NSDateFormatter *formater=[[NSDateFormatter alloc]init];
       [formater setDateFormat:@"YYYY-MM-dd"];
       
       NSString *strDate=[formater stringFromDate:date];
       
   
       _strPath=[NSString stringWithFormat:@"http://laohuangli.51240.com/%@__laohuangli/",strDate];
       [self lunarCalendar];
       
       
       NSDictionary * dic = [self getTimeWithDate:date];
       self.yearAndMonthLabel.text = [NSString stringWithFormat:@"%@ 年 %@月",dic[@"Year"],dic[@"Month"]];
       self.dayLabel.text = dic[@"Day"];
       self.weekLabel.text = dic[@"Week"];

       
   }]];
    
      [_dateActionView.view addSubview:_datePicker];
    
    
    
    [self presentViewController:_dateActionView animated:YES completion:nil];
    
    
    
    
    
    


}


-(void)initDatePicker
{
    
    UIDatePicker  *_datePicker=[[UIDatePicker alloc]init];
    _datePicker.datePickerMode=UIDatePickerModeDate;
    _datePicker.tag=1111;
    
    UIActionSheet *_dateActionView=[[UIActionSheet alloc]initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"确认日期" destructiveButtonTitle:nil otherButtonTitles:nil, nil];

    
    
    
    [_dateActionView addSubview:_datePicker];
    
    [_dateActionView showInView:self.view];
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    UIDatePicker *_datePicker=(UIDatePicker *)[actionSheet viewWithTag:1111];
    
    NSDate *date=_datePicker.date;
    
    NSDateFormatter *formater=[[NSDateFormatter alloc]init];
    [formater setDateFormat:@"YYYY-MM-dd"];
    
    NSString *strDate=[formater stringFromDate:date];
    
    
    _strPath=[NSString stringWithFormat:@"http://laohuangli.51240.com/%@__laohuangli/",strDate];
    [self lunarCalendar];
    
    
    NSDictionary * dic = [self getTimeWithDate:date];
    self.yearAndMonthLabel.text = [NSString stringWithFormat:@"%@ 年 %@月",dic[@"Year"],dic[@"Month"]];
    self.dayLabel.text = dic[@"Day"];
    self.weekLabel.text = dic[@"Week"];


}




- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"wannianli"];
}
-(void)viewWillDisappear:(BOOL)animated
{

    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"wannianli"];

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self lunarCalendar];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSDictionary*)getTimeWithDate:(NSDate *)date{
    NSInteger year,month,day,hour,min,sec,week;
    NSString *weekStr=nil;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now = date;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    comps = [calendar components:unitFlags fromDate:now];
    year = [comps year];
    week = [comps weekday];
    month = [comps month];
    day = [comps day];
    hour = [comps hour];
    min = [comps minute];
    sec = [comps second];
    
    if(week==1){
        weekStr=@"星期天";
    }else if(week==2){
        weekStr=@"星期一";
    }else if(week==3){
        weekStr=@"星期二";
    }else if(week==4){
        weekStr=@"星期三";
    }else if(week==5){
        weekStr=@"星期四";
    }else if(week==6){
        weekStr=@"星期五";
    }else if(week==7){
        weekStr=@"星期六";
    }else {
        NSLog(@"error!");
    }

    NSInteger Monday = day - week+1+1;
    for (int i=1; i<=7; i++) {
        Monday=Monday+1;
    }
    return @{@"Year":[NSString stringWithFormat:@"%d",year],
            @"Month":[NSString stringWithFormat:@"%d",month],
              @"Day":[NSString stringWithFormat:@"%d",day],
             @"Week":weekStr};
}
- (void)getLunarCalendarData{
    
    
    [self.contentArray removeAllObjects];
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [KEProgressHUD mBProgressHUD:self.view :@"无法链接网络,请检查网络链接!"];
        return;
    }
    
    //http://laohuangli.51240.com/2014-10-21__laohuangli/
    NSString *path=self.strPath;
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * url = [NSURL URLWithString:path];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    NSData * data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:nil
                                                      error:nil];
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:data];
    NSString *xpathQuery = @"//td[@bgcolor='#FFFFFF']";//Query Title
    NSMutableArray *elementsTitle  = [[xpathParser searchWithXPathQuery:xpathQuery] mutableCopy];
    [elementsTitle enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        TFHppleElement * element = obj;
        for (TFHppleElement *childElement in [element children]) {
            [self.contentArray addObject:childElement.content];
        }
    }];
    if (self.contentArray.count == 7) {
        [self.contentArray insertObject:@"" atIndex:2];
    }else if (self.contentArray.count <7){
        [self.contentArray removeAllObjects];
        for (int i = 0; i < 8; i++) {
            [self.contentArray addObject:@"-"];
        }
    }
}
- (void)lunarCalendar{
    MBProgressHUD * progressHUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    progressHUD.mode = MBProgressHUDModeIndeterminate;
    progressHUD.animationType = MBProgressHUDAnimationZoom;
    progressHUD.labelText = @"正在加载...";
    dispatch_queue_t queue =
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [self getLunarCalendarData];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString * string = [self.contentArray firstObject];
            NSArray * testArray = [string componentsSeparatedByString:@"（"];
            string = [[testArray lastObject] stringByReplacingOccurrencesOfString:@"）" withString:@""];
            NSArray * lunarCalendar = [string componentsSeparatedByString:@" "];
            NSArray * lunar = [[lunarCalendar firstObject] componentsSeparatedByString:@"："];
            if (lunarCalendar.count >3) {
                self.lunarCalendarLabel.text = [NSString stringWithFormat:@"%@ %@%@ %@",[lunar lastObject],lunarCalendar[1],lunarCalendar[2],lunarCalendar[3]];
            }
            [self.contentArray removeObject:[self.contentArray firstObject]];
            
            
            NSLog(@"%@",self.contentArray);
            [self.contentArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                switch (idx) {
                    case 0:
                        self.yiLabel.text = obj;
                        break;
                    case 1:
                        self.jiLabel.text = obj;
                        break;
                    case 2:
                        self.chongLabel.text = obj;
                        break;
                    case 3:
                        self.shaLabel.text = obj;
                        break;
                    case 4:
                        self.chengLabel.text = obj;
                        break;
                    case 5:
                        self.zhengchongLabel.text = obj;
                        break;
                    case 6:
                        self.jingriLabel.text = obj;
                        break;
                    case 7:
                        self.jieqiLabel.text = obj;
                        break;
                    default:
                        break;
                }
            }];
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        });
    });
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return self.contentArray.count;
//}
//
//
// - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
// {
//   KBLunarCalendarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
//     cell.name.text =[NSString stringWithFormat:@"%@ :",self.keyArray[indexPath.row]];
//     cell.content.text = self.contentArray[indexPath.row];
//   return cell;
// }
- (NSString*)block:(NSString*)string{
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    return string;
}
- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)showDatePicker:(UIButton *)sender {
    
    if (IS_IOS8) {
        [self initDatePicker_iOS8];
    }else
    {
        [self initDatePicker];

    }
    
   }
@end
