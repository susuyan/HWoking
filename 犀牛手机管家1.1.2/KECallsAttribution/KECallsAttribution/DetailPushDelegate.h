//
//  DetailPushDelegate.h
//  wallpapers
//
//  Created by 赵 进喜 on 13-9-24.
//  Copyright (c) 2013年 everzones. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DetailPushDelegate <NSObject>
-(void)pushToImageview:(UIViewController*)viewcontroller;

-(void)pushImageview:(UIViewController*)viewcontroller;
@end
