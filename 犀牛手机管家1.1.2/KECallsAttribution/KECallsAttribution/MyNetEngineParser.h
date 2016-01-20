//
//  MyNetEngineParser.h
//  HoroscopeHD
//
//  Created by jinxi on 10-6-6.
//  Copyright 2010 melonzone. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MyNetEngineParser : NSObject {

}
+ (NSDictionary *)parseJsonItems:(NSData *)data;
@end
