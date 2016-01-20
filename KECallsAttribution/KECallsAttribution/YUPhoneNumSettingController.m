//
//  YUPhoneNumSettingController.m
//  KECallsAttribution
//
//  Created by EverZones on 15/9/16.
//  Copyright (c) 2015年 K.BLOCK. All rights reserved.
//

#import "YUPhoneNumSettingController.h"
#import "YUDeleteContactController.h"
#import "UMSocial.h"
#import "ECQuickContractController.h"
#import "EZMergeViewController.h"
@interface YUPhoneNumSettingController ()

@end

@implementation YUPhoneNumSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
        
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    [self initShareButton];
    
}
- (void)initShareButton {
    UIButton *sharebutton = [[UIButton alloc] initWithFrame:CGRectMake(30, SCREEN_HEIGHT - 30 - 80 - 30, SCREEN_WIDTH - 60, 40)];
    [sharebutton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [sharebutton setBackgroundImage:[UIImage imageNamed:@"dianjibtn_bj"] forState:UIControlStateNormal];
    [sharebutton setTitle:@"点击通知小伙伴" forState:UIControlStateNormal];
    [self.tableView addSubview:sharebutton];
}


- (IBAction)backHome:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return 3;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [self updateAddressBook];
                break;
            case 1:
                [self mergeContacts];
                break;
                
            default:
                break;
        }
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 几种操作
- (void)updateAddressBook {
    //TODO: pop到通讯录界面 （发一个通知，在那个控制器里边执行更新）
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateContact" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)deleteContacts {
    //TODO: push到列表控制器
    YUDeleteContactController *controller = [[YUDeleteContactController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)mergeContacts {
    //TODO: 合并联系人
    ABAddressBookRef addressBook=ABAddressBookCreateWithOptions(NULL, NULL);
    
    
    if (addressBook == nil) {
        return;
    }
    
    
    
    __block BOOL accessGranted = NO;
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        
        
        accessGranted = granted;
        
        
        dispatch_semaphore_signal(sema);
        
        
    });
    
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    // CFRelease(addressBook);
    
    if (!accessGranted) {
        return;
    }
    
    
    
    allContacts = [NSMutableArray arrayWithArray:(__bridge NSArray *)(ABAddressBookCopyArrayOfAllPeople(addressBook))];
    
    
    
    
    NSMutableDictionary *onceDic=[[NSMutableDictionary alloc]initWithCapacity:10];//只存第一次循环到的
    
    NSMutableDictionary *moreDic=[[NSMutableDictionary alloc]initWithCapacity:10];
    
    
    
    
    for (int i=0; i<allContacts.count; i++) {
        
        
        
        
        
        ABRecordRef record=(__bridge ABRecordRef)(allContacts[i]);
        
        
        CFStringRef compositeNameRef = ABRecordCopyCompositeName(record);
        NSString * compositeName = (__bridge NSString *)(ABRecordCopyCompositeName(record));
        
        compositeNameRef != NULL ? CFRelease(compositeNameRef) : NULL;
        
        
        if ([compositeName containsString:@"^"]||[compositeName containsString:@"*" ]||[compositeName isEqualToString:@""]||compositeName==nil) {
            
            
            continue;
            
        }
        
        
        
        if (![[onceDic allKeys] containsObject:compositeName]) {
            
            
            
            
            
            NSMutableArray *array=[NSMutableArray arrayWithObject:(__bridge id)(record)];
            
            
            [onceDic setObject:array forKey:compositeName];
            
            
        }else {
            
            
            if (![[moreDic allKeys] containsObject:compositeName]) {
                
                
                
                
                
                
                NSMutableArray *array=[NSMutableArray arrayWithObjects:onceDic[compositeName][0],record, nil];
                
                
                [moreDic setObject:array forKey:compositeName];
                
                
                
                
            }else {
                
                
                
                NSMutableArray *array=[NSMutableArray arrayWithArray:moreDic[compositeName]];
                
                
                [array addObject:(__bridge id)(record)];
                
                
                
                
                [moreDic setObject:array forKey:compositeName];
                
                
                
                
                
            }
            
            
        }
        
        
        
    }
    
    
    
    
    
    moreContacts = moreDic;
    
    NSLog(@"%@",moreDic);
    
    
    
    EZMergeViewController *merge=[self.storyboard instantiateViewControllerWithIdentifier:@"EZMergeViewController"];
    
    
    merge.allDic = moreContacts;
    
    
    
    [self.navigationController pushViewController:merge animated:YES];
    

}
- (void)addQuickContacts {
    //TODO: 添加快捷联系人
    ECQuickContractController *controller = [[ECQuickContractController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - 分享

- (void)shareAction{
    NSString * content = [NSString stringWithFormat:@"%@。\r\n%@",@"你的iphone也能防骚扰啦！陌生来电识别、防骚扰防诈骗，不信你也试试",[NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@?mt=8",APPLE_ID]];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMENG_APP_SHARE_ID
                                      shareText:content
                                     shareImage:[UIImage imageNamed:@"icon120"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,nil]
                                       delegate:nil];
    [UMSocialData defaultData].extConfig.title = @"手机归属地";

}

- (void)dealloc {
    [allContacts removeAllObjects];
    
    
    allContacts =nil;
    
    [moreContacts removeAllObjects];
    
    
    moreContacts=nil;
    
    
    [exceptionContacts removeAllObjects];
    
    
    exceptionContacts=nil;

}

@end
