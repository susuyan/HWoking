//
//  HDefaults.m
//  Harassment
//
//  Created by EverZones on 15/11/16.
//  Copyright (c) 2015年 EverZones. All rights reserved.
//

#import "HDefaults.h"

static HDefaults *defaults;
@implementation HDefaults


+ (instancetype)sharedDefaults {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaults = [[HDefaults alloc] init];
      
    });
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    defaults.localeString = [userDefaults stringForKey:@"localeString"];
    defaults.isOpenHarassment = [userDefaults boolForKey:@"openHarassment"];
    defaults.isReachable = [userDefaults boolForKey:@"isReachable"];
    
    defaults.isHintFreeSpace = [userDefaults boolForKey:@"HintFreeSpace"];
    defaults.isTestedSpeed = [userDefaults boolForKey:@"TestedSpeed"];
    
    return defaults;
}
@end
