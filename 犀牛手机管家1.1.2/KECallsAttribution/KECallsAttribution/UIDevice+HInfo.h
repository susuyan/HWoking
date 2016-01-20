//
//  UIDevice+HInfo.h
//  KECallsAttribution
//
//  Created by EverZones on 16/1/19.
//  Copyright © 2016年 K.BLOCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (HInfo)

/**
 *  获取设备名字
 *
 *  @return eg：iPhone 5 ， iPhone 6s
 */
+ (NSString *)devicenName;

/**
 *  获取可用空间
 *
 *  @return eg：100 MB
 */
+ (float)freeDiskSpaceInBytes;
@end
