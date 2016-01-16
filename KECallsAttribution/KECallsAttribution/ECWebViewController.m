//
//  ECWebViewController.m
//  KECallsAttribution
//
//  Created by 赵 进喜 on 14-9-3.
//  Copyright (c) 2014年 K.BLOCK. All rights reserved.
//

#import "ECWebViewController.h"
#import "MBProgressHUD.h"
#import "UIColor+Art.h"
@interface ECWebViewController ()<UIActivityItemSource>

@end

@implementation ECWebViewController

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
    _mWebView.delegate=self;
    _mWebView.scalesPageToFit=YES;
    
    
    [[UIToolbar appearance]setTintColor:[UIColor colorWithHex:0x037CFE]];
    
    self.title=@"大众点评网";
    
    if (_strUrl) {
        [self loadUrl:_strUrl];
    }
    
    // Do any additional setup after loading the view.
}
-(void)loadUrl:(NSString *)url
{


    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    
    [_mWebView loadRequest:request];



}


-(void)webViewDidStartLoad:(UIWebView *)webView
{

 self.title=@"大众点评网";
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];


}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    NSString *title=[_mWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    if (title==nil||[title isEqualToString:@""]) {
        self.title=@"大众点评网";
        
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)actionButtonPressed:(UIBarButtonItem *)sender {
    
    
    
    NSString *string =self.title;
    NSURL *url = _mWebView.request.URL;
    //UIImage *image=[UIImage imageNamed:@"icon120"];
    
    
    
//    //普通自带的分享
//    
//    UIActivityViewController *activity =
//    [[UIActivityViewController alloc] initWithActivityItems:@[string,URL,image]
//                                      applicationActivities:nil];
//    
//    
//    
//    
//    
//    
//    // activity.excludedActivityTypes=@[UIActivityTypePostToTencentWeibo,UIActivityTypePostToWeibo];
//    
//    [self presentViewController:activity animated:YES completion:nil];
    
    NSString *content=[NSString stringWithFormat:@"%@ 跳转链接：%@",string,[url absoluteString]];
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMENG_APP_SHARE_ID
                                      shareText:content
                                     shareImage:nil
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,nil]
                                       delegate:nil];
    [UMSocialData defaultData].extConfig.title = @"手机归属地";

}

- (IBAction)webBack:(UIBarButtonItem *)sender {
    
     [_mWebView goBack];
}

- (IBAction)webForwaed:(UIBarButtonItem *)sender {
    
    [_mWebView goForward];
    
    
}


@end
