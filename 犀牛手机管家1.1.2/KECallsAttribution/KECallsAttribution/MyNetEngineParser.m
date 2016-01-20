//
//  MyNetEngineParser.m
//  HoroscopeHD
//
//  Created by jinxi on 10-6-6.
//  Copyright 2010 melonzone. All rights reserved.
//

#import "MyNetEngineParser.h"
//#import "TouchXML.h"

#define NSMaxiumRange         ((NSRange){.location=              0UL, .length=    NSUIntegerMax})

@implementation MyNetEngineParser


+ (NSDictionary *)parseJsonItems:(NSData *)data {
	
    //NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
   
    //NSLog(@"%@",str);

	return dic;
}





@end
