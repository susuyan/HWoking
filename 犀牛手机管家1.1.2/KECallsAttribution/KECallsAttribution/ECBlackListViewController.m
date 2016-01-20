//
//  ECBlackListViewController.m
//  KECallsAttribution
//
//  Created by 赵 进喜 on 14-5-19.
//  Copyright (c) 2014年 K.BLOCK. All rights reserved.
//

#import "ECBlackListViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
@interface ECBlackListViewController ()<ABPersonViewControllerDelegate,ABPeoplePickerNavigationControllerDelegate,ABNewPersonViewControllerDelegate>
{


    

}
@end

@implementation ECBlackListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{


    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"heimingdan"];


}
-(void)viewWillDisappear:(BOOL)animated
{

    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"heimingdan"];


}
- (void)viewDidLoad
{
    [super viewDidLoad];
//    
//    BOOL isPassed = [[NSUserDefaults standardUserDefaults] boolForKey:@"isPassed"];
//    
//    
//    if (isPassed) {
//        if (![[NSUserDefaults standardUserDefaults]boolForKey:@"scored"]) {
//            [self makeScore];
//        }
//
//    }
    
    
    _numberText.text=_blackNumber;
    
    self.guideView.hidden=YES;
    self.guideView.frame=CGRectMake(_guideView.frame.origin.x, self.guideView.frame.origin.y, 320, 650);
    self.guideView.image=[UIImage imageNamed:@"second_time_add"];

    self.bgScrollView.contentSize=CGSizeMake(320, 800);
    
    // Do any additional setup after loading the view.
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

- (IBAction)addBlackList:(UIButton *)sender {
    
    
    [self hideKeyboard:nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    
    
    
    
    
        
        ABAddressBookRef addressBook = ABAddressBookCreate();
        
        __block BOOL accessGranted = NO;
        if (ABAddressBookRequestAccessWithCompletion != NULL) {
            
            // we're on iOS 6
            NSLog(@"on iOS 6 or later, trying to grant access permission");
            
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                accessGranted = granted;
                dispatch_semaphore_signal(sema);
            });
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            
        }
        if (!accessGranted) {
            return;
        }
        
        ABRecordRef  blackPerson=[self checkPeopleExsit:_numberText.text];
        
        if (blackPerson==nil) {
            
            
            
            
            [self AddPeopleWithNumber:_numberText.text];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
            
                [UIView animateWithDuration:0.5 animations:^{
                     self.guideView.hidden=NO;
                    self.guideView.frame=CGRectMake(_guideView.frame.origin.x, self.guideView.frame.origin.y, 320, 550);
                   
                    self.guideView.image=[UIImage imageNamed:@"first_time_add"];

                    
                }];

                
            
            });
            
            
          
            
            
            
        }else
        {
            
            ABAddressBookRef iPhoneAddressBook = ABAddressBookCreateWithOptions(NULL, NULL);
            CFErrorRef error = NULL;
            
            //phone number
            ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
            
            ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)(_numberText.text), kABPersonPhoneMobileLabel, NULL);
            
            
            
            
            ABMultiValueRef  phones = ABRecordCopyValue(blackPerson, kABPersonPhoneProperty);
            
            for(int i = 0; i < ABMultiValueGetCount(phones); i++)
            {
                
                CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(phones, i);
                
                ABMultiValueAddValueAndLabel(multiPhone, phoneNumberRef, kABPersonPhoneMobileLabel, NULL);
                
                
            }
            
            
            
            
            ABRecordSetValue(blackPerson, kABPersonPhoneProperty, multiPhone, &error);
            CFRelease(multiPhone);
            
            
            //picture
            
            
            ABAddressBookAddRecord(iPhoneAddressBook, blackPerson, &error);
            ABAddressBookSave(iPhoneAddressBook, &error);
            CFRelease(blackPerson);
            CFRelease(iPhoneAddressBook);
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
            
                [UIView animateWithDuration:0.5 animations:^{
                    self.guideView.hidden=NO;
                    self.guideView.frame=CGRectMake(_guideView.frame.origin.x, self.guideView.frame.origin.y, 320, 650);
                
                    self.guideView.image=[UIImage imageNamed:@"second_time_add"];
                
                }];
                
               
            
            
            }
            
                           );
            
        }

       
    
    
        dispatch_async(dispatch_get_main_queue(), ^{
        
        
        
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"已成功添加至黑名单，请继续按照下方图片引导完成剩余步骤" message:nil delegate:self cancelButtonTitle:@"继续" otherButtonTitles:nil, nil];
            
            [alert show];
        
        
        });
    
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//        
//        
//        
//            [self goToEditPage:blackPerson];
//        
//        
//        
//        });
    
    
    
    });
    
    
}


-(ABRecordRef)checkPeopleExsit:(NSString *)number
{

    ABAddressBookRef addressBook =  ABAddressBookCreateWithOptions(NULL, NULL);
 
    
    

    CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(addressBook);

    

    for(int i = 0; i < CFArrayGetCount(results); i++)
     
    {
     
        ABRecordRef person = CFArrayGetValueAtIndex(results, i);
        //读取firstname
       
        NSString *firstName = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
      
        if(firstName != nil)
        {
         
            
            if ([firstName isEqualToString:@"黑名单"]) {
                
                
                return person;
                
            }
            
            
        }
        
            
    }
    return nil;

}


-(void)AddPeopleWithNumber:(NSString *)number
{
    //name
    ABAddressBookRef iPhoneAddressBook = ABAddressBookCreate();
    ABRecordRef newPerson = ABPersonCreate();
    CFErrorRef error = NULL;
    ABRecordSetValue(newPerson, kABPersonFirstNameProperty, @"黑名单", &error);
    
    //phone number
    ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
  
    ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)(number), kABPersonPhoneMobileLabel, NULL);
    ABRecordSetValue(newPerson, kABPersonPhoneProperty, multiPhone, &error);
    CFRelease(multiPhone);
   
    
    //picture
    NSData *dataRef = UIImagePNGRepresentation([UIImage imageNamed:@"ic_block"]);
    ABPersonSetImageData(newPerson, (__bridge CFDataRef)dataRef, &error);
    ABAddressBookAddRecord(iPhoneAddressBook, newPerson, &error);
    ABAddressBookSave(iPhoneAddressBook, &error);
    
    CFRelease(newPerson);
    CFRelease(iPhoneAddressBook);


}
//-(void)AddPeopleWithNumber:(CFStringRef )number
//{
//    //取得本地通信录名柄
//    ABAddressBookRef tmpAddressBook = ABAddressBookCreate();
//    //创建一条联系人记录
//    ABRecordRef tmpRecord = ABPersonCreate();
//    CFErrorRef error;
//    BOOL tmpSuccess = NO;
//    //Nickname
////    CFStringRef tmpNickname = CFSTR("黑名单");
////    tmpSuccess = ABRecordSetValue(tmpRecord, kABPersonNicknameProperty, tmpNickname, &error);
////    CFRelease(tmpNickname);
//    //First name
//    CFStringRef tmpFirstName = CFSTR("黑名单");
//    tmpSuccess = ABRecordSetValue(tmpRecord, kABPersonFirstNameProperty, tmpFirstName, &error);
//    CFRelease(tmpFirstName);
//    //Last name
////    CFStringRef tmpLastName = CFSTR("shan");
////    tmpSuccess = ABRecordSetValue(tmpRecord, kABPersonLastNameProperty, tmpLastName, &error);
////    CFRelease(tmpLastName);
//    //phone number
//   // CFTypeRef tmpPhones = CFSTR("12312313");
//    CFTypeRef tmpPhones = (CFTypeRef)number;
//    ABMutableMultiValueRef tmpMutableMultiPhones = ABMultiValueCreateMutable(kABPersonPhoneProperty);
//    ABMultiValueAddValueAndLabel(tmpMutableMultiPhones,tmpPhones,kABPersonPhoneMobileLabel, NULL);
//    tmpSuccess = ABRecordSetValue(tmpRecord, kABPersonPhoneProperty, tmpMutableMultiPhones, &error);
//    CFRelease(tmpPhones);
//    //保存记录
//    tmpSuccess = ABAddressBookAddRecord(tmpAddressBook, tmpRecord, &error);
//    CFRelease(tmpRecord);
//    //保存数据库
//    tmpSuccess = ABAddressBookSave(tmpAddressBook, &error);
//    CFRelease(tmpAddressBook);
//}
- (IBAction)hideKeyboard:(UITapGestureRecognizer *)sender {
    
    
    [self.view endEditing:YES];
    
}



- (IBAction)back:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)goToEditPage:(ABRecordRef)person
{


    
    
    // Fetch the address book
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    // Search for the person named "Appleseed" in the address book
  
    // Display "Appleseed" information if found in the address book
   
    
        ABPersonViewController *picker = [[ABPersonViewController alloc] init] ;
        picker.personViewDelegate = self;
        picker.displayedPerson = person;
        // Allow users to edit the person’s information
        picker.allowsEditing = YES;
        [self.navigationController pushViewController:picker animated:YES];
    
    
    CFRelease(addressBook);

    
    
   
}



-(void)makeScore
{


    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"亲，去Appstore给个好评就能免费使用这个超赞的黑名单功能呦~" message:nil delegate:self cancelButtonTitle:@"不要" otherButtonTitles:@"去评价啰", nil];
    alert.tag=1;
    [alert show];

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    switch (alertView.tag) {
        case 1:
        {
            
            if (buttonIndex==0) {
                [self back:nil];
            }else if (buttonIndex==1)
            {
            
            
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@?mt=8",APPLE_ID]]];
                
                
                
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"scored"];
                
                
                UIAlertView *callBackAlert=[[UIAlertView alloc]initWithTitle:@"解锁成功！" message:nil delegate:self cancelButtonTitle:@"立即体验" otherButtonTitles:nil, nil];
                
                [callBackAlert show];

            
            
            }
            
            
            
            break;
    }
        default:
            break;
    }


}
@end
