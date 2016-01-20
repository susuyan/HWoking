//
//  ECWebViewController.h
//  KECallsAttribution
//
//  Created by 赵 进喜 on 14-9-3.
//  Copyright (c) 2014年 K.BLOCK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocial.h"
@interface ECWebViewController : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *mWebView;
@property(copy,nonatomic)NSString *strUrl;
- (IBAction)backButton:(UIButton *)sender;
-(void)loadUrl:(NSString *)url;
- (IBAction)webBack:(UIBarButtonItem *)sender;
- (IBAction)webForwaed:(UIBarButtonItem *)sender;

- (IBAction)webRefresh:(UIBarButtonItem *)sender;
- (IBAction)actionButtonPressed:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goBackButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goForwardButton;
@end
