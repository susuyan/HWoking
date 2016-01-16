//
//  HProgressHUD.h
//  Harassment
//
//  Created by 余胜民 on 15/12/11.
//  Copyright © 2015年 EverZones. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>
@interface HProgressHUD : NSObject

+ (void)showMBProgressHUD:(UIView *)view andString:(NSString *)string;

@end
