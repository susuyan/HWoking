//
//  MyNetEngineDelegate.h
//  HoroscopeHD
//
//  Created by jinxi on 10-6-6.
//  Copyright 2010 melonzone. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MyNetEngineDelegate <NSObject>
@optional
- (void)onJsonItemsReceived:(NSDictionary *)item;









- (void)onItemsReceived:(NSDictionary *)item;


- (void)onAppInfoReceived:(NSDictionary *)item;




- (void)onRequestFailed:(NSError *)error;

@end
