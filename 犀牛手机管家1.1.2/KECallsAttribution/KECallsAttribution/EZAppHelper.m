//
//  EZAppHelper.m
//  TestImageCompare
//
//  Created by 赵 进喜 on 15/5/28.
//  Copyright (c) 2015年 everzones. All rights reserved.
//

#import "EZAppHelper.h"

static EZAppHelper *appHelper;



@implementation EZAppHelper




-(instancetype)init
{


    if (self=[super init]) {
        
        _selectedArray=[NSMutableArray arrayWithCapacity:10];
        
        _allSimilarPhotos=[NSMutableArray arrayWithCapacity:10];
    }

    return self;
}

+(instancetype)shareAppHelper
{


    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        appHelper=[[EZAppHelper alloc]init];
        
    });

    return appHelper;

}






@end
