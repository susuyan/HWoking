//
//  HStringHelper.h
//  Harassment
//
//  Created by EverZones on 15/11/11.
//  Copyright (c) 2015年 EverZones. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
@interface HStringHelper : NSObject

+ (CGSize)getTextStringSize:(NSString *)aString with:(UIFont *)font;

+ (NSString *)getDataBasePath;

+ (NSString *)getPhoneNumberWithString:(NSString *)string;

+ (NSString *)getProviceWithString:(NSString *)string;

+ (NSString *)getCityWithString:(NSString *)string;

+ (NSString *)getSimpleMobileTypeWithString:(NSString *)string;


@end
