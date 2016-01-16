//
//  MyNetConnection.m
//  HoroscopeHD
//
//  Created by jinxi on 10-6-7.
//  Copyright 2010 melonzone. All rights reserved.
//

#import "MyNetConnection.h"
//#import "AppUtil.h"

@implementation MyNetConnection

@synthesize htmlData, responseType;

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate responseType:(ResponseType)_responseType {
	if (self = [super initWithRequest:request delegate:delegate]) {
        _identifier = [self stringWithNewUUID];
		htmlData = [[NSMutableData alloc] init];
		self.responseType = _responseType;
	}
	return self;
}

- (void)appendData:(NSData *)data{
	[htmlData appendData:data];
}

- (NSString *)identifier
{
    return _identifier;
}

- (NSString *)description
{
    NSString *description = [super description];
    
    return [description stringByAppendingFormat:@" (requestType = %d, identifier = %@)", responseType, _identifier];
}
 -(NSString*)stringWithNewUUID {
    // Create a new UUID
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    
    // Get the string representation of the UUID
    NSString *newUUID = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    return newUUID;
}

- (void)dealloc{
   	
    
    _identifier=nil;
}

@end
