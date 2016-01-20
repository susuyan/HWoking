//
//  UIDeviceHelper.m
//  CocoaHelpers
//
//  Created by Shaun Harrison on 12/11/08.
//  Copyright 2008 enormego. All rights reserved.
//

#import "UIDeviceHelper.h"
#include <sys/sysctl.h>  
#include <mach/mach.h>

@implementation UIDevice (Helper)










// 获取当前设备不可用内存百分比
- (double)notAvailableMemoryPercent
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
   
    
    double total=(vmStats.free_count+vmStats.inactive_count+vmStats.active_count+vmStats.wire_count)*vm_page_size;
    
    double notavalible=total-vmStats.free_count*vm_page_size ;
    
   
    
    return notavalible/total ;
}

- (BOOL)is64bit
{
#if defined(__LP64__) && __LP64__
    return YES;
#else
    return NO;
#endif
}

- (BOOL)is32bit
{
#if defined(__LP64__) && __LP64__
    return NO;
#else
    return YES;
#endif
}

@end
