//
//  AppUtil.m
//  GameGuide
//
//  Created by 赵 进喜 on 14-4-29.
//  Copyright (c) 2014年 EverZones. All rights reserved.
//

#import "AppUtil.h"

@implementation AppUtil
+ (BOOL)productWasPurchased {
    NSString *purchased = [SFHFKeychainUtils getPasswordForUsername:BUNDLEID andServiceName:kProductIdInAppPurchase error:nil];
    if (purchased&&[purchased isEqualToString:@"YES"]) {
        return YES;
    } else {
        return NO;
    }
}

@end
