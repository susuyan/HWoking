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
#import "ECBrandViewController.h"
#import "UMFeedback.h"
#import <sqlite3.h>
#import "EZFeedBackViewController.h"
#import "KECoreDataContact.h"
#import "KBAppDelegate.h"
#import "KEContactAddressBook.h"
#import "ChineseToPinyin.h"
#import "HVcardImporter.h"
#import "HDefaults.h"
#import "HMarkHistoryController.h"

@interface KEAboutUsViewController ()<MFMailComposeViewControllerDelegate>
@property(strong,nonatomic)MBProgressHUD *progressHUD;
@property(copy,nonatomic)NSString *databaseFilePath;
@property (nonatomic, copy)NSString *query;
@property (nonatomic)sqlite3 *database;



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
    
    
    urlArray=@[@"https://itunes.apple.com/cn/app/id858988471",@"https://itunes.apple.com/cn/app/id891567883",@"https://itunes.apple.com/cn/app/id889054201",@"https://itunes.apple.com/cn/app/id804456296",@"https://itunes.apple.com/cn/app/id879958475",@"https://itunes.apple.com/cn/app/id891180383"];
    
    

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
    

    return 5;

}
- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            HMarkHistoryController *markHistoryController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HMarkHistoryController"];
            [self.navigationController pushViewController:markHistoryController animated:YES];
        }
        
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //[self showLargeAlertView];
        }else if (indexPath.row==2) {
        
            [self recoveryAddressBook];
            
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@?mt=8",APPLE_ID]]];
        }else if (indexPath.row == 1){
            [self share];
        }
    }else if (indexPath.section == 3){
        if (indexPath.row == 0) {
            //[self showMailPicker:nil];
            
            
//            [self presentModalViewController:[UMFeedback feedbackModalViewController]
//                                    animated:YES];
            EZFeedBackViewController *feedback=[[EZFeedBackViewController alloc]init];
            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:feedback];
            [self presentViewController:nav animated:YES completion:nil];
            
            
        }
    }else if (indexPath.section == 4) {
    
        if (indexPath.row==0) {
            
            [self goToBrandNumberInfo];

            
        }
        
        
        else if (indexPath.row==1) {
        
            NSString *url=@"https://itunes.apple.com/cn/app/id999256279?mt=8";
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];

        
        
        }
        
        
        
        
    }
    
    //    else if (indexPath.section==4)
//    {
//    
//        NSString *url=[urlArray objectAtIndex:indexPath.row];
//        
//        
//        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
//    
//    
//    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)share{
    NSString * content = [NSString stringWithFormat:@"%@。\r\n%@",@"你的iphone也能防骚扰啦！陌生来电识别、防骚扰防诈骗，不信你也试试",[NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@?mt=8",APPLE_ID]];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMENG_APP_SHARE_ID
                                      shareText:content
                                     shareImage:[UIImage imageNamed:@"icon120"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,nil]
                                       delegate:nil];
     [UMSocialData defaultData].extConfig.title = @"手机归属地";
    
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
    [picker setToRecipients:[NSArray arrayWithObject:@"support@93app.com"]];
    [picker setSubject:@"意见反馈-手机归属地"];
    picker.title = @"意见反馈";
	//[picker setMessageBody:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"] isHTML:NO];
    [self presentViewController:picker animated:YES completion:nil];
}


-(void)openPushSwitch:(UISwitch *)sender
{


    if (sender.on) {
        
        
        
        if (IS_IOS8) {
            
            
         BOOL isRegister=   [[UIApplication sharedApplication]isRegisteredForRemoteNotifications];
            
            
            if (!isRegister) {
                
                
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"开启推送功能" message:@"请前往“设置->通知中心->归属地助手”页面开启推送功能" delegate:self cancelButtonTitle:@"知道了 " otherButtonTitles:nil, nil];
                [alert show];
                sender.on=NO;
                
            }else
            {
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"limitpush"];
                
            }

            
            
            
        }else
        {
        
            UIRemoteNotificationType type=[[UIApplication sharedApplication] enabledRemoteNotificationTypes];
            
            
            
            if (type==UIRemoteNotificationTypeNone) {
                
                
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"开启推送功能" message:@"请前往“设置->通知中心->归属地助手”页面开启推送功能" delegate:self cancelButtonTitle:@"知道了 " otherButtonTitles:nil, nil];
                [alert show];
                sender.on=NO;
                
            }else
            {
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"limitpush"];
                
            }

        
        
        }
        
        
        

        
        
        if (IS_IOS8) {
            
            
            
            
            
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
                                                                                 settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                                                                 categories:nil]];
            
            
            [[UIApplication sharedApplication] registerForRemoteNotifications];
    
            
            
            
            
        }else
        {
        
            
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
-(void)goToBrandNumberInfo
{


    ECBrandViewController *brand=[self.storyboard instantiateViewControllerWithIdentifier:@"ECBrandViewController"];
    
    [self.navigationController pushViewController:brand animated:YES];



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
