//
//  MyNetEngine.h
//  HoroscopeHD
//
//  Created by jinxi on 10-6-5.
//  Copyright 2010 melonzone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyNetEngineDelegate.h"


@interface MyNetEngine : NSObject {
	NSMutableDictionary *_connections;
    
    @public
    __unsafe_unretained	id<MyNetEngineDelegate> delegate;
    float totalLength;
    
    @public
    Class originalClass;
    
}
- (id)initWithDelegate:(id)_delegate;







- (void)closeAllConnections;



@property (nonatomic, assign) id<MyNetEngineDelegate> delegate;
@property (nonatomic,copy) NSMutableDictionary *_connections;
@property(retain,nonatomic)NSArray *items;
-(float)getTotalLength;




- (void) searchBusinessWithCity:(NSString *)city
                         Query:(NSString *)query
                      Category:(NSString *)category
                           Type:(int)type
                           Lng:(double)lng
                           Lat:(double)lat
                          Page:(int)mPage;




- (void)getWallPaperItemsListatPage:(int)pageNo;


- (void)getAppInfo;


@end
