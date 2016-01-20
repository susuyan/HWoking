//
//  KEContactAddressBook.h
//  KECallsAttribution
//
//  Created by lichenWang on 14-1-13.
//  Copyright (c) 2014年 KERNEL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
@interface KEContactAddressBook : NSObject
@property (nonatomic,strong) NSString * firstName;
@property (nonatomic,strong) NSString * lastName;
@property (nonatomic,strong) NSString * compositeName;
@property (nonatomic,strong) NSMutableData * imageData;
@property (nonatomic,strong) NSMutableDictionary * phoneInfo;
@property (nonatomic,strong) NSMutableDictionary * emailInfo;
@property (nonatomic,assign) int recordID;
@property (nonatomic,assign) int sectionNumber;
@property (nonatomic,strong) NSMutableArray * allContacts;
@property (nonatomic)ABAddressBookRef addressBook;
@property (nonatomic)ABMultiValueRef  phoneMultiValueRef;
@property (nonatomic)BOOL hasRegister;
-(NSMutableArray *)allContacts;
@end
