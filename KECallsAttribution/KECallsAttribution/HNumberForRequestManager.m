//
//  HNumberForRequestManager.m
//  KECallsAttribution
//
//  Created by EverZones on 15/12/28.
//  Copyright © 2015年 K.BLOCK. All rights reserved.
//

#import "HNumberForRequestManager.h"
#import <AFHTTPRequestOperationManager.h>

@interface HNumberForRequestManager () {
    
}
@property (nonatomic, strong)AFHTTPRequestOperationManager *manager;
@end
@implementation HNumberForRequestManager

+ (instancetype)shareInstance {
    static HNumberForRequestManager *requestManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        requestManager = [[HNumberForRequestManager alloc] init];
    });
    
     requestManager.manager  = [AFHTTPRequestOperationManager manager];

    return requestManager;
}


- (void)queryNumberMarkedInfoForURL:(NSString *)urlString
         completionBlockWithSuccess:(completionBlockWithSuccess)successBlock
         completionBlockWithFailure:(completionBlockWithFailure)failureBlock {
    
      _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
     [_manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        NSString *dataString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *parames = @{@"content": dataString};
         _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [_manager POST:@"http://93app.com/laidianguishu/phone_number_checker.php" parameters:parames success:^(AFHTTPRequestOperation *operation, id responseObject) {
           
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            
            if (([dict[@"status"] integerValue] == 1)) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    successBlock(dict);
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failureBlock(nil);
                });
            }
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failureBlock(nil);
            });
            
        }];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failureBlock(error);
        });
        
    }];
    
    
}
- (void)queryPhoneNumberLocaleInfoForURL:(NSString *)urlString
              completionBlockWithSuccess:(completionBlockWithSuccess)successBlock
              completionBlockWithFailure:(completionBlockWithFailure)failureBlock {
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [_manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock(error);
    }];
}
@end
