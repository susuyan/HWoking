//
//  EZSmsInqueryVC.m
//  KECallsAttribution
//
//  Created by 赵 进喜 on 14/11/24.
//  Copyright (c) 2014年 K.BLOCK. All rights reserved.
//

#import "EZSmsInqueryVC.h"
#import <MessageUI/MFMessageComposeViewController.h>
#import "SVProgressHUD.h"
@interface EZSmsInqueryVC ()<MFMessageComposeViewControllerDelegate>

@end

@implementation EZSmsInqueryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    smsItems=[_mItems objectAtIndex:0];
    
    phoneItems=[_mItems objectAtIndex:1];
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return _mItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    
    
    int count;
    
    if (section==0) {
        count=smsItems.count;
    }else
    {
        count=phoneItems.count;
    
    }
    
    
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
   
    NSString *identify=@"Cell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identify];
    
    
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    
   
    cell.textLabel.text=[[[_mItems objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]objectForKey:@"name"];
    
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    
    
    // Configure the cell...
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{


    if (indexPath.section==0) {
        
        
        NSString *code=[[smsItems objectAtIndex:indexPath.row]objectForKey:@"code"];
        [self sendSmsWithCode:code];
        
    }else {
    
        NSString *code=[[phoneItems objectAtIndex:indexPath.row]objectForKey:@"code"];
        
        [self callWithCode:code];
    
    }

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

}
-(void)sendSmsWithCode:(NSString *)code {

//发短信
    [[UINavigationBar appearance] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    
    if (messageClass != nil) {
        
        if ([messageClass canSendText]) {
            
            MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
            
            picker.messageComposeDelegate = self;
            
            picker.recipients=@[_carrierNum];
            
            picker.body=code;
            
           
                
            
            [self presentViewController:picker animated:YES completion:nil];

            

            
        }
        
        else {
            
            //设备没有短信功能
            
            
            NSLog(@"不支持发短信");
            
        }
        
    } else {
        
        // iOS版本过低,iOS4.0以上才支持程序内发送短信
        
    }
    

}
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
    
    //Notifies users about errors associated with the interface
    
    switch (result) {
            
        case MessageComposeResultCancelled:
            
            
            [SVProgressHUD showErrorWithStatus:@"取消"];
//            if (DEBUG) NSLog(@"Result: canceled");
            
            break;
            
        case MessageComposeResultSent:
            
//            if (DEBUG) NSLog(@"Result: Sent");
            [SVProgressHUD showSuccessWithStatus:@"已发送"];
            
            break;
            
        case MessageComposeResultFailed:
            
//            if (DEBUG) NSLog(@"Result: Failed");
            [SVProgressHUD showErrorWithStatus:@"失败"];
            
            break;
            
        default:
            
            break;
            
    }
    
    UIImage *backgroundImage = [UIImage imageNamed:@"daohang_bg_ios7"];
    
    [[UINavigationBar appearance] setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)callWithCode:(NSString *)code {

   // [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",code]]];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",code]]]];
    [self.view addSubview:callWebview];
}





- (IBAction)backButtonPressed:(UIButton *)sender {
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
@end
