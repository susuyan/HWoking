//
//  HVcardImporter.m
//  Harassment
//
//  Created by EverZones on 15/11/11.
//  Copyright (c) 2015年 EverZones. All rights reserved.
//

#import "HVcardImporter.h"
#import <UIKit/UIKit.h>
@implementation HVcardImporter

#pragma mark - Life cicle
- (id)init {
    if (self = [super init]) {
        NSError *error;
        CFErrorRef castError = (__bridge CFErrorRef)error;
        _addressBook = ABAddressBookCreateWithOptions(NULL, &castError);
        __block BOOL accessAllowed = NO;
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        //获取读取通讯的权限
        ABAddressBookRequestAccessWithCompletion(_addressBook, ^(bool granted, CFErrorRef error) {
            accessAllowed = granted;
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        _phoneNumbers = [NSMutableArray array];
        _labels = [NSMutableArray array];
        _personIDs = [NSMutableArray array];
    }
    return self;
}
- (void)dealloc {
        CFRelease(_addressBook);
}

#pragma mark - Public
- (void)parseWithAreaString:(NSString *)areaString {
    NSString *filename = [[NSBundle mainBundle] pathForResource:areaString ofType:@"vcf"];
    NSData *stringData = [NSData dataWithContentsOfFile:filename];
    NSString *vcardString = [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];
    
    NSArray *lines = [vcardString componentsSeparatedByString:@"\n"];
    
    for (NSString *line in lines) {
        
        [self parseLine:line];
    }
    [[NSUserDefaults standardUserDefaults] setObject:_personIDs forKey:@"personIDs"];
    
}

- (void)parseLine:(NSString *)line {
    if ([line hasPrefix:@"BEGIN"]) {
        personRecord = ABPersonCreate();
        multiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    }else if ([line hasPrefix:@"END"]) {
        [self addMultiVatlue:self.phoneNumbers andLabels:self.labels];
        
        [self addContactsIcon:personRecord];
        
        ABRecordSetValue(personRecord, kABPersonPhoneProperty, multiValue, NULL);
        
        ABAddressBookAddRecord(_addressBook, personRecord, NULL);
        ABAddressBookSave(_addressBook, NULL);
        personID = ABRecordGetRecordID(personRecord);
        [_personIDs addObject:@(personID)];
        
        [self.phoneNumbers removeAllObjects];
        [self.labels removeAllObjects];
    }else if ([line hasPrefix:@"TEL"]) {
        [self parseNumberLabel:line];
    }else if ([line hasPrefix:@"item"]) {
        [self parseNumberLabel:line];
    }
}

- (void)parseNumberLabel:(NSString *)line {
    NSArray *components = [line componentsSeparatedByString:@":"];
    
    NSString *temp0 = [components objectAtIndex:0];
    NSString *temp1 = [components objectAtIndex:1];
    
    if ([line hasPrefix:@"TEL"]) {
        
        [self.labels addObject:@"#手机归属地识别"];
        [self.phoneNumbers addObject:temp1];
        
    }else {
        
        if ([self isContainString:@"TEL" fromString:temp0]) {
            [self.phoneNumbers addObject:temp1];
        }else {
            [self.labels addObject:temp1];
        }
        
    }
    
    
}

- (void)deleteVCF {
    NSArray *deleteIDs = [[NSUserDefaults standardUserDefaults] objectForKey:@"personIDs"];
    if (deleteIDs == nil || deleteIDs.count == 0) {
        return;
    }
    for (NSNumber *personid in deleteIDs) {
        personRecord = ABAddressBookGetPersonWithRecordID(_addressBook, [personid intValue]);
        ABAddressBookRemoveRecord(_addressBook, personRecord, NULL);
    }
    ABAddressBookSave(_addressBook, NULL);
}
- (void)closeAntiHarassmentMode {
    [self deleteVCF];
//    NSString *markID = [[NSUserDefaults standardUserDefaults] stringForKey:@"markedContactsID"];
//    personRecord = ABAddressBookGetPersonWithRecordID(_addressBook, [markID intValue]);
//    ABAddressBookRemoveRecord(_addressBook, personRecord, NULL);
//    ABAddressBookSave(_addressBook, NULL);
    
}
#pragma mark - MarkPhoneNumber
- (void)markMessageSaveToContacts:(NSString *)markType phoneNumber:(NSString *)phoneNumber {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *markedContactsID = [defaults stringForKey:@"markedContactsID"];
    if (markedContactsID) {
        [self addMarkedContactsWithPersonID:markedContactsID markType:markType phoneNumber:phoneNumber];
        
    }else {
        [self createLabeledContact:markType phoneNumber:phoneNumber];

    }

}

- (NSDictionary *)getMarkedHistoricalData {
    
    NSString *contactsID = [[NSUserDefaults standardUserDefaults] stringForKey:@"markedContactsID"];
    ABRecordRef person = ABAddressBookGetPersonWithRecordID(_addressBook, [contactsID intValue]);
    ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);

    
    for (NSInteger i = 0; i < ABMultiValueGetCount(phones); i++) {
        [self.phoneNumbers addObject:(__bridge NSString *)(ABMultiValueCopyValueAtIndex(phones, i))];
        [self.labels addObject:(__bridge id)(ABMultiValueCopyLabelAtIndex(phones, i))];
    }
    
    ABAddressBookSave(_addressBook, NULL);
    
    NSDictionary *markDic = @{@"phoneNumbers": self.phoneNumbers,@"labels": self.labels};
    
    return markDic;
}

#pragma mark - Private
- (BOOL)isContainString:(NSString *)containStr fromString:(NSString *)varString{
    if ([varString rangeOfString:containStr].location != NSNotFound) {
        return YES;
    }else {
        return NO;
    }
}

- (void)addContactsIcon:(ABRecordRef)personRef{
    UIImage *image = [UIImage imageNamed:@"contact_icon"];
    NSData *imageData = UIImagePNGRepresentation(image);
    CFDataRef cfData = CFDataCreate(NULL, [imageData bytes], [imageData length]);
    ABPersonSetImageData(personRef, cfData, NULL);

}
- (void)addMultiVatlue:(NSMutableArray *)phoneNums andLabels:(NSMutableArray *)labels {
    for (int i = 0; i < [phoneNums count]; i++) {
        ABMultiValueIdentifier obj = ABMultiValueAddValueAndLabel(multiValue, (__bridge CFStringRef)[phoneNums objectAtIndex:i], (__bridge CFStringRef)[labels objectAtIndex:i], &obj);
    }
}

- (NSString *)copyFileToDocuments:(NSString *)fileName {
    NSFileManager*fileManager =[NSFileManager defaultManager];
    NSError*error;
    NSArray*paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString*documentsDirectory =[paths objectAtIndex:0];
    
    NSString*destPath =[documentsDirectory stringByAppendingPathComponent:fileName];
    if(![fileManager fileExistsAtPath:destPath]){
        NSString* sourcePath =[[NSBundle mainBundle] pathForResource:@"Contacts" ofType:@"vcf"];
        [fileManager copyItemAtPath:sourcePath toPath:destPath error:&error];
    }
    return destPath;
}
//创建一个被标记的号码的这个的一个联系人
- (void)createLabeledContact:(NSString *)markType phoneNumber:(NSString *)phoneNumber {
    ABRecordRef person = ABPersonCreate();
    NSArray *phones = [NSArray arrayWithObjects:@"#0被标记的人",phoneNumber,nil];
    NSArray *labels = [NSArray arrayWithObjects:@"#防骚扰电话识别",markType,nil];
    ABMultiValueRef dicc =ABMultiValueCreateMutable(kABMultiStringPropertyType);
    for (int i = 0; i < [phones count]; i ++) {
        ABMultiValueIdentifier obj = ABMultiValueAddValueAndLabel(dicc,(__bridge CFStringRef)[phones objectAtIndex:i], (__bridge CFStringRef)[labels objectAtIndex:i], &obj);
    }

    ABRecordSetValue(person, kABPersonPhoneProperty, dicc, NULL);
    ABAddressBookAddRecord(_addressBook, person, NULL);
    ABAddressBookSave(_addressBook, NULL);
    taggedContactID = ABRecordGetRecordID(person);
    [[NSUserDefaults standardUserDefaults] setObject:@(taggedContactID) forKey:@"markedContactsID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
}
//添加被标记号码的数据
- (void)addMarkedContactsWithPersonID:(NSString *)contactsID
                              markType:(NSString *)markType
                           phoneNumber:(NSString *)phoneNumber{
    ABRecordRef person = ABAddressBookGetPersonWithRecordID(_addressBook, [contactsID intValue]);
    ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
    ABMultiValueRef dicc =ABMultiValueCreateMutable(kABMultiStringPropertyType);
    
    for (NSInteger i = 0; i < ABMultiValueGetCount(phones); i++) {
        [self.phoneNumbers addObject:(__bridge NSString *)(ABMultiValueCopyValueAtIndex(phones, i))];
        [self.labels addObject:(__bridge id)(ABMultiValueCopyLabelAtIndex(phones, i))];
    }
    if (self.phoneNumbers.count == 0) {
        [self createLabeledContact:markType phoneNumber:phoneNumber];
        
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        
        [self.phoneNumbers insertObject:phoneNumber atIndex:1];
        [self.labels insertObject:markType atIndex:1];
        
        
        for (int i = 0; i < self.phoneNumbers.count; i ++) {
            ABMultiValueIdentifier obj = ABMultiValueAddValueAndLabel(dicc,(__bridge CFStringRef)[self.phoneNumbers objectAtIndex:i], (__bridge CFStringRef)[self.labels objectAtIndex:i], &obj);
        }
        [self addContactsIcon:person];
        ABRecordSetValue(person, kABPersonPhoneProperty, dicc, NULL);
        ABAddressBookAddRecord(_addressBook, person, NULL);
        ABAddressBookSave(_addressBook, NULL);
        taggedContactID = ABRecordGetRecordID(person);
        [[NSUserDefaults standardUserDefaults] setObject:@(taggedContactID) forKey:@"markedContactsID"];
        [[NSUserDefaults standardUserDefaults] synchronize];

    });
        
    
}
- (void)updateMarkedContactsWithIndexPath:(NSIndexPath *)indexpath {
    NSString *markedID = [[NSUserDefaults standardUserDefaults] stringForKey:@"markedContactsID"];
    
    ABRecordRef persons = ABAddressBookGetPersonWithRecordID(_addressBook, [markedID intValue]);
    ABMultiValueRef phones = ABRecordCopyValue(persons, kABPersonPhoneProperty);
    ABMultiValueRef dicc =ABMultiValueCreateMutable(kABMultiStringPropertyType);
    
    for (NSInteger i = 0; i < ABMultiValueGetCount(phones); i++) {
        [self.phoneNumbers addObject:(__bridge NSString *)(ABMultiValueCopyValueAtIndex(phones, i))];
        [self.labels addObject:(__bridge id)(ABMultiValueCopyLabelAtIndex(phones, i))];
    }
    if (self.phoneNumbers.count == 0) {
        
        return;
    }

    [self.phoneNumbers removeObjectAtIndex:indexpath.row + 1];
    [self.labels removeObjectAtIndex:indexpath.row + 1];
    
    
    for (int i = 0; i < self.phoneNumbers.count; i ++) {
        ABMultiValueIdentifier obj = ABMultiValueAddValueAndLabel(dicc,(__bridge CFStringRef)[self.phoneNumbers objectAtIndex:i], (__bridge CFStringRef)[self.labels objectAtIndex:i], &obj);
    }
    [self addContactsIcon:persons];
    ABRecordSetValue(persons, kABPersonPhoneProperty, dicc, NULL);
    ABAddressBookAddRecord(_addressBook, persons, NULL);
    ABAddressBookSave(_addressBook, NULL);
    taggedContactID = ABRecordGetRecordID(persons);
    [[NSUserDefaults standardUserDefaults] setObject:@(taggedContactID) forKey:@"markedContactsID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    CFRelease(dicc);
    
}

+ (void)CheckAddressBookAuthorization:(void (^)(bool isAuthorized))block {
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
    if (authStatus != kABAuthorizationStatusAuthorized) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {

            dispatch_async(dispatch_get_main_queue(), ^{

                if (error) {

                    NSLog(@"Error: %@", (__bridge NSError *)error);
                    
                } else if (!granted){
                                                             
                    
                    block(NO);
                    
                } else {
                    
                    block(YES);
                    
                }
                
            });
            
        });
    } else {
        block(YES);
    }
    

}


@end
