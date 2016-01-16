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
    defaults.localeString = [[NSUserDefaults standardUserDefaults] stringForKey:@"localeString"];
    defaults.isOpenHarassment = [[NSUserDefaults standardUserDefaults] boolForKey:@"openHarassment"];
    defaults.isReachable = [[NSUserDefaults standardUserDefaults] boolForKey:@"isReachable"];
    
    return defaults;
}
@end
