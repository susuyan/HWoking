//
//  SSBatteryInfo.h
//  SystemServicesDemo
//
//  Created by Shmoopi LLC on 9/18/12.
//  Copyright (c) 2012 Shmoopi LLC. All rights reserved.
//

#import "SystemServicesConstants.h"

@interface SSBatteryInfo : NSObject

// Battery Information

// Battery Level
+ (float)mainbatteryLevel;

// Charging?
+ (BOOL)charging;

// Fully Charged?
+ (BOOL)fullyCharged;

@end
