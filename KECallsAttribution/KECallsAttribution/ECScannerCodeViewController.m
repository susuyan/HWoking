//
//  ECScannerCodeViewController.m
//  Utilities
//
//  Created by 赵 进喜 on 14-7-23.
//  Copyright (c) 2014年 everzones. All rights reserved.
//

#import "ECScannerCodeViewController.h"
#import "ZBarCameraSimulator.h"
#import "EZResultTableVC.h"

@interface ECScannerCodeViewController ()

@end

@implementation ECScannerCodeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc
{
    
    
    
    
    [mReaderView stop];
    
    [mReaderView flushCache];
    
    mReaderView=nil;
  //  mItems=nil;
    
  //  resultHeader=nil;
    
    line=nil;
    
    [mTimer invalidate];
    
   // mItems=nil;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];


    [mReaderView stop];
    
    [mReaderView flushCache];
    [MobClick endLogPageView:@"saomabijia"];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"saomabijia"];
    
    
    
    [mReaderView start];
    
    [self startMove];


}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    
    
    
  //  _resultTabView.hidden=YES;
    
    
  //  mItems=[[NSMutableArray alloc]initWithCapacity:10];
    
//    self.resultTabView.delegate=self;
//    self.resultTabView.dataSource=self;
    
    
    
    
      
    
    
   
    
    
    
    
    mReaderView=[[ZBarReaderView alloc]init];
    [mReaderView setAllowsPinchZoom:YES];
    mReaderView.frame=CGRectMake(4, 4, 292, 192);
    mReaderView.readerDelegate=self;
    
    mReaderView.torchMode=0;
    
    
    //扫描区域
    CGRect scanMaskRect = CGRectMake(4, 4, 292, 192);
    
    //处理模拟器
    if (TARGET_IPHONE_SIMULATOR) {
        ZBarCameraSimulator *cameraSimulator
        = [[ZBarCameraSimulator alloc]initWithViewController:self];
        cameraSimulator.readerView = mReaderView;
    }
    [self.readerViewBg addSubview:mReaderView];
    //扫描区域计算
    mReaderView.scanCrop = [self getScanCrop:scanMaskRect readerViewBounds:mReaderView.bounds];
    
    
    
    line=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gr_scanline"]];
    line.frame=CGRectMake(0, 0, 300, 2);
    [self.readerViewBg addSubview:line];
    
    
    
    
    
    
    
   // [self initNav];
    
    
    
    
    

//    [mReaderView start];
//    [self startMove];
    
    
    
    // Do any additional setup after loading the view.
}

//-(void)initNav
//{
//
//
//
//    
//    if (IS_IOS7) {
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbg2_ios7"] forBarMetrics:UIBarMetricsDefault];
//    }else
//    {
//        
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbg2"] forBarMetrics:UIBarMetricsDefault];
//        
//        
//    }
//
//    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor, nil]];
//
//
//}


- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    
    //NSLog(@"%@",symbols);
    
    
    
    
    for (ZBarSymbol *symbol in symbols) {
        NSLog(@"%@", symbol.data);
        
        
        code=symbol.data;
        
        
       // _resultTabView.hidden=NO;
       // _scannerhelper.hidden=YES;
        
        
        break;
    }
    
    [readerView stop];
    [self stopMove];
    
    
   // [self dealWithCode:code];
    
    
    
    EZResultTableVC *result=[self.storyboard instantiateViewControllerWithIdentifier:@"EZResultTableVC"];
    result.myCode=code;
    
    [self.navigationController pushViewController:result animated:YES];
    
    
    
    
}





-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    CGFloat x,y,width,height;
    
    x = rect.origin.x / readerViewBounds.size.width;
    y = rect.origin.y / readerViewBounds.size.height;
    width = rect.size.width / readerViewBounds.size.width;
    height = rect.size.height / readerViewBounds.size.height;
    
    return CGRectMake(x, y, width, height);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)startMove
{


  mTimer=[NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(moveLine) userInfo:nil repeats:YES];

}

-(void)stopMove
{

    [mTimer invalidate];

}

-(void)moveLine
{

    [UIView animateWithDuration:2 animations:^{
    
    
        line.transform=CGAffineTransformMakeTranslation(0, 200);
    
    } completion:^(BOOL finished) {
        
        
        if (finished) {
            
            [UIView animateWithDuration:2 animations:^{
                
                
                line.transform=CGAffineTransformMakeTranslation(0, 0);
                
            }];

            
            
        }
        
    }];

  



}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)back:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



@end
