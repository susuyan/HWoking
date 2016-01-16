//
//  HNumberHelper.m
//  Harassment
//
//  Created by EverZones on 15/11/11.
//  Copyright (c) 2015年 EverZones. All rights reserved.
//

#import "HNumberHelper.h"
#import "HStringHelper.h"
#import "HSQLHelper.h"
static HNumberHelper *numberHelper;

@implementation HNumberHelper

+ (instancetype)sharedManager {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        numberHelper = [[HNumberHelper alloc] init];
    });
    return numberHelper;
}

- (instancetype)init {

    if (self = [super init]) {
        
    }
    return self;
}

#pragma mark - public method
+ (BOOL)isMobileNumber:(NSString *)mobileNumber{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNumber] == YES)
        || ([regextestcm evaluateWithObject:mobileNumber] == YES)
        || ([regextestct evaluateWithObject:mobileNumber] == YES)
        || ([regextestcu evaluateWithObject:mobileNumber] == YES)){
        
        return YES;
    }else{
        return NO;
    }
}


- (NSString *)attributionWithPhoneNumber:(NSString *)phoneNumber {
    if (phoneNumber.length == 7) {
        phoneNumber = [phoneNumber stringByAppendingString:@"1111"];
    }else if (phoneNumber.length == 3){
        phoneNumber = [phoneNumber stringByAppendingString:@"-00000000"];
    }else if (phoneNumber.length == 4){
        phoneNumber = [phoneNumber stringByAppendingString:@"-00000000"];
    }
   // return [self getLabelWithPhoneNumber:phoneNumber LabelType:NO];
    return [self getLabelWithPhoneNumber:phoneNumber];
}

#pragma mark - private method
//根据电话号码获取归属地
- (NSString *)getLabelWithPhoneNumber:(NSString *)phoneNumber {
    return [self getLabelWithPhoneNumber:phoneNumber LabelType:YES];
}

- (NSString *)getLabelWithPhoneNumber:(NSString *)phoneNumber LabelType:(BOOL)labelType {
    NSString *phone = [HStringHelper getPhoneNumberWithString:phoneNumber];
    if ([phone isEqualToString:@""] || !phone) {
        return @"";
    }
    NSString *area, *type;
    if (phone.length > 4) {
        area = [[HSQLHelper sharedManager] selectAreaWithPhoneNumber:phone];
        type = [[HSQLHelper sharedManager] selectTypeWithPhoneNumber:phone];
    }else{
        area = [[HSQLHelper sharedManager] selectAreaWithAreaCode:phone];
        type = @"电话";
    }
    
    if (labelType) {
        NSString *city = [HStringHelper getCityWithString:area];
        NSString *provice = [HStringHelper getProviceWithString:area];
        area = [provice stringByAppendingString:city];
        
        type = [HStringHelper getSimpleMobileTypeWithString:type];
    }
    
    if (![area isEqualToString:@""] && area) {
        return [NSString stringWithFormat:@"%@ %@", area, type];
    }
    return @"";
}


@end
