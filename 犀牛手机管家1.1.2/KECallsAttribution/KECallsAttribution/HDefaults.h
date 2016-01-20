//
//  HDefaults.h
//  Harassment
//
//  Created by EverZones on 15/11/16.
//  Copyright (c) 2015年 EverZones. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDefaults : NSObject

/**
 *  是否开启防骚扰
 */
@property (nonatomic) BOOL isOpenHarassment;

@property (nonatomic) BOOL isReachable;
/**
 *  保存当前的归属地
 */
@property (nonatomic, copy) NSString *localeString;
/**
 *  是否提示内存不足
 */
@property (nonatomic) BOOL isHintFreeSpace;
/**
 *  是否提示进行网路测速
 */
@property (nonatomic) BOOL isTestedSpeed;
@property (nonatomic, strong) NSDate *lastTestSpeedDate;

+ (instancetype)sharedDefaults;

@end
