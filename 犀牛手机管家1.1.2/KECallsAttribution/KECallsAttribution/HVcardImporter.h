//
//  HVcardImporter.h
//  Harassment
//
//  Created by EverZones on 15/11/11.
//  Copyright (c) 2015年 EverZones. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
@interface HVcardImporter : NSObject {

    ABRecordRef personRecord;
    ABRecordID personID;
    ABRecordID taggedContactID;
    ABMutableMultiValueRef multiValue;
    
    NSString *base64image;
    
}

@property (nonatomic ,strong)NSMutableArray *phoneNumbers;
@property (nonatomic ,strong)NSMutableArray *labels;
@property (nonatomic ,strong)NSMutableArray *personIDs;
@property (nonatomic) ABAddressBookRef addressBook;

- (void)parseWithAreaString:(NSString *)areaString; 
- (void)parseLine:(NSString *)line;
- (void)parseNumberLabel:(NSString *)line;

- (void)deleteVCF;
- (void)closeAntiHarassmentMode;

//标记号码到通讯录
- (void)markMessageSaveToContacts:(NSString *)markType phoneNumber:(NSString *)phoneNumber;

//得到标记历史数据
- (NSDictionary *)getMarkedHistoricalData;

- (void)updateMarkedContactsWithIndexPath:(NSIndexPath *)indexpath;

+ (void)CheckAddressBookAuthorization:(void (^)(bool isAuthorized))block;

@end
