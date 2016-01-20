//
//  Singel.m
//  Contact
//
//  Created by dyw on 14-9-1.
//  Copyright (c) 2014年 zmj. All rights reserved.
//

#import "Singel.h"

@implementation Singel
static Singel *singelData = nil;
+(id)sharedData{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singelData = [[Singel alloc] init];
        
    
    });
        return singelData;
}

-(NSString *)getHeadImageName
{



    NSString *name=[NSString stringWithFormat:@"add_head_%d",headImage_index];

    headImage_index++;
    
    
    if (headImage_index>4) {
        
        headImage_index=0;
        
    }

    return name;
}



@end
