//
//  HNumberHelper.h
//  Harassment
//
//  Created by EverZones on 15/11/11.
//  Copyright (c) 2015年 EverZones. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNumberHelper : NSObject

+ (instancetype)sharedManager;

+ (BOOL)isMobileNumber:(NSString *)mobileNumber;

- (NSString *)attributionWithPhoneNumber:(NSString *)phoneNumber;

@end
