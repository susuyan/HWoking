//
//  EZLifePagesController.m
//  KECallsAttribution
//
//  Created by EverZones on 15/12/3.
//  Copyright © 2015年 K.BLOCK. All rights reserved.
//

#import "EZLifePagesController.h"
#import "PendulumView.h"
@interface EZLifePagesController ()<UIWebViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) PendulumView *loadingView;

@end

@implementation EZLifePagesController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadURLString:@"http://jump.luna.58.com/i/27WZ"];
    
    self.loadingView = [[PendulumView alloc] initWithFrame:self.view.bounds ballColor:[UIColor colorWithRed:41.f/255.0 green:166/255.0 blue:0 alpha:1]];
    [self.view addSubview:self.loadingView];
    
    
    self.webView.scrollView.delegate=self;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"LifePages"];
    
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"LifePages"];
    
}

#pragma mark - Private
- (void)loadURLString:(NSString *)urlString {
    
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [self.webView loadRequest:request];
    

}

#pragma mark - IBAction 

- (IBAction)backAction:(UIBarButtonItem *)sender {
    if (self.webView.canGoBack) {
        
        [self.webView goBack];
        
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (IBAction)refreshAction:(UIBarButtonItem *)sender {
    [self.webView reload];
}
- (IBAction)closeAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    self.loadingView.hidden=NO;
    [self.loadingView startAnimating];
    webView.hidden=YES;
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    return YES;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
    self.navigationItem.title=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    [self.loadingView stopAnimating];
    self.loadingView.hidden=YES;
    webView.hidden=NO;
    
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    
}

#pragma mark - UIScrollViewDelegate


@end
