//
//  AppTextFileResponse.m
//  TextTransfer
//
//  Created by Matt Gallagher on 2009/07/13.
//  Copyright 2009 Matt Gallagher. All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import "AppTextFileResponse.h"
#import "HTTPServer.h"
#import "Singel.h"
#import "MF_Base64Additions.h"
@implementation AppTextFileResponse

//
// load
//
// Implementing the load method and invoking
// [HTTPResponseHandler registerHandler:self] causes HTTPResponseHandler
// to register this class in the list of registered HTTP response handlers.
//
+ (void)load
{
	[HTTPResponseHandler registerHandler:self];
}

//
// canHandleRequest:method:url:headerFields:
//
// Class method to determine if the response handler class can handle
// a given request.
//
// Parameters:
//    aRequest - the request
//    requestMethod - the request method
//    requestURL - the request URL
//    requestHeaderFields - the request headers
//
// returns YES (if the handler can handle the request), NO (otherwise)
//
+ (BOOL)canHandleRequest:(CFHTTPMessageRef)aRequest
	method:(NSString *)requestMethod
	url:(NSURL *)requestURL
	headerFields:(NSDictionary *)requestHeaderFields {
//	if ([[requestURL host]isEqualToString:@"tel"])
//	{
//		return NO;
//	}
	
	
    return YES;
}

//
// startResponse
//
// Since this is a simple response, we handle it synchronously by sending
// everything at once.
//
- (void)startResponse
{
    
    NSData *fileData;
    
    if ([[url absoluteString] isEqualToString:@"http://127.0.0.1:8080/redirect.html"]) {
        
        
        fileData =
		[NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/redirect.html",[AppTextFileResponse pathForFile]]];
        
    }else if([[url absoluteString] isEqualToString:@"http://127.0.0.1:8080/index.html"]){
    
    
        NSData *tempdata =
		[NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/index.html",[AppTextFileResponse pathForFile]]];
        
        NSString *str=[[NSString alloc]initWithData:tempdata encoding:NSUTF8StringEncoding];
        //    NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
        //    NSString *path = [file stringByAppendingPathComponent:@"/images"];
        //
        //    //    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
        //    //    [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
        //    NSString *imagePath = [NSString stringWithFormat:@"/%@/thumb.png",path];
        //    UIImage *icon = [UIImage imageWithContentsOfFile:imagePath];
        //  UIImage *icon = [UIImage imageNamed:@"108"];
        Singel *singe = [Singel sharedData];
        // NSData *iconData=UIImagePNGRepresentation(singe.image);
        
        NSData *iconData=UIImageJPEGRepresentation(singe.image, 0.5);
        
        //    NSString *html=[NSString stringWithFormat:str,@"电话",[iconData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength],@"quickdial://tel://15201681528",time];
        
        //    NSString *html=[NSString stringWithFormat:str,@"小军",[iconData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength],@"quickdial://tel://15201681528",@"快捷联系人",@"快捷联系人",[iconData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength],@"小军"];
        
        NSString *html=[ str stringByReplacingOccurrencesOfString:@"%%ContactName%%" withString:[[NSUserDefaults standardUserDefaults] objectForKey:@"name"]];
        
        if (IS_IOS7) {
            
            html = [html stringByReplacingOccurrencesOfString:@"%%ContactPhoto%%" withString:[iconData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];

            
        }else {
        
            html = [html stringByReplacingOccurrencesOfString:@"%%ContactPhoto%%" withString:[iconData base64String]];
        
        
        }
        
        
        html=[html stringByReplacingOccurrencesOfString:@"%%ContactPhone%%" withString:[NSString stringWithFormat:@"tel:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"phone"]]];
        //@"tel://15201681528"
        
        html=[html stringByReplacingOccurrencesOfString:@"%%AppName%%" withString:@"快捷联系人"];
        
        
        NSData *data = [[NSData alloc] initWithBytes:[html cStringUsingEncoding:NSUTF8StringEncoding]
                                              length:strlen([html cStringUsingEncoding:NSUTF8StringEncoding])];
        
        NSString *indexHTMLString;
        
        if (IS_IOS7) {
            
            indexHTMLString = [NSString stringWithFormat:@"<head><meta http-equiv=\"refresh\" content=\"0; URL=data:text/html;charset=UTF-8;base64,%@\"></head>", [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
            
        }else {
        
          indexHTMLString = [NSString stringWithFormat:@"<head><meta http-equiv=\"refresh\" content=\"0; URL=data:text/html;charset=UTF-8;base64,%@\"></head>", [data base64String]];
        
        }
        
            fileData=[indexHTMLString dataUsingEncoding:NSUTF8StringEncoding];
    
    }else{
    
    
    
        NSLog(@"%@",url);
    
    
    
    }
    
        
	CFHTTPMessageRef response =
		CFHTTPMessageCreateResponse(
			kCFAllocatorDefault, 200, NULL, kCFHTTPVersion1_1);
	CFHTTPMessageSetHeaderFieldValue(
		response, (CFStringRef)@"Content-Type", (CFStringRef)@"text/html");
	CFHTTPMessageSetHeaderFieldValue(
		response, (CFStringRef)@"Connection", (CFStringRef)@"close");
	CFHTTPMessageSetHeaderFieldValue(
		response,
		(CFStringRef)@"Content-Length",
		(__bridge CFStringRef)[NSString stringWithFormat:@"%ld", (unsigned long)[fileData length]]);
	CFDataRef headerData = CFHTTPMessageCopySerializedMessage(response);

    
    
    @try
    {
        [fileHandle writeData:(__bridge NSData *)headerData];
        [fileHandle writeData:fileData];
    }
    @catch (NSException *exception)
    {
        // Ignore the exception, it normally just means the client
        // closed the connection from the other end.
        
        CFRelease(headerData);
        [server closeHandler:self];
        
        
    }
    @finally
    {
        CFRelease(headerData);
        [server closeHandler:self];
    }

    
    
    
	}

//
// pathForFile
//
// In this sample application, the only file returned by the server lives
// at a fixed location, whose path is returned by this method.
//
// returns the path of the text file.
//
+ (NSString *)pathForFile
{
//	NSString *path =
//		[NSSearchPathForDirectoriesInDomains(
//				NSApplicationSupportDirectory,
//				NSUserDomainMask,
//				YES)
//			objectAtIndex:0];
//	BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:path];
//	if (!exists)
//	{
//		[[NSFileManager defaultManager]
//			createDirectoryAtPath:path
//			withIntermediateDirectories:YES
//			attributes:nil
//			error:nil];
//	}
//	return [path stringByAppendingPathComponent:@"file.txt"];
    
    NSString *path=[[NSBundle mainBundle]resourcePath];
    
    return path;
    
}
@end
