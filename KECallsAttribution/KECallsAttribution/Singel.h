//
//  Singel.h
//  Contact
//
//  Created by dyw on 14-9-1.
//  Copyright (c) 2014年 zmj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Singel : NSObject
{

    int headImage_index;
}
@property(nonatomic,strong)UIImage *image;

+(id)sharedData;
-(NSString *)getHeadImageName;
@end
