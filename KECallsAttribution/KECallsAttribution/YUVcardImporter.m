//
//  YUVcardImporter.m
//  VCF
//
//  Created by EverZones on 15/11/6.
//  Copyright (c) 2015年 EverZones. All rights reserved.
//

#import "YUVcardImporter.h"
#import <UIKit/UIKit.h>


@implementation YUVcardImporter

- (id)init {
    if (self = [super init]) {
        NSError *error;
        CFErrorRef castError = (__bridge CFErrorRef)error;
         addressBook = ABAddressBookCreateWithOptions(NULL, &castError);
        
        __block BOOL accessAllowed = NO;
        
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        //获取读取通讯的权限
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            
            accessAllowed = granted;
            dispatch_semaphore_signal(sema);
            
        });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
        _phoneNumbers = [NSMutableArray array];
        _labels = [NSMutableArray array];
        _harassmentContacts = [NSMutableArray array];
    }
    return self;
}
- (void)dealloc {
    CFRelease(addressBook);

}

- (void)parse {
    NSString *filename = [[NSBundle mainBundle] pathForResource:@"Contacts" ofType:@"vcf"];
    NSData *stringData = [NSData dataWithContentsOfFile:filename];
    NSString *vcardString = [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];
    
    NSArray *lines = [vcardString componentsSeparatedByString:@"\n"];
    
    for (NSString *line in lines) {
        
        [self parseLine:line];
    }
    [[NSUserDefaults standardUserDefaults] setObject:_harassmentContacts forKey:@"harassmentContacts"];
    
}

- (void)parseLine:(NSString *)line {
    if ([line hasPrefix:@"BEGIN"]) {
        personRecord = ABPersonCreate();
        multiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    }else if ([line hasPrefix:@"END"]) {
        [self addMultiVatlue:self.phoneNumbers andLabels:self.labels];
        
        [self addContactsIcon];
        
        ABRecordSetValue(personRecord, kABPersonPhoneProperty, multiValue, NULL);
        ABAddressBookAddRecord(addressBook, personRecord, NULL);
        ABAddressBookSave(addressBook, NULL);
        harassmentContactID = ABRecordGetRecordID(personRecord);
        [_harassmentContacts addObject:@(harassmentContactID)];
        
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

- (void)deleteNumberLibrary {
    [self deleteHarassmentContacts];
    [self deleteMarkedContact];
}

#pragma mark - private
- (BOOL)isContainString:(NSString *)containStr fromString:(NSString *)varString{
    if ([varString rangeOfString:containStr].location != NSNotFound) {
        return YES;
    }else {
        return NO;
    }
}

- (void)addContactsIcon {
    UIImage *image = [UIImage imageNamed:@"contact_icon.png"];
    NSData *imageData = UIImagePNGRepresentation(image);
    CFDataRef cfData = CFDataCreate(NULL, [imageData bytes], [imageData length]);
    ABPersonSetImageData(personRecord, cfData, NULL);
    CFRelease(cfData);
}
- (void)addMultiVatlue:(NSMutableArray *)phoneNums andLabels:(NSMutableArray *)labels {
    for (int i = 0; i < [phoneNums count]; i++) {
        ABMultiValueIdentifier obj = ABMultiValueAddValueAndLabel(multiValue, (__bridge CFStringRef)[phoneNums objectAtIndex:i], (__bridge CFStringRef)[labels objectAtIndex:i], &obj);
    }
}

- (void)deleteHarassmentContacts {
    NSArray *deletedIDs = [[NSUserDefaults standardUserDefaults] objectForKey:@"harassmentContacts"];
    if (deletedIDs) {
        for (NSNumber *personID in deletedIDs) {
            personRecord = ABAddressBookGetPersonWithRecordID(addressBook, [personID integerValue]);
            ABAddressBookRemoveRecord(addressBook, personRecord, NULL);
        }
        ABAddressBookSave(addressBook, NULL);
    }
    
}
- (void)deleteMarkedContact {
    NSNumber *personID = [[NSUserDefaults standardUserDefaults] objectForKey:@"markedContactID"];
    if (personID) {
    personRecord = ABAddressBookGetPersonWithRecordID(addressBook, [personID integerValue]);
    ABAddressBookRemoveRecord(addressBook, personRecord, NULL);
    ABAddressBookSave(addressBook, NULL);
    }
}


@end
