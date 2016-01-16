//
//  HDefaults.h
//  Harassment
//
//  Created by EverZones on 15/11/16.
//  Copyright (c) 2015年 EverZones. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDefaults : NSObject

@property (nonatomic) BOOL isOpenHarassment;

@property (nonatomic) BOOL isReachable;

@property (nonatomic, copy) NSString *localeString;

+ (instancetype)sharedDefaults;

@end
