//
//  ECWeChatActivity.h
//  KECallsAttribution
//
//  Created by 赵 进喜 on 14-10-22.
//  Copyright (c) 2014年 K.BLOCK. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef void (^ShareBlock) (void);
@interface ECWeChatActivity : UIActivity
{
    ShareBlock myBlock;
    
    UIImage *icon;
    
    NSString *mTitle;
    
    NSString *mType;
}
-(id)initWithTitle:(NSString *)title withImage:(UIImage *)image  withType:(NSString *)type  withBlock:(ShareBlock)block;
@end


