//
//  KEPostcode.m
//  testCode
//
//  Created by lichenWang on 14-1-7.
//  Copyright (c) 2014年 KERNEL. All rights reserved.
//

#import "KEPostcode.h"

@implementation KEPostcode
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.cityName forKey:@"cityName"];
    [aCoder encodeObject:self.provinceName forKey:@"provinceName"];
    [aCoder encodeObject:self.areaName forKey:@"areaName"];
    [aCoder encodeObject:self.code forKey:@"code"];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.cityName = [aDecoder decodeObjectForKey:@"cityName"];
        self.provinceName = [aDecoder decodeObjectForKey:@"provinceName"];
        self.areaName = [aDecoder decodeObjectForKey:@"areaName"];
        self.code = [aDecoder decodeObjectForKey:@"code"];
    }
    return self;
}

@end
