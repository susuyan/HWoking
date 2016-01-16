//
//  KEAboutUsViewController.m
//  KECallsAttribution
//
//  Created by lichenWang on 14-1-6.
//  Copyright (c) 2014年 KERNEL. All rights reserved.
//

#import "KEAboutUsViewController.h"
#import<MessageUI/MFMailComposeViewController.h>
#import "UMSocial.h"
#import "KEProgressHUD.h"
#import "PXAlertView.h"
#import "APService.h"

#import "UMFeedback.h"
#import <sqlite3.h>
#import "EZFeedBackViewController.h"
#import "KECoreDataContact.h"
#import "KBAppDelegate.h"
#import "KEContactAddressBook.h"
#import "ChineseToPinyin.h"
#import "HVcardImporter.h"
#import "HDefaults.h"
@interface KEAboutUsViewController ()<MFMailComposeViewControllerDelegate>
@property(strong,nonatomic)MBProgressHUD *progressHUD;
@property(copy,nonatomic)NSString *databaseFilePath;
@property (nonatomic, copy)NSString *query;
@property (nonatomic)sqlite3 *database;

@property (weak, nonatomic) IBOutlet UISwitch *harassmentSwitch;
@end

@implementation KEAboutUsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)showLargeAlertView{
    [PXAlertView showAlertWithTitle:@"关于我们"
                            message:@"归属地助手产品版权所有归属93App!"
                        cancelTitle:@"非常感谢您对我们的支持!"
                         completion:^(BOOL cancelled, NSInteger buttonIndex) {
                             if (cancelled) {

                             } else {
                                 
                             }
                         }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
//    if (IS_IOS7) {
//        self.navigationController.interactivePopGestureRecognizer.delegate=self;
//    }
    
    
   // self.versionLabel.text = VERSION;
    
    
    pushSwitch=[[UISwitch alloc]init];
    
    pushSwitch.on=![[NSUserDefaults standardUserDefaults]boolForKey:@"limitpush"];
    [pushSwitch addTarget:self action:@selector(openPushSwitch:) forControlEvents:UIControlEventValueChanged];
    _pushCell.accessoryView=pushSwitch;
    
    
    NotificationSet = [[UISwitch alloc]init];
    NotificationSet.on = ![[NSUserDefaults standardUserDefaults]boolForKey:@"Battery"];
    [NotificationSet addTarget:self action:@selector(openPushSwitchNotif:) forControlEvents:UIControlEventValueChanged];
    self.NotificationCell.accessoryView = NotificationSet;

    
    
    urlArray=@[@"https://itunes.apple.com/cn/app/id858988471",@"https://itunes.apple.com/cn/app/id891567883",@"https://itunes.apple.com/cn/app/id889054201",@"https://itunes.apple.com/cn/app/id804456296",@"https://itunes.apple.com/cn/app/id879958475",@"https://itunes.apple.com/cn/app/id891180383"];
    
    
    self.harassmentSwitch.on = [HDefaults sharedDefaults].isOpenHarassment;
    if (self.harassmentSwitch.on) {
        self.harassmentSwitch.enabled = YES;
    }else {
        self.harassmentSwitch.enabled = NO;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
//    BOOL isPassed = [[NSUserDefaults standardUserDefaults] boolForKey:@"isPassed"];
//    
//    if (isPassed) {
//        return 5;
//    }
    

    return 3;

}
- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)harassmentSwitch:(UISwitch *)sender {
    if (!sender.on) {
        
        [HVcardImporter CheckAddressBookAuthorization:^(bool isAuthorized) {
            if (isAuthorized) {
                HVcardImporter *importer = [[HVcardImporter alloc] init];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                hud.mode = MBProgressHUDModeIndeterminate;
                hud.labelText = @"正在移除号码库";
                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                    // Do something...
                    [importer closeAntiHarassmentMode];
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"openHarassment"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        hud.labelText = @"移除完毕";
                        [hud hide:YES];
                    });
                });
                
            }else {
                //TODO: 做出通讯录权限提示。
                UIAlertView * alart = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请您设置允许APP访问您的通讯录\n设置>隐私>通讯录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alart show];
                self.harassmentSwitch.on = YES;
            }
        }];
        
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                [tableView cellForRowAtIndexPath:indexPath].selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }
            
            break;
        case 1:
        {
           
        }
            
            break;
        case 2:
        {
            if (indexPath.row == 0) {
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@?mt=8",APPLE_ID]]];
            }else if (indexPath.row == 1){
                [self share];
            }
        }
            
            break;
        case 3:
        {
            if (indexPath.row == 0) {
                
                EZFeedBackViewController *feedback=[[EZFeedBackViewController alloc]init];
                
                UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:feedback];
                
                
                [self presentViewController:nav animated:YES completion:nil];
                
                
            }
        }
            
            break;
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)share{
    NSString * content = [NSString stringWithFormat:@"%@。\r\n%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"],[NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@?mt=8",APPLE_ID]];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMENG_APP_SHARE_ID
                                      shareText:content
                                     shareImage:[UIImage imageNamed:@"icon120"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,nil]
                                       delegate:nil];
     [UMSocialData defaultData].extConfig.title = @"犀牛手机管家";
    
}


- (void)showMailPicker:(id)sender
{
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil){
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail]){
			[self displayComposerSheet];
		}else{
			[self launchMailAppOnDevice];
		}
	}else{
		[self launchMailAppOnDevice];
	}
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)launchMailAppOnDevice
{
    
}
-(void)displayComposerSheet
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
    [picker setToRecipients:[NSArray arrayWithObject:@"tpappsupport@163.com"]];
    [picker setSubject:@"意见反馈-犀牛手机管家"];
    picker.title = @"意见反馈";
	//[picker setMessageBody:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"] isHTML:NO];
    [self presentViewController:picker animated:YES completion:nil];
}
-(void)openPushSwitchNotif:(UISwitch *)sender{
    //设备充电消息推送
    if (sender.on) {
        //
        //        UIRemoteNotificationType type=[[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        //
        //        if (type==UIRemoteNotificationTypeNone) {
        //
        //            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"开启推送功能" message:@"请前往“设置->通知中心->电池医生”页面开启推送功能" delegate:self cancelButtonTitle:@"知道了 " otherButtonTitles:nil, nil];
        //            [alert show];
        //            sender.on=NO;
        //
        //        }else{
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"Battery"];
        
        //      }
        
        //        [[UIApplication sharedApplication]registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge |
        //         UIRemoteNotificationTypeSound |
        //         UIRemoteNotificationTypeAlert];
    }else{
        
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"Battery"];
        
        // [[UIApplication sharedApplication]unregisterForRemoteNotifications];
    }
    
    [[NSUserDefaults standardUserDefaults]synchronize];

}

-(void)openPushSwitch:(UISwitch *)sender {
    if (sender.on) {
        if (IS_IOS8) {
         BOOL isRegister=   [[UIApplication sharedApplication]isRegisteredForRemoteNotifications];
            if (!isRegister) {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"开启推送功能" message:@"请前往“设置->通知中心->归属地助手”页面开启推送功能" delegate:self cancelButtonTitle:@"知道了 " otherButtonTitles:nil, nil];
                [alert show];
                sender.on=NO;
                
            }else {
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"limitpush"];
                
            }
  
            
        }else {
        
            UIRemoteNotificationType type=[[UIApplication sharedApplication] enabledRemoteNotificationTypes];
            
            
            
            if (type==UIRemoteNotificationTypeNone) {
                
                
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"开启推送功能" message:@"请前往“设置->通知中心->归属地助手”页面开启推送功能" delegate:self cancelButtonTitle:@"知道了 " otherButtonTitles:nil, nil];
                [alert show];
                sender.on=NO;
                
            }else {
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"limitpush"];
                
            }
        
        
        }
    
        
        if (IS_IOS8) {
            
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
                                                                                 settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                                                                 categories:nil]];
            
            [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    
        }else {
        
            
            [[UIApplication sharedApplication]registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge |
             UIRemoteNotificationTypeSound |
             UIRemoteNotificationTypeAlert];

        
        }
        
  
    }else
    {
    
     [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"limitpush"];
        
        [[UIApplication sharedApplication]unregisterForRemoteNotifications];
    }

    [[NSUserDefaults standardUserDefaults]synchronize];

}



#pragma mark 恢复通讯录

- (IBAction)recoveryAddressBook {
    
    
    
    
    self.progressHUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    self.progressHUD.labelText = @"正在恢复...";
    self.databaseFilePath = [[NSBundle mainBundle] pathForResource:@"database"
                                                            ofType:@"sqlite3"];
    if (sqlite3_open([self.databaseFilePath UTF8String], &_database)
        != SQLITE_OK) {
        sqlite3_close(self.database);
        NSAssert(0, @"打开数据库失败！");
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [self getAddressBookAddCoreDataRecovery];
       
        dispatch_async(dispatch_get_main_queue(), ^{
            //关闭数据库z
            sqlite3_close(self.database);
            [self.tableView reloadData];
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        });
    });
    
    
        
    
    
}





- (void)getAddressBookAddCoreDataRecovery{
    // 1.  获取MOC
    KBAppDelegate * appDelegate =
    [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext * context = appDelegate.managedObjectContext;
    
    [self deleteAllObjectsWithEntityName:@"KECoreDataContact" inContext:context];
    
    KEContactAddressBook * contactAddressBook = [[KEContactAddressBook alloc] init];
    NSMutableArray * array = [contactAddressBook allContacts];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        
        self.progressHUD.labelText=[NSString stringWithFormat:@"正在恢复:%d/共:%d",idx+1,(int)array.count];
        
        
        KEContactAddressBook * contactAddressBook = obj;
        NSArray * phoneArray =[contactAddressBook.phoneInfo allValues];
        
        
        // 2. 创建对象
        KECoreDataContact * coreDataContact =
        [NSEntityDescription insertNewObjectForEntityForName:@"KECoreDataContact"
                                      inManagedObjectContext:context];
        
        // 3. 修改属性
        if (phoneArray.count) {
            coreDataContact.contactPhoneNumber = phoneArray[0];
        }
        coreDataContact.contactName = contactAddressBook.compositeName;
        coreDataContact.imageData = contactAddressBook.imageData;
        coreDataContact.firstName = contactAddressBook.firstName;
        coreDataContact.lastName = contactAddressBook.lastName;
        coreDataContact.recordID = [NSNumber numberWithInt:contactAddressBook.recordID];
        
        NSString * stringToCheckGroup = nil;
        if([[self currentLanguage] compare:@"zh-Hans" options:NSCaseInsensitiveSearch]==NSOrderedSame || [[self currentLanguage] compare:@"zh-Hant" options:NSCaseInsensitiveSearch]==NSOrderedSame)
        {
            stringToCheckGroup = contactAddressBook.lastName;
            //NSLog(@"current Language == Chinese");
        }else{
            stringToCheckGroup = contactAddressBook.firstName;
            // NSLog(@"current Language == English");
        }
        char str = [ChineseToPinyin sortSectionTitle:stringToCheckGroup];
        coreDataContact.contactType = [NSString stringWithFormat:@"%c",str];
        [self attributionToInquiriesRecovery:coreDataContact];
    }];
}
-(NSString*)currentLanguage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLang = [languages objectAtIndex:0];
    return currentLang;
}

- (void)deleteAllObjectsWithEntityName:(NSString *)entityName
                             inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest =
    [NSFetchRequest fetchRequestWithEntityName:entityName];
    fetchRequest.includesPropertyValues = NO;
    fetchRequest.includesSubentities = NO;
    
    NSError *error;
    NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *managedObject in items) {
        [context deleteObject:managedObject];
    }
       
}

- (void)attributionToInquiriesRecovery:(KECoreDataContact *)contact{
    
    
    
    
    contact.showCallerID=@"住宅";
    
    
    
    [self changeLocalizedPhoneLabel:contact];
    
    
    
    
}

- (void)changeLocalizedPhoneLabel:(KECoreDataContact*)contact{
    // 初始化并创建通讯录对象，记得释放内存
    ABAddressBookRef addressBook;
    addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    // 获取通讯录中所有的联系人
    //    NSArray *array = (__bridge NSArray*)ABAddressBookCopyArrayOfAllPeople(addressBook);
    //    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    //        ABRecordRef record = (__bridge ABRecordRef)[array objectAtIndex:idx];
    //        if ([contact.recordID integerValue] == (int)ABRecordGetRecordID(record)) {
    //            ABMultiValueRef phone = ABRecordCopyValue(record, kABPersonPhoneProperty);
    //            //NSLog(@"-------------------%ld",ABMultiValueGetCount(phone));
    //            if (ABMultiValueGetCount(phone) == 1) {
    //                ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABMultiStringPropertyType);//原来为kABPersonPhoneProperty，有log出错误信息，后修改为这个，错误信息消失。
    //                ABMultiValueAddValueAndLabel(multi, (__bridge CFTypeRef)contact.contactPhoneNumber, (__bridge CFTypeRef)contact.showCallerID, NULL);
    //                ABRecordSetValue(record, kABPersonPhoneProperty, multi, NULL);
    //
    //            }      }
    //    }];
    //
    
    
    ABRecordRef record=ABAddressBookGetPersonWithRecordID(addressBook, [contact.recordID intValue]);
    
    ABMultiValueRef phone = ABRecordCopyValue(record, kABPersonPhoneProperty);
    //NSLog(@"-------------------%ld",ABMultiValueGetCount(phone));
    
    ABMutableMultiValueRef multi = ABMultiValueCreateMutableCopy(phone);
    
    
    
    ABMultiValueRef  phones = ABRecordCopyValue(record, kABPersonPhoneProperty);
    
    
    
    
    
    for(int i = 0; i < ABMultiValueGetCount(phones); i++)
    {
        
        CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(phones, i);
        
        
        
        NSString * testString=(__bridge NSString *)(phoneNumberRef);
        
        
        
        
        if ([contact.contactPhoneNumber isEqualToString:testString]) {
            
            
            int index=i;
            
            
            ABMultiValueReplaceLabelAtIndex(multi, (__bridge CFStringRef)(contact.showCallerID), index);
            
            ABRecordSetValue(record, kABPersonPhoneProperty, multi, NULL);
            
            
            break;
            
        }
        
        
    }
    
    //提升效率
    
    //    int index= (int)ABMultiValueGetFirstIndexOfValue(phones, (__bridge CFTypeRef)(contact.contactPhoneNumber));
    //
    //
    //    ABMultiValueReplaceLabelAtIndex(multi, (__bridge CFStringRef)(contact.showCallerID), index);
    //
    //    ABRecordSetValue(record, kABPersonPhoneProperty, multi, NULL);
    
    
    
    
    
    
    
    // 保存修改的通讯录对象
    ABAddressBookSave(addressBook, NULL);
    // 释放通讯录对象的内存
    if (addressBook) {
        CFRelease(addressBook);
    }
}


@end
