//
//  SystemServicesDemoDiskViewController.m
//  SystemServicesDemo
//
//  Created by Kramer on 4/4/13.
//  Copyright (c) 2013 Shmoopi LLC. All rights reserved.
//

#import "SystemServicesDemoDiskViewController.h"
#import "SystemServices.h"
#import "SDLoopProgressView.h"
#import "SDProgressView.h"

#import "SDDemoItemView.h"
#define SystemSharedServices [SystemServices sharedServices]

@interface SystemServicesDemoDiskViewController ()

@property (nonatomic, strong) NSMutableArray *demoViews;
@end

@implementation SystemServicesDemoDiskViewController
- (NSMutableArray *)demoViews
{
    if (_demoViews == nil) {
        _demoViews = [NSMutableArray array];
    }
    return _demoViews;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"asd"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"asd"];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UILabel *tittle=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    [tittle setBackgroundColor:[UIColor clearColor]];
    [tittle setTextColor:[UIColor whiteColor]];
    tittle.text=@"空间";
    [tittle setTextAlignment:NSTextAlignmentCenter];
    [tittle setFont:[UIFont systemFontOfSize:24]];
    self.navigationItem.titleView=tittle;
    /*******************************/
    self.lbl_space.text = [NSString stringWithFormat:@"%@",[SystemSharedServices freeDiskSpaceinRaw]];
    //NSLog(@"%@",[SystemSharedServices freeDiskSpaceinRaw]);
    self.lbl_total.text = [NSString stringWithFormat:@"全部 %@",[SystemSharedServices diskSpace]];
    self.lbl_used.text  = [NSString stringWithFormat:@"已使用 %@",[SystemSharedServices usedDiskSpaceinRaw]];
    
    /*
    SDLoopProgressView *loop = [SDLoopProgressView progressView];
    
    loop.frame = CGRectMake(100, 100, 100, 100) ;
    
   // loop.progress = ([SystemSharedServices freeMemoryinRaw]/ [SystemSharedServices longDiskSpace]); // 加载进度，当加载完成后会自动隐藏
    [self.view addSubview: loop];
     [self.demoViews addObject:[SDDemoItemView demoItemViewWithClass:[SDLoopProgressView class]]];
    [self setupSubviews];
    [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(progressSimulation) userInfo:self repeats:YES];
     */
}
- (void)setupSubviews
{
    int perrowCount= 2;
    CGFloat w = 100;
    CGFloat h = w;
    CGFloat margin = (self.view.frame.size.width - perrowCount * w) / (perrowCount + 1);
    [self.demoViews enumerateObjectsUsingBlock:^(SDDemoItemView *demoView, NSUInteger idx, BOOL *stop) {
        int rowIndex = idx / perrowCount;
        int columnIndex = idx % perrowCount;
        CGFloat x = margin + (w + margin) * columnIndex;
        CGFloat y = margin + (h + margin) * rowIndex;
        demoView.frame = CGRectMake(x, y, w, h);
        [self.view addSubview:demoView];
    }];
}
- (void)progressSimulation
{
    static CGFloat progress = 0;
    
    if (progress < 1.0) {
        progress += 0.01;
        double a = [SystemSharedServices freeMemoryinRaw];
        double b  =[SystemSharedServices totalMemory];
        NSInteger i = ([SystemSharedServices freeMemoryinRaw]/ [SystemSharedServices totalMemory]);
        // 循环
        if (progress >= 1) progress = 0;
        
        [self.demoViews enumerateObjectsUsingBlock:^(SDDemoItemView *demoView, NSUInteger idx, BOOL *stop) {
            demoView.progressView.progress = progress;
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back_home:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
