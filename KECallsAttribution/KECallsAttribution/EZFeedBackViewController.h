//
//  EZFeedBackViewController.h
//  KECallsAttribution
//
//  Created by 赵 进喜 on 15/3/12.
//  Copyright (c) 2015年 K.BLOCK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSMessagesViewController.h"
#import "UMFeedback.h"

@interface EZFeedBackViewController : JSMessagesViewController<UMFeedbackDataDelegate>
@property (strong, nonatomic) UMFeedback *feedback;
@end
