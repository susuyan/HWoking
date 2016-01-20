//
//  ECWeChatActivity.m
//  KECallsAttribution
//
//  Created by 赵 进喜 on 14-10-22.
//  Copyright (c) 2014年 K.BLOCK. All rights reserved.
//

#import "ECWeChatActivity.h"

@implementation ECWeChatActivity
-(id)initWithTitle:(NSString *)title withImage:(UIImage *)image  withType:(NSString *)type  withBlock:(ShareBlock)block
{

    if (self =[super init]) {
        
        
        icon=image;
        
        
        mType=type;
        
        
        
        mTitle=title;
        
        
        myBlock=block;
        
        
        
        
    }


    return self;
}

-(NSString *)activityType
{

   

    return mType;

}
-(NSString *)activityTitle
{

    return mTitle;

}
-(UIImage *)activityImage
{

    return icon;

}
-(void)prepareWithActivityItems:(NSArray *)activityItems
{


}

-(UIViewController *)activityViewController
{
    return nil;

}
-(void)performActivity
{


    myBlock();

}
-(BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{

    return YES;


}
@end
