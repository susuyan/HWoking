//
//  MyNetConnection.h
//  HoroscopeHD
//
//  Created by jinxi on 10-6-7.
//  Copyright 2010 melonzone. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _ResponseType {
	ResponseGetItems=1,
    
    ResponseGetAppInfo=2,
   
   
    
} ResponseType;

@interface MyNetConnection : NSURLConnection {
	NSMutableData *htmlData;
	ResponseType responseType;
	NSString *_identifier;
}

- (NSString *)identifier;
- (void)appendData:(NSData *)data;
- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate responseType:(ResponseType)_responseType;
	
@property (nonatomic,retain) NSMutableData *htmlData;
@property (nonatomic) ResponseType responseType;

@end
