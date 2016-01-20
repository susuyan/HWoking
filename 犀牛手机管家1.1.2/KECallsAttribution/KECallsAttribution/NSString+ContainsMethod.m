//
//  NSString+ContainsMethod.m
//  MyContacts
//
//  Created by 赵 进喜 on 15/1/23.
//  Copyright (c) 2015年 everzones. All rights reserved.
//

#import "NSString+ContainsMethod.h"

@implementation NSString (ContainsMethod)


#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_8_0
- (BOOL)containsString:(NSString *)aString {
    NSRange range = [self rangeOfString:aString];
    return range.length != 0;
}
#endif

@end
