//
//  HDefaults.m
//  Harassment
//
//  Created by EverZones on 15/11/16.
//  Copyright (c) 2015年 EverZones. All rights reserved.
//

#import "HDefaults.h"
#import "UIDevice+HInfo.h"
static HDefaults *defaults;
@implementation HDefaults

#pragma mark -
+ (instancetype)sharedDefaults {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaults = [[HDefaults alloc] init];
      
    });
    [defaults setupPartDefaultValue];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    defaults.localeString = [userDefaults stringForKey:@"localeString"];
    defaults.isOpenHarassment = [userDefaults boolForKey:@"openHarassment"];
    defaults.isReachable = [userDefaults boolForKey:@"isReachable"];
    
    defaults.isHintFreeSpace = [userDefaults boolForKey:@"HintFreeSpace"];
    defaults.isTestedSpeed = [userDefaults boolForKey:@"TestedSpeed"];
    defaults.lastTestSpeedDate = [userDefaults objectForKey:@"lastTestSpeedDate"];
    
    
    return defaults;
}
#pragma mark - Private
- (void)setupPartDefaultValue {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([UIDevice freeDiskSpaceInBytes] < 600) {
        [userDefaults setBool:YES forKey:@"HintFreeSpace"];
    }else {
        [userDefaults setBool:NO forKey:@"HintFreeSpace"];
    }
    
    if ([self isOptimizeWithDate:self.lastTestSpeedDate]) {
        [userDefaults setBool:YES forKey:@"TestedSpeed"];
    }else {
        [userDefaults setBool:NO forKey:@"TestedSpeed"];
    }
}

//根据得到的日期算下间隔，判断是否要优化。
- (BOOL)isOptimizeWithDate:(NSDate *)date{
    //    interval	time
    
    if (date) {
        NSTimeInterval maxInterval = 24*60*60;
        
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:date];
        if (timeInterval > maxInterval) {
            return YES;
        }else {
            return NO;
        }
    }else {
        return YES;
    }
    
}
@end
