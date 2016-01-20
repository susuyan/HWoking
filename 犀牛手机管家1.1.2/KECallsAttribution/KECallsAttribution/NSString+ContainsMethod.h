//
//  NSString+ContainsMethod.h
//  MyContacts
//
//  Created by 赵 进喜 on 15/1/23.
//  Copyright (c) 2015年 everzones. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ContainsMethod)

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_8_0
- (BOOL)containsString:(NSString *)aString;
#endif
@end
