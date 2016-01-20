//
//  EZChargeViewController.m
//  KECallsAttribution
//
//  Created by 赵 进喜 on 14/11/26.
//  Copyright (c) 2014年 K.BLOCK. All rights reserved.
//

#import "EZChargeViewController.h"
#import "MBProgressHUD.h"
@interface EZChargeViewController ()

@end

@implementation EZChargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _mWebView.delegate=self;
    _mWebView.scalesPageToFit=YES;
    
    
    //[[UIToolbar appearance]setTintColor:[UIColor colorWithHex:0x037CFE]];
    
    self.title=@"话费充值";
    
    if (_strUrl) {
        [self loadUrl:_strUrl];
    }

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadUrl:(NSString *)url
{
    
    
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    
    [_mWebView loadRequest:request];
    
    
    
}


-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
    self.title=@"话费充值";
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    NSString *title=[_mWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    if (title==nil||[title isEqualToString:@""]) {
        self.title=@"话费充值";
        
    }else
    {
        self.navigationItem.title=title;
        
        
    }
    
    if ([_mWebView canGoBack]) {
        _goBackButton.enabled=YES;
    }else
    {
        _goBackButton.enabled=NO;
        
    }
    
    
    if ([_mWebView canGoForward]) {
        _goForwardButton.enabled=YES;
    }else
    {
        _goForwardButton.enabled=NO;
        
    }
    
    
    
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    
    self.navigationItem.title=[_mWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    
    
    return YES;
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

- (IBAction)backButton:(UIButton *)sender {
    
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)webRefresh:(UIBarButtonItem *)sender {
    
    [_mWebView reload];
    
}


- (IBAction)webBack:(UIBarButtonItem *)sender {
    
    [_mWebView goBack];
}

- (IBAction)webForwaed:(UIBarButtonItem *)sender {
    
    [_mWebView goForward];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
