//
//  MD5.m
//  requestForAiLi
//
//  Created by zl-mac1 on 13-8-5.
//  Copyright (c) 2013年 Ibokan. All rights reserved.
//

#import "MD5.h"
#import <CommonCrypto/CommonDigest.h>
@implementation MD5
+(NSString *)md5HexDigest:(NSString *)inputString
{
    const char *original_str = [inputString UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}
@end
