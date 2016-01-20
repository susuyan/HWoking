//
//  KEContactAddressBook.m
//  KECallsAttribution
//
//  Created by lichenWang on 14-1-13.
//  Copyright (c) 2014年 KERNEL. All rights reserved.
//

#import "KEContactAddressBook.h"
#import "NSString+ContainsMethod.h"
@implementation KEContactAddressBook


-(NSMutableDictionary *)phoneInfo
{
    if(_phoneInfo == nil)
    {
        _phoneInfo = [[NSMutableDictionary alloc] init];
    }
    
    return _phoneInfo;
}


-(NSMutableDictionary *)emailInfo
{
    if(_emailInfo == nil)
    {
        _emailInfo = [[NSMutableDictionary alloc] init];
    }
    return  _emailInfo;
}



//取得所有的联系人
-(NSMutableArray *)allContacts
{
    self.addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    //等待同意后向下执行
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    ABAddressBookRequestAccessWithCompletion(self.addressBook, ^(bool granted, CFErrorRef error)
                                             {
                                                 dispatch_semaphore_signal(sema);
                                             });
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    NSArray * contacts = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(self.addressBook);
   
    
    //    if([_allContacts retainCount] > 0) [_allContacts release];
    
    _allContacts = [[NSMutableArray alloc] init];
    
    
    int contactsCount = [contacts count];
    
    for(int i = 0; i < contactsCount; i++)
    {
        self.imageData = [NSMutableData data];
        ABRecordRef record = (__bridge ABRecordRef)[contacts objectAtIndex:i];
        //取得姓名
        CFStringRef  firstNameRef =  ABRecordCopyValue(record, kABPersonFirstNameProperty);
        self.firstName = (__bridge NSString *)firstNameRef;

        CFStringRef lastNameRef = ABRecordCopyValue(record, kABPersonLastNameProperty);
        self.lastName = (__bridge NSString *)lastNameRef;
      
        CFStringRef compositeNameRef = ABRecordCopyCompositeName(record);
        self.compositeName = (__bridge NSString *)(ABRecordCopyCompositeName(record));
        
        
        //过滤360，搜狗骚扰电话
        
        if ([self.compositeName containsString:@"^"]||[self.compositeName containsString:@"*" ]||[self.compositeName isEqualToString:@""]||self.compositeName==nil) {
            
            
            continue;
            
        }

        
        
        
        
        
        
        
        firstNameRef != NULL ? CFRelease(firstNameRef) : NULL;
        lastNameRef != NULL ? CFRelease(lastNameRef) : NULL;
        compositeNameRef != NULL ? CFRelease(compositeNameRef) : NULL;
        
        //取得联系人的ID
        self.recordID = (int)ABRecordGetRecordID(record);
        //联系人头像
        if(ABPersonHasImageData(record))
        {
            //            NSData * imageData = ( NSData *)ABPersonCopyImageData(record);
            NSData * imageData = (__bridge NSData *)ABPersonCopyImageDataWithFormat(record,kABPersonImageFormatThumbnail);
            self.imageData = [imageData mutableCopy];
        }
        
        
        //处理联系人电话号码
        ABMultiValueRef  phones = ABRecordCopyValue(record, kABPersonPhoneProperty);
        self.phoneMultiValueRef = phones;
        for(int i = 0; i < ABMultiValueGetCount(phones); i++)
        {
            KEContactAddressBook * contact = [[KEContactAddressBook alloc] init];
            CFStringRef phoneLabelRef = ABMultiValueCopyLabelAtIndex(phones, i);
            CFStringRef localizedPhoneLabelRef = ABAddressBookCopyLocalizedLabel(phoneLabelRef);
            CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(phones, i);
            NSString * localizedPhoneLabel = (__bridge NSString *) localizedPhoneLabelRef;
            NSString * phoneNumber = (__bridge NSString *)phoneNumberRef;
            
            [contact.phoneInfo setValue:phoneNumber forKey:localizedPhoneLabel];
            
            //释放内存
            phoneLabelRef == NULL ? : CFRelease(phoneLabelRef);
            localizedPhoneLabelRef == NULL ? : CFRelease(localizedPhoneLabelRef);
            phoneNumberRef == NULL ? : CFRelease(phoneNumberRef);
            contact.firstName = self.firstName;
            contact.lastName = self.lastName;
            contact.imageData = self.imageData;
            contact.recordID = self.recordID;
            contact.compositeName = self.compositeName;
            [_allContacts addObject:contact];
        }
        if(phones != NULL) CFRelease(phones);
        CFRelease(record);
        self.imageData = nil;
    }
    return _allContacts;
}
@end
