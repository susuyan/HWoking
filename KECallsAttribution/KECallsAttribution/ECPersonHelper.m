//
//  ECPersonHelper.m
//  MyContacts
//
//  Created by 赵 进喜 on 15/1/5.
//  Copyright (c) 2015年 everzones. All rights reserved.
//

#import "ECPersonHelper.h"
#import "NSString+ContainsMethod.h"
static ECPersonHelper *helper;
@implementation ECPersonHelper

//内联函数
//NS_INLINE NSString *filePath(NSString *filePath)
//{
//    
//    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    
//    
//    
//    NSString *path=[[paths objectAtIndex:0] stringByAppendingPathComponent:filePath];
//    
//    
//    
//    return path;
//    
//    
//}

- (void)dealloc
{
    // 释放通讯录对象的内存
    if (_addressBook) {
        CFRelease(_addressBook);
    }
    
   

}

+(ECPersonHelper *)sharePersonHelper
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        
        
        helper=[[ECPersonHelper alloc]init];
        
        
        
    });
    
    
    return helper;
}


-(instancetype)init
{


    if (self=[super init]) {
        
        
        
        
        _history_record=[NSMutableArray arrayWithArray:[self loadItemsFromFile:@"history"]];
        
        
        
        
        
    }



    return self;


}




-(void)initContactsDatabase
{

    
    if (_allContracts==nil) {
        
         _allContracts=[NSMutableArray array];
    }
    
    if (_allGroupContacts==nil) {
        
        _allGroupContacts=[NSMutableArray array];
        
    }
   
    
    [_allContracts removeAllObjects];
    
    [_allGroupContacts removeAllObjects];
    
    
    
    
    
    self.addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    
    
    __block BOOL accessGranted = NO;
    
    
    if (ABAddressBookRequestAccessWithCompletion != NULL) {
    
    //等待同意后向下执行
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    ABAddressBookRequestAccessWithCompletion(self.addressBook, ^(bool granted, CFErrorRef error)
                                             {
                                                 
                                                 
                                                 accessGranted=granted;
                                                 dispatch_semaphore_signal(sema);
                                             });
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    
    }else
    {
    
        accessGranted = YES;
    
    
    }
    
    
    
    
    if (!accessGranted) {
        
        
        
        
        
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"没有获得通讯录授权，请到设置页隐私模块对本产品进行通讯录授权" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
        
            [alert show];
            
            
            return;

            
            
        });
        
        
        
    }
    
    
    
    
    NSArray  *allGroup=(__bridge NSArray *)ABAddressBookCopyArrayOfAllGroups(self.addressBook);
    
    
    //未分组
    NSMutableArray *allOtherContacts=(__bridge NSMutableArray *)(ABAddressBookCopyArrayOfAllPeople(self.addressBook));
    
    
    
    
    
    
    [allGroup enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        
        ABRecordRef group=(__bridge ABRecordRef)(obj);
        
        ABRecordID  groupId=ABRecordGetRecordID(group);
        
        
        NSString *groupName=(__bridge NSString *)(ABRecordCopyValue(group, kABGroupNameProperty));
        
       
        
        
        
        NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithObjectsAndKeys:groupName,@"groupName",[NSNumber numberWithInt:groupId],@"groupId", nil];
        
        NSMutableArray *groupArray=[NSMutableArray array];
        
        
        
      
        
        
        
        NSArray * allContracts=(__bridge NSArray *)(ABGroupCopyArrayOfAllMembers(group));
        
        
        
        [allOtherContacts removeObjectsInArray:allContracts];
        
        
        groupArray=[self dealWithGroupContactsWithArray:allContracts];
        
//        for (int i=0; i<allContracts.count; i++) {
//            
//            
//           
//            
//            NSData *imageData = [NSMutableData data];
//            
//            
//            
//            ABRecordRef record = (__bridge ABRecordRef)[allContracts objectAtIndex:i];
//            //取得姓名
//            CFStringRef  firstNameRef =  ABRecordCopyValue(record, kABPersonFirstNameProperty);
//            NSString * firstName = (__bridge NSString *)firstNameRef;
//            
//            CFStringRef lastNameRef = ABRecordCopyValue(record, kABPersonLastNameProperty);
//            NSString * lastName = (__bridge NSString *)lastNameRef;
//            
//         
//            
//            
//            CFStringRef compositeNameRef = ABRecordCopyCompositeName(record);
//            NSString * compositeName = (__bridge NSString *)(ABRecordCopyCompositeName(record));
//            
//            firstNameRef != NULL ? CFRelease(firstNameRef) : NULL;
//            lastNameRef != NULL ? CFRelease(lastNameRef) : NULL;
//            compositeNameRef != NULL ? CFRelease(compositeNameRef) : NULL;
//            
//            //取得联系人的ID
//            int recordID = (int)ABRecordGetRecordID(record);
//            //联系人头像
//            if(ABPersonHasImageData(record))
//            {
//                //            NSData * imageData = ( NSData *)ABPersonCopyImageData(record);
//               imageData = (__bridge NSData *)ABPersonCopyImageDataWithFormat(record,kABPersonImageFormatThumbnail);
//                
//            }
//            
//            
//            //处理联系人电话号码
//            ABMultiValueRef  phones = ABRecordCopyValue(record, kABPersonPhoneProperty);
//           
//            for(int i = 0; i < ABMultiValueGetCount(phones); i++)
//            {
//                ECContactObject *contact=[[ECContactObject alloc]init];
//                CFStringRef phoneLabelRef = ABMultiValueCopyLabelAtIndex(phones, i);
//                CFStringRef localizedPhoneLabelRef = ABAddressBookCopyLocalizedLabel(phoneLabelRef);
//                CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(phones, i);
//                NSString * localizedPhoneLabel = (__bridge NSString *) localizedPhoneLabelRef;
//                NSString * phoneNumber = (__bridge NSString *)phoneNumberRef;
//                
//                contact.contactPhoneNumber=phoneNumber;
//                contact.phoneLabel=localizedPhoneLabel;
//            
//                
//                //释放内存
//                phoneLabelRef == NULL ? : CFRelease(phoneLabelRef);
//                localizedPhoneLabelRef == NULL ? : CFRelease(localizedPhoneLabelRef);
//                phoneNumberRef == NULL ? : CFRelease(phoneNumberRef);
//                
//                
//                contact.firstName = firstName;
//                contact.lastName = lastName;
//                contact.imageData = imageData;
//                contact.recordID = [NSNumber numberWithInt:recordID];
//                contact.contactName = compositeName;
//                
//                NSLog(@"%@",contact.contactName);
//                
//                
//                [groupArray addObject:contact];
//               
//            }
//            
//            
//            if(phones != NULL) CFRelease(phones);
//            CFRelease(record);
//           
//
//        
//            
//            
//        }
        
        
       
        
        
        [dic setObject:groupArray forKey:@"groupArray"];
        
         NSLog(@"%@",dic);
        
        
        [_allGroupContacts addObject:dic];
        
        
    }];
    
    
    
    NSMutableArray *otherGroup=[self dealWithGroupContactsWithArray:allOtherContacts];
//    
//    NSMutableDictionary *otherdic=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"未分组",@"groupName",[NSNumber numberWithInt:0],@"groupId", nil];
//
//    
//    [otherdic setObject:otherGroup forKey:@"groupArray"];
//    
//    
//    
//    [_allGroupContacts addObject:otherdic];
//
    //从分组中去掉了未完成分组，所以后边从分组中取联系人会缺少未分组的，在这里添加完成

   
  [_allContracts addObjectsFromArray:otherGroup];
    
    for (id obj in _allGroupContacts) {
        
        
        NSDictionary *dic=(NSDictionary *)obj;
        
        
        NSArray *array=[dic objectForKey:@"groupArray"];
        
        
        [_allContracts addObjectsFromArray:array];
        
        
        
    }
    
    
    
  //  NSLog(@"%@\n%@\n",_allContracts,_allGroupContacts);
    
    
    
    
    
    
}
-(NSString *)getFilePath:(NSString *)filePath
{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    
    
    NSString *path=[[paths objectAtIndex:0] stringByAppendingPathComponent:filePath];
    
    
    
    return path;
    
    
}


//处理联系人
-(NSMutableArray *)dealWithGroupContactsWithArray:(NSArray *)allContracts
{

    
    
    self.databaseFilePath = [[NSBundle mainBundle] pathForResource:@"database"
                                                            ofType:@"sqlite3"];
    
    self.telDatabaseFilePath =[[NSBundle mainBundle] pathForResource:@"Region"
                                                              ofType:@"sqlite"];
    
    
    if (sqlite3_open([self.databaseFilePath UTF8String], &_database)
        != SQLITE_OK) {
        sqlite3_close(self.database);
        NSAssert(0, @"打开数据库失败！");
    }
    
    if (sqlite3_open([self.telDatabaseFilePath UTF8String], &_telRegionDatabase)
        != SQLITE_OK) {
        sqlite3_close(self.telRegionDatabase);
        NSAssert(0, @"打开固话数据库失败！");
    }
    
    
    
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(queue, ^{
//        
//        
//        
//        
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            
//            
//            
//            
//            
//            //关闭数据库z
//            sqlite3_close(self.database);
//            
//            sqlite3_close(self.telRegionDatabase);
//            
//            
//        });
//    });

    
    
    
    
    
    
    
    
    
    
    
    NSMutableArray *groupArray=[NSMutableArray array];
    
    

    for (int i=0; i<allContracts.count; i++) {
        
        
        
        
        NSData *imageData = [NSMutableData data];
        
        
        
        ABRecordRef record = (__bridge ABRecordRef)[allContracts objectAtIndex:i];
        //取得姓名
        CFStringRef  firstNameRef =  ABRecordCopyValue(record, kABPersonFirstNameProperty);
        NSString * firstName = (__bridge NSString *)firstNameRef;
        
        CFStringRef lastNameRef = ABRecordCopyValue(record, kABPersonLastNameProperty);
        NSString * lastName = (__bridge NSString *)lastNameRef;
        
        
        
        
        CFStringRef compositeNameRef = ABRecordCopyCompositeName(record);
        NSString * compositeName = (__bridge NSString *)(ABRecordCopyCompositeName(record));
        
        firstNameRef != NULL ? CFRelease(firstNameRef) : NULL;
        lastNameRef != NULL ? CFRelease(lastNameRef) : NULL;
        compositeNameRef != NULL ? CFRelease(compositeNameRef) : NULL;
        
        
        if ([compositeName containsString:@"^"]||[compositeName containsString:@"*" ]||[compositeName isEqualToString:@""]||compositeName==nil) {
            
            
            continue;
            
        }

        
        
        
        //取得联系人的ID
        int recordID = (int)ABRecordGetRecordID(record);
        //联系人头像
//        if(ABPersonHasImageData(record))
//        {
//            //            NSData * imageData = ( NSData *)ABPersonCopyImageData(record);
            imageData = (__bridge NSMutableData*)ABPersonCopyImageData(record);
        
        
//        if (imageData==nil) {
//            imageData=UIImagePNGRepresentation([self getDefaultHeadImage]);
//        }
        
        
        
        
            
//        }
        
        
        //处理联系人电话号码
        ABMultiValueRef  phones = ABRecordCopyValue(record, kABPersonPhoneProperty);
        
        for(int i = 0; i < ABMultiValueGetCount(phones); i++)
        {
            ECContactObject *contact=[[ECContactObject alloc]init];
            CFStringRef phoneLabelRef = ABMultiValueCopyLabelAtIndex(phones, i);
            CFStringRef localizedPhoneLabelRef = ABAddressBookCopyLocalizedLabel(phoneLabelRef);
            CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(phones, i);
            NSString * localizedPhoneLabel = (__bridge NSString *) localizedPhoneLabelRef;
            NSString * phoneNumber = (__bridge NSString *)phoneNumberRef;
            
            contact.contactPhoneNumber=phoneNumber;
            contact.phoneLabel=localizedPhoneLabel;
            
            
            //释放内存
            phoneLabelRef == NULL ? : CFRelease(phoneLabelRef);
            localizedPhoneLabelRef == NULL ? : CFRelease(localizedPhoneLabelRef);
            phoneNumberRef == NULL ? : CFRelease(phoneNumberRef);
            
            
            contact.firstName = firstName;
            contact.lastName = lastName;
            contact.imageData = imageData;
            contact.recordID = [NSNumber numberWithInt:recordID];
            contact.contactName = compositeName;
            
            NSLog(@"%@",contact.contactName);
            

            
            if ([contact.phoneLabel hasSuffix:@"移动"]||[contact.phoneLabel hasSuffix:@"联通"]||[contact.phoneLabel hasSuffix:@"电信"]||[contact.phoneLabel hasSuffix:@"固话"]) {
                
                
                contact.carrierName=[contact.phoneLabel substringFromIndex:contact.phoneLabel.length-2];
                
                
                contact.contactAreaName=[contact.phoneLabel substringToIndex:contact.phoneLabel.length-2];
                
                contact.showCallerID=contact.phoneLabel;
                
                NSLog(@"%@_______%@_____%@",contact.phoneLabel,contact.carrierName,contact.contactAreaName);
                
                
            }else
            {
                
                
                
                if ([contact.contactPhoneNumber hasPrefix:@"0"]||[self isMobileNumber:contact.contactPhoneNumber]) {
                    
                    
                    
                    contact=[self updateLocationAndCarries:contact];

                    
                    
                }

                
            }

            
           
            
            [groupArray addObject:contact];
            
        }
        
        
      
        
        
        if(phones != NULL) CFRelease(phones);
        CFRelease(record);
        
        
    
        
        
    }
    
    //关闭数据库z
                sqlite3_close(self.database);
    
                sqlite3_close(self.telRegionDatabase);

    return groupArray;

}
- (NSString*)checkCarriers:(NSString*)string{
    NSString * carriers = nil;
    if ([[string substringToIndex:3] isEqualToString:@"130"] || [[string substringToIndex:3] isEqualToString:@"131"]) {
        carriers = @"MOBILE130131";
    }else if ([[string substringToIndex:3] isEqualToString:@"132"] || [[string substringToIndex:3] isEqualToString:@"133"]) {
        carriers = @"MOBILE132133";
    }else if ([[string substringToIndex:3] isEqualToString:@"134"] || [[string substringToIndex:3] isEqualToString:@"135"]) {
        carriers = @"MOBILE134135";
    }else if ([[string substringToIndex:3] isEqualToString:@"136"] || [[string substringToIndex:3] isEqualToString:@"137"]) {
        carriers = @"MOBILE136137";
    }else if ([[string substringToIndex:3] isEqualToString:@"138"] || [[string substringToIndex:3] isEqualToString:@"139"]) {
        carriers = @"MOBILE138139";
    }else if ([[string substringToIndex:3] isEqualToString:@"145"] || [[string substringToIndex:3] isEqualToString:@"147"]) {
        carriers = @"MOBILE145147";
    }else if ([[string substringToIndex:3] isEqualToString:@"150"] || [[string substringToIndex:3] isEqualToString:@"151"]) {
        carriers = @"MOBILE150151";
    }else if ([[string substringToIndex:3] isEqualToString:@"152"] || [[string substringToIndex:3] isEqualToString:@"153"]) {
        carriers = @"MOBILE152153";
    }else if ([[string substringToIndex:3] isEqualToString:@"155"] || [[string substringToIndex:3] isEqualToString:@"156"]) {
        carriers = @"MOBILE155156";
    }else if ([[string substringToIndex:3] isEqualToString:@"157"] || [[string substringToIndex:3] isEqualToString:@"158"]) {
        carriers = @"MOBILE157158";
    }else if ([[string substringToIndex:3] isEqualToString:@"159"] || [[string substringToIndex:3] isEqualToString:@"180"]) {
        carriers = @"MOBILE159180";
    }else if ([[string substringToIndex:3] isEqualToString:@"181"] || [[string substringToIndex:3] isEqualToString:@"182"]) {
        carriers = @"MOBILE181182";
    }else if ([[string substringToIndex:3] isEqualToString:@"183"] || [[string substringToIndex:3] isEqualToString:@"184"]) {
        carriers = @"MOBILE183184";
    }else if ([[string substringToIndex:3] isEqualToString:@"185"] || [[string substringToIndex:3] isEqualToString:@"186"]) {
        carriers = @"MOBILE185186";
    }else if ([[string substringToIndex:3] isEqualToString:@"187"] || [[string substringToIndex:3] isEqualToString:@"188"]|| [[string substringToIndex:3] isEqualToString:@"189"]) {
        carriers = @"MOBILE187188189";
    }
    return carriers;
}



-(ECContactObject *)updateLocationAndCarries:(ECContactObject *)contact
{
    
    NSString * testString = nil;
    
    
    
    testString=contact.contactPhoneNumber;
    
    if (![testString hasPrefix:@"0"]) {
        testString = [testString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    
    
    
    testString = [testString stringByReplacingOccurrencesOfString:@"(" withString:@""];
    testString = [testString stringByReplacingOccurrencesOfString:@")" withString:@""];
    testString = [testString stringByReplacingOccurrencesOfString:@" " withString:@""];
    testString = [testString stringByReplacingOccurrencesOfString:@"+" withString:@""];
    if ([testString hasPrefix:@"86"]) {
        
        
        testString=[testString substringFromIndex:2];
        
    }
    
    
    
    
    
    if (testString.length >= 7) {
        //打开数据库
        NSString * string = [testString substringToIndex:7];
        //执行查询
        if ([[self checkCarriers:string] isEqualToString:@"MOBILE130131"]) {
            self.query = @"SELECT * FROM MOBILE130131 WHERE phoneNmber=?";
        }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE132133"]) {
            self.query = @"SELECT * FROM MOBILE132133 WHERE phoneNmber=?";
        }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE134135"]) {
            self.query = @"SELECT * FROM MOBILE134135 WHERE phoneNmber=?";
        }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE136137"]) {
            self.query = @"SELECT * FROM MOBILE136137 WHERE phoneNmber=?";
        }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE138139"]) {
            self.query = @"SELECT * FROM MOBILE138139 WHERE phoneNmber=?";
        }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE145147"]) {
            self.query = @"SELECT * FROM MOBILE145147 WHERE phoneNmber=?";
        }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE150151"]) {
            self.query = @"SELECT * FROM MOBILE150151 WHERE phoneNmber=?";
        }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE152153"]) {
            self.query = @"SELECT * FROM MOBILE152153 WHERE phoneNmber=?";
        }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE155156"]) {
            self.query = @"SELECT * FROM MOBILE155156 WHERE phoneNmber=?";
        }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE157158"]) {
            self.query = @"SELECT * FROM MOBILE157158 WHERE phoneNmber=?";
        }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE159180"]) {
            self.query = @"SELECT * FROM MOBILE159180 WHERE phoneNmber=?";
        }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE181182"]) {
            self.query = @"SELECT * FROM MOBILE181182 WHERE phoneNmber=?";
        }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE183184"]) {
            self.query = @"SELECT * FROM MOBILE183184 WHERE phoneNmber=?";
        }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE185186"]) {
            self.query = @"SELECT * FROM MOBILE185186 WHERE phoneNmber=?";
        }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE187188189"]) {
            self.query = @"SELECT * FROM MOBILE187188189 WHERE phoneNmber=?";
        }else if ([string hasPrefix:@"0"])
        {
            //固定电话
            
            testString = [contact.contactPhoneNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
            
            testString = [testString stringByReplacingOccurrencesOfString:@")" withString:@""];
            testString = [testString stringByReplacingOccurrencesOfString:@" " withString:@""];
            testString = [testString stringByReplacingOccurrencesOfString:@"+" withString:@""];
            
            
           // string=[[testString componentsSeparatedByString:@"-"] objectAtIndex:0];
           
            NSString *str3=[testString substringToIndex:3];
            
            NSString *str4=[testString substringToIndex:4];
            
            
            
            self.query = @"SELECT * FROM Region WHERE Number=? OR Number=?";
            
            sqlite3_stmt *statement;
            
            if (sqlite3_prepare_v2(self.telRegionDatabase, [self.query UTF8String], -1, &statement,nil) == SQLITE_OK) {
                sqlite3_bind_text(statement, 1, [str3 UTF8String], -1, NULL);
                sqlite3_bind_text(statement, 2, [str4 UTF8String], -1, NULL);
                //依次读取数据库表格FIELDS中每行的内容
                while (sqlite3_step(statement) == SQLITE_ROW) {
                    //获得数据
                    char *carriersName = (char *)sqlite3_column_text(statement, 4);
                    char *city = (char *)sqlite3_column_text(statement, 3);
                    char *province = (char *)sqlite3_column_text(statement, 2);
                    char *number = (char *)sqlite3_column_text(statement, 1);
                    NSString * provinceString = [[NSString alloc] initWithUTF8String:province];
                    NSString * cityString = [[NSString alloc] initWithUTF8String:city];
                    NSString * phoneNumber = [[NSString alloc] initWithUTF8String:number];
                    if ([str3 isEqualToString:phoneNumber]||[str4 isEqualToString:phoneNumber]) {
                        contact.carrierName = [[NSString stringWithUTF8String:carriersName]stringByReplacingOccurrencesOfString:@"固定电话" withString:@"固话"];
                        if([provinceString isEqualToString:cityString]){
                            contact.contactAreaName = provinceString;
                        }else{
                            contact.contactAreaName = [NSString stringWithFormat:@"%@%@",provinceString,cityString];
                        }
                        contact.showCallerID = [NSString stringWithFormat:@"%@%@",contact.contactAreaName,contact.carrierName];
                        
                        
                        
                        if (contact.contactName) {
                            
                            if ([contact.phoneLabel hasSuffix:@"移动"]||[contact.phoneLabel hasSuffix:@"联通"]||[contact.phoneLabel hasSuffix:@"电信"]||[contact.phoneLabel hasSuffix:@"固话"]) {

                            }else {

                                contact.phoneLabel=contact.showCallerID;
                                [self changeLocalizedPhoneLabel:contact];
                                
                            }
                        }
                        return contact;
                    }
                }
                sqlite3_finalize(statement);
                
            }
        }else{
            contact.contactAreaName = @"未知号码";
            return contact;
        }

        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(self.database, [self.query UTF8String], -1, &statement,nil) == SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [string UTF8String], -1, NULL);
            //依次读取数据库表格FIELDS中每行的内容
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //获得数据
                char *carriersName = (char *)sqlite3_column_text(statement, 3);
                char *city = (char *)sqlite3_column_text(statement, 2);
                char *province = (char *)sqlite3_column_text(statement, 1);
                char *number = (char *)sqlite3_column_text(statement, 0);
                NSString * provinceString = [[NSString alloc] initWithUTF8String:province];
                NSString * cityString = [[NSString alloc] initWithUTF8String:city];
                NSString * phoneNumber = [[NSString alloc] initWithUTF8String:number];
                if ([string isEqualToString:phoneNumber]) {
                    contact.carrierName = [[NSString stringWithUTF8String:carriersName] stringByReplacingOccurrencesOfString:@"中国" withString:@""];
                    if([provinceString isEqualToString:cityString]){
                        contact.contactAreaName = provinceString;
                    }else{
                        contact.contactAreaName = [NSString stringWithFormat:@"%@%@",provinceString,cityString];
                    }
                    contact.showCallerID = [NSString stringWithFormat:@"%@%@",contact.contactAreaName,contact.carrierName];
                    
                    if (contact.contactName) {
                        
                        if ([contact.phoneLabel hasSuffix:@"移动"]||[contact.phoneLabel hasSuffix:@"联通"]||[contact.phoneLabel hasSuffix:@"电信"]||[contact.phoneLabel hasSuffix:@"固话"]) {
                            
                        }else {
                            contact.phoneLabel=contact.showCallerID;
                            
                            if ([self isMobileNumber:testString]) {
                                
                                [self changeLocalizedPhoneLabel:contact];
                                
                            }
                                                        
                        }
                        
                        
                        
                    }
                    
                    
                    
                    return contact;
                }
            }
            sqlite3_finalize(statement);
        }
        
        
        
        
        
        
        
        
        
        
    }
    
    return contact;


}


//多号码改标签
- (void)changeLocalizedPhoneLabel:(ECContactObject*)contact{
    
    
    ABRecordRef record=ABAddressBookGetPersonWithRecordID(self.addressBook, [contact.recordID intValue]);
    
    ABMultiValueRef phone = ABRecordCopyValue(record, kABPersonPhoneProperty);
    //NSLog(@"-------------------%ld",ABMultiValueGetCount(phone));
    
    ABMutableMultiValueRef multi = ABMultiValueCreateMutableCopy(phone);
    

    
    
    
    
    ABMultiValueRef  phones = ABRecordCopyValue(record, kABPersonPhoneProperty);
    
    for(int i = 0; i < ABMultiValueGetCount(phones); i++)
    {

         CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(phones, i);
        
        
        
        NSString * testString=(__bridge NSString *)(phoneNumberRef);
        
//        if (![testString hasPrefix:@"0"]) {
//            testString = [testString stringByReplacingOccurrencesOfString:@"-" withString:@""];
//        }
//        
//        
//        
//        testString = [testString stringByReplacingOccurrencesOfString:@"(" withString:@""];
//        testString = [testString stringByReplacingOccurrencesOfString:@")" withString:@""];
//        testString = [testString stringByReplacingOccurrencesOfString:@" " withString:@""];
//        testString = [testString stringByReplacingOccurrencesOfString:@"+" withString:@""];
//        if (testString.length>0&&[[testString substringToIndex:2] isEqualToString:@"86"]) {
//            testString = [testString stringByReplacingOccurrencesOfString:@"86" withString:@""];
//        }

        
        
        if ([contact.contactPhoneNumber isEqualToString:testString]) {
            
            
            int index=i;
            
                        
            ABMultiValueReplaceLabelAtIndex(multi, (__bridge CFStringRef)(contact.showCallerID), index);
            
             ABRecordSetValue(record, kABPersonPhoneProperty, multi, NULL);
            
            
            break;
            
        }
        
        
    }
    
    
//    if (ABMultiValueGetCount(phone) == 1) {
//        
//        
//        
//        ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABMultiStringPropertyType);//原来为kABPersonPhoneProperty，有log出错误信息，后修改为这个，错误信息消失。
//        ABMultiValueAddValueAndLabel(multi, (__bridge CFTypeRef)contact.contactPhoneNumber, (__bridge CFTypeRef)contact.showCallerID, NULL);
//        ABRecordSetValue(record, kABPersonPhoneProperty, multi, NULL);
//        
//    }
    
    
    // 保存修改的通讯录对象
    
    
    ABAddressBookSave(_addressBook, NULL);
    
    
//    // 初始化并创建通讯录对象，记得释放内存
//   
//    // 获取通讯录中所有的联系人
//    NSArray *array = (__bridge NSArray*)ABAddressBookCopyArrayOfAllPeople(_addressBook);
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
//    // 保存修改的通讯录对象
//    ABAddressBookSave(_addressBook, NULL);
  }



 //*手机号码验证 MODIFIED BY HELENSONG*/
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    
    
    mobileNum = [mobileNum stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNum = [mobileNum stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNum = [mobileNum stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNum = [mobileNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNum = [mobileNum stringByReplacingOccurrencesOfString:@"+" withString:@""];
//    if (mobileNum.length>0&&[[mobileNum substringToIndex:2] isEqualToString:@"86"]) {
//        mobileNum = [mobileNum stringByReplacingOccurrencesOfString:@"86" withString:@""];
//    }
    
    if ([mobileNum hasPrefix:@"86"]) {
        
        
        mobileNum=[mobileNum substringFromIndex:2];
        
    }
    
   
    

  
    
    
//    /**
//     * 手机号码
//     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//     * 联通：130,131,132,152,155,156,185,186
//     * 电信：133,1349,153,180,189
//     */
//    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
//    /**
//     10         * 中国移动：China Mobile
//     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//     12         */
//    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2783])\\d)\\d{7}$";
//    /**
//     15         * 中国联通：China Unicom
//     16         * 130,131,132,152,155,156,185,186
//     17         */
//    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
//    /**
//     20         * 中国电信：China Telecom
//     21         * 133,1349,153,180,189,181
//     22         */
//    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
//    
//    /**
//     25         * 大陆地区固话及小灵通
//     26         * 区号：010,020,021,022,023,024,025,027,028,029
//     27         * 号码：七位或八位
//     28         */
//    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
//    
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
//    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
//    
//    
//    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
//        || ([regextestcm evaluateWithObject:mobileNum] == YES)
//        || ([regextestct evaluateWithObject:mobileNum] == YES)
//        || ([regextestcu evaluateWithObject:mobileNum] == YES)
//        || ([regextestphs evaluateWithObject:mobileNum] == YES))
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
    
    
    if (mobileNum.length==11) {
        return YES;
    }else
    {
    
        return NO;
    
    }
    
    
    
}






#pragma mark 通用持久化操作

- (void)saveItemsToFile:(NSArray *)items cacheId:(NSString *)cacheId {
    
       
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"cache_%@", cacheId];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
    [items writeToFile:path atomically:YES];
    
    
}

- (NSArray *)loadItemsFromFile:(NSString *)cacheId {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"cache_%@", cacheId];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    
    NSArray *items = [[NSArray alloc] initWithContentsOfFile:path];//[NSMutableArray arrayWithContentsOfFile:path];
    //NSLog(@"%@",items);
    if (items == nil)
        items = [[NSMutableArray alloc] initWithCapacity:20];
    return items;
    
}


-(void)addHistory_recordWithRecordID:(NSNumber *)recordID  name:(NSString *)name  phoneNumber:(NSString *)phoneNum mark:(NSString*)mark
{


    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    
    
    
    if (recordID!=nil) {
 
        [dic setObject:recordID forKey:@"recordid"];
        
    
    }
    
    if (name!=nil) {
        
        
        
        [dic setObject:name forKey:@"name"];
        
        
        
    }
    
    if (phoneNum!=nil) {
   
        [dic setObject:phoneNum forKey:@"phonenum"];
    
    }
    
    
    if (mark!=nil) {
        
        [dic setObject:mark forKey:@"phonelbl"];
        
    }



    int date=[[NSDate date]timeIntervalSince1970];
    
    [dic setObject:[NSNumber numberWithInt:date] forKey:@"date"];
    
    
    [_history_record insertObject:dic atIndex:0];
    

    [self saveItemsToFile:_history_record cacheId:@"history"];
    

}


-(void)inquiryNumber:(NSString *)number relultBlock:(void(^)(NSString *address))resultBlock
{

    
    
    self.databaseFilePath = [[NSBundle mainBundle] pathForResource:@"database"
                                                            ofType:@"sqlite3"];
    
    self.telDatabaseFilePath =[[NSBundle mainBundle] pathForResource:@"Region"
                                                              ofType:@"sqlite"];
    
    
    if (sqlite3_open([self.databaseFilePath UTF8String], &_database)
        != SQLITE_OK) {
        sqlite3_close(self.database);
        NSAssert(0, @"打开数据库失败！");
    }
    
    if (sqlite3_open([self.telDatabaseFilePath UTF8String], &_telRegionDatabase)
        != SQLITE_OK) {
        sqlite3_close(self.telRegionDatabase);
        NSAssert(0, @"打开固话数据库失败！");
    }

    
    
    
    
    NSString *showCallerID=nil;


    NSString * testString = nil;
    
    
    
    testString=number;
    
    if (![testString hasPrefix:@"0"]) {
        testString = [testString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    
    
    
    testString = [testString stringByReplacingOccurrencesOfString:@"(" withString:@""];
    testString = [testString stringByReplacingOccurrencesOfString:@")" withString:@""];
    testString = [testString stringByReplacingOccurrencesOfString:@" " withString:@""];
    testString = [testString stringByReplacingOccurrencesOfString:@"+" withString:@""];
    if ([testString hasPrefix:@"86"]) {
        
        
        testString=[testString substringFromIndex:2];
        
    }
    
    
    
    
    
    if (testString.length >= 7) {
        //打开数据库
        NSString * string = [testString substringToIndex:7];
        //执行查询
        if ([[self checkCarriers:string] isEqualToString:@"MOBILE130131"]) {
            self.query = @"SELECT * FROM MOBILE130131 WHERE phoneNmber=?";
        }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE132133"]) {
            self.query = @"SELECT * FROM MOBILE132133 WHERE phoneNmber=?";
        }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE134135"]) {
            self.query = @"SELECT * FROM MOBILE134135 WHERE phoneNmber=?";
        }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE136137"]) {
            self.query = @"SELECT * FROM MOBILE136137 WHERE phoneNmber=?";
        }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE138139"]) {
            self.query = @"SELECT * FROM MOBILE138139 WHERE phoneNmber=?";
        }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE145147"]) {
            self.query = @"SELECT * FROM MOBILE145147 WHERE phoneNmber=?";
        }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE150151"]) {
            self.query = @"SELECT * FROM MOBILE150151 WHERE phoneNmber=?";
        }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE152153"]) {
            self.query = @"SELECT * FROM MOBILE152153 WHERE phoneNmber=?";
        }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE155156"]) {
            self.query = @"SELECT * FROM MOBILE155156 WHERE phoneNmber=?";
        }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE157158"]) {
            self.query = @"SELECT * FROM MOBILE157158 WHERE phoneNmber=?";
        }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE159180"]) {
            self.query = @"SELECT * FROM MOBILE159180 WHERE phoneNmber=?";
        }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE181182"]) {
            self.query = @"SELECT * FROM MOBILE181182 WHERE phoneNmber=?";
        }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE183184"]) {
            self.query = @"SELECT * FROM MOBILE183184 WHERE phoneNmber=?";
        }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE185186"]) {
            self.query = @"SELECT * FROM MOBILE185186 WHERE phoneNmber=?";
        }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE187188189"]) {
            self.query = @"SELECT * FROM MOBILE187188189 WHERE phoneNmber=?";
        }else
        {
        
            
            showCallerID=@"本地号码";
            
            resultBlock(showCallerID);
            
            return;
        
        }
        
        
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(self.database, [self.query UTF8String], -1, &statement,nil) == SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [string UTF8String], -1, NULL);
            //依次读取数据库表格FIELDS中每行的内容
            
            int count=0;
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                count ++;
                //获得数据
                char *carriersName = (char *)sqlite3_column_text(statement, 3);
                char *city = (char *)sqlite3_column_text(statement, 2);
                char *province = (char *)sqlite3_column_text(statement, 1);
                char *number = (char *)sqlite3_column_text(statement, 0);
                NSString * provinceString = [[NSString alloc] initWithUTF8String:province];
                NSString * cityString = [[NSString alloc] initWithUTF8String:city];
                NSString * phoneNumber = [[NSString alloc] initWithUTF8String:number];
                if ([string isEqualToString:phoneNumber]) {
                    
                    
                    NSString *strCarrierName=[[NSString stringWithUTF8String:carriersName] stringByReplacingOccurrencesOfString:@"中国" withString:@""];
                    NSString *strAreaName;

                    
                    
                   
                    if([provinceString isEqualToString:cityString]){
                        strAreaName = provinceString;
                    }else{
                        strAreaName = [NSString stringWithFormat:@"%@%@",provinceString,cityString];
                    }
                    showCallerID = [NSString stringWithFormat:@"%@%@",strAreaName,strCarrierName];
                    
                    
                    
                    
                    resultBlock(showCallerID);
  
                    
                    
                    return;
                }
            }
            
            
            if (count==0) {
                
                
                showCallerID=@"本地号码";
                
                resultBlock(showCallerID);
                
                
            }
            
            
            sqlite3_finalize(statement);
        }
        
        

        
        
        
    }else if ([testString hasPrefix:@"0"]&&testString.length==4)
    {
        //固定电话
        
        testString = [number stringByReplacingOccurrencesOfString:@"(" withString:@""];
        
        testString = [testString stringByReplacingOccurrencesOfString:@")" withString:@""];
        testString = [testString stringByReplacingOccurrencesOfString:@" " withString:@""];
        testString = [testString stringByReplacingOccurrencesOfString:@"+" withString:@""];
        
        
        // string=[[testString componentsSeparatedByString:@"-"] objectAtIndex:0];
        
        NSString *str3=[testString substringToIndex:3];
        
        NSString *str4=[testString substringToIndex:4];
        
        
        
        self.query = @"SELECT * FROM Region WHERE Number=? OR Number=?";
        
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(self.telRegionDatabase, [self.query UTF8String], -1, &statement,nil) == SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [str3 UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 2, [str4 UTF8String], -1, NULL);
            //依次读取数据库表格FIELDS中每行的内容
            
            
            int count=0;
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                count++;
                //获得数据
                char *carriersName = (char *)sqlite3_column_text(statement, 4);
                char *city = (char *)sqlite3_column_text(statement, 3);
                char *province = (char *)sqlite3_column_text(statement, 2);
                char *number = (char *)sqlite3_column_text(statement, 1);
                NSString * provinceString = [[NSString alloc] initWithUTF8String:province];
                NSString * cityString = [[NSString alloc] initWithUTF8String:city];
                NSString * phoneNumber = [[NSString alloc] initWithUTF8String:number];
                if ([str3 isEqualToString:phoneNumber]||[str4 isEqualToString:phoneNumber]) {
                    
                    
                    NSString *strCarrierName=[[NSString stringWithUTF8String:carriersName]stringByReplacingOccurrencesOfString:@"固定电话" withString:@"固话"];
                    
                    NSString *strAreaName;
                    
                    
                    if([provinceString isEqualToString:cityString]){
                        strAreaName = provinceString;
                    }else{
                        strAreaName = [NSString stringWithFormat:@"%@%@",provinceString,cityString];
                    }
                    showCallerID = [NSString stringWithFormat:@"%@%@",strAreaName,strCarrierName];
                    
                    
                    resultBlock(showCallerID);
                    
                    
                    return;
                }
            }
            
            
            if (count==0) {
                
                
                showCallerID=@"本地号码";
                
                resultBlock(showCallerID);
                
                
            }

            
            
            sqlite3_finalize(statement);
            
        }else{
            showCallerID = @"本地号码";
            resultBlock(showCallerID);
            
            return ;
        }
        

        
        
        
    }







}



#pragma mark 获得默认头像
-(UIImage *)getDefaultHeadImage
{

    int i=arc4random()%5;
    
    NSString *name=[NSString stringWithFormat:@"people_%d",i+1];


    UIImage *image=[UIImage imageNamed:name];
    
    
    return image;


}

-(int)getDefaultHeadImageIdWithIndex:(NSInteger)index
{
    
    int i=index%5;
    
      
    return i+1;
    
    
}





@end
