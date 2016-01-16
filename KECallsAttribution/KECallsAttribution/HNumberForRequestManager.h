//
//  HNumberForRequestManager.h
//  KECallsAttribution
//
//  Created by EverZones on 15/12/28.
//  Copyright © 2015年 K.BLOCK. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^completionBlockWithSuccess)(id responseObject);
typedef void(^completionBlockWithFailure)(NSError *error);

@interface HNumberForRequestManager : NSObject

+ (instancetype)shareInstance;

- (void)queryNumberMarkedInfoForURL:(NSString *)urlString
         completionBlockWithSuccess:(completionBlockWithSuccess)successBlock
         completionBlockWithFailure:(completionBlockWithFailure)failureBlock;

//在线查询归属地信息
- (void)queryPhoneNumberLocaleInfoForURL:(NSString *)urlString
              completionBlockWithSuccess:(completionBlockWithSuccess)successBlock
              completionBlockWithFailure:(completionBlockWithFailure)failureBlock;

@end
