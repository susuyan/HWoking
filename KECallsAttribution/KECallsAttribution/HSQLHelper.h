//
//  HSQLHelper.h
//  Harassment
//
//  Created by EverZones on 15/11/11.
//  Copyright (c) 2015年 EverZones. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface HSQLHelper : NSObject

+ (instancetype)sharedManager;

- (NSString *)selectAreaWithPhoneNumber:(NSString *)phoneNumber;

- (NSString *)selectTypeWithPhoneNumber:(NSString *)phoneNumber;

- (NSString *)selectAreaWithAreaCode:(NSString *)areaCode;

- (NSString*)checkCarriers:(NSString*)string;

@end
