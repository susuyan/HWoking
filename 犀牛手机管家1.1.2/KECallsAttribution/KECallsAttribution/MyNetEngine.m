//
//  MyNetEngine.m
//  HoroscopeHD
//
//  Created by jinxi on 10-6-5.
//  Copyright 2010 melonzone. All rights reserved.
//

#import "Main.h"
#import "MyNetEngine.h"
#import "MyNetEngineParser.h"
#import "MyNetConnection.h"
#import <CommonCrypto/CommonDigest.h>
//#import "NSString+TKCategory.h"


//temp 
//#define kAppId @"retie"
//#define UID [[NSUserDefaults standardUserDefaults]valueForKey:@"uid"]
@implementation MyNetEngine

@synthesize delegate;
@synthesize _connections;
- (id)initWithDelegate:(id)_delegate {
	if (self=[super init]) {
		_connections = [[NSMutableDictionary alloc] initWithCapacity:0];
		self.delegate = _delegate;
	}
	return self;
}



//- (void)getAppInfo {
//    //    NSString *tDeviceName = [[UIDevice currentDevice].model URLEncode];
//    //    NSString *tLanguageCode = [[[NSLocale preferredLanguages] objectAtIndex:0] URLEncode];
//	NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@/duanzi_xilie/ping.php?id=%@&version=%@",kSiteRoot,kAppBundleId,kAppVersion]];
//    
//	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//	[request setValue:@"gzip,deflate" forHTTPHeaderField:@"Accept-Encoding"];
//	MyNetConnection *connection = [[MyNetConnection alloc] initWithRequest:request delegate:self responseType:ResponseGetAppInfo];
//	[_connections setObject:connection forKey:[connection identifier]];
//	connection  =nil;
//    //NSLog(@"aaaa");
//}






- (void) searchBusinessWithCity:(NSString *)city
                          Query:(NSString *)query
                       Category:(NSString *)category
                           Type:(int)type
                            Lng:(double)lng
                            Lat:(double)lat
                           Page:(int)mPage;

{

    
  
    
    
    NSString *urlTemplate =[NSMutableString stringWithFormat:@"http://api.dianping.com/v1/business/find_businesses?city=%@&appkey=%@&longitude=%lf&latitude=%lf&format=json&sort=1&page=%d&limit=20&platform=2&offset_type=1&out_offset_type=1&radius=5000",city,DaZhongAppKey,lng,lat,mPage];

    
    NSLog(@"%@",urlTemplate);
    
    
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    
    if (category) {
        [dic setObject:category forKey:@"category"];
    }
    
    if (query&&![query isEqualToString:@""]) {
        [dic setObject:query forKey:@"keyword"];
    }
    
    switch (type) {
        case 0:
            
            
            
            
            break;
        case 1:
            
            [dic setObject:@"1" forKey:@"has_deal"];
            
            
            
           
            break;
        case 2:
            [dic setObject:@"1" forKey:@"has_coupon"];
           
            
                       break;
        case 3:
            
            [dic setObject:@"1" forKey:@"has_online_reservation"];
           
            
                        break;
            
        default:
            break;
    }
    
    
    
    urlTemplate=[self parseUrlWithDic:dic AndUrl:[urlTemplate mutableCopy]];
    
    
//  NSString *urlTemplate=@"http://api.dianping.com/v1/business/find_businesses?appkey=82230749&sign=361A3A91CF533EE63446AD5A9FC2474F4067104E&category=%E7%BE%8E%E9%A3%9F&city=%E4%B8%8A%E6%B5%B7&latitude=31.18268013000488&longitude=121.42769622802734&sort=1&limit=20&offset_type=1&out_offset_type=1&platform=2";

    
    
   	
    
    
    //urlTemplate=[self URLEncodedString:urlTemplate];
    
    
    
    
    
    urlTemplate=[self serializeURL:urlTemplate params:nil];
    
	
	NSURL *url = [NSURL URLWithString:urlTemplate];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	[request setValue:@"gzip,deflate" forHTTPHeaderField:@"Accept-Encoding"];
    [request setTimeoutInterval:30];
	MyNetConnection *connection = [[MyNetConnection alloc] initWithRequest:request delegate:self responseType:ResponseGetItems];
	[_connections setObject:connection forKey:[connection identifier]];
	connection=nil;

    
   

}


#pragma mark 壁纸
//取得列表 壁纸
- (void)getWallPaperItemsListatPage:(int)pageNo {
    
    
    
  NSString *  urlTemplate = @"%@&tab=new&page=%d&version=%@&bundle_id=%@&device=ios";
    
    NSString *strUrl=[NSString stringWithFormat:urlTemplate,@"http://93app.com/hd_wallpaper/cat_pics_list.php?type=home&real=1",pageNo,VERSION,BUNDLEID];
    
    NSLog(@"getItemsListURL = %@",strUrl);
    NSURL *url = [NSURL URLWithString:strUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"gzip,deflate" forHTTPHeaderField:@"Accept-Encoding"];
    MyNetConnection *connection = [[MyNetConnection alloc] initWithRequest:request delegate:self responseType:ResponseGetItems];
    [_connections setObject:connection forKey:[connection identifier]];
    connection=nil;
}





#pragma mark netConnection delegate
- (void)connection:(MyNetConnection *)connection didReceiveData:(NSData *)data {
	
    
    
    [connection appendData:data];
    
    
}

- (void)connectionDidFinishLoading:(MyNetConnection *)connection {

	NSData *xmlData = connection.htmlData;
	
	//NSArray *items;
	NSDictionary *item;
	switch (connection.responseType) {
		case ResponseGetItems:
			item = [MyNetEngineParser parseJsonItems:xmlData];
			if (delegate&&[delegate respondsToSelector:@selector(onItemsReceived:)]) {
				[delegate onItemsReceived:item];
                
			}
            break;
        case ResponseGetAppInfo:
			item = [MyNetEngineParser parseJsonItems:xmlData];
			if (delegate&&[delegate respondsToSelector:@selector(onAppInfoReceived:)]) {
				[delegate onAppInfoReceived:item];
			}
			break;
     
		default:
			break;
	}
	[_connections removeObjectForKey:[connection identifier]];
}
- (void)connection:(MyNetConnection *)connection didFailWithError:(NSError *)error {
    
    [_connections removeObjectForKey:[connection identifier]];
	if (delegate&&[delegate respondsToSelector:@selector(onRequestFailed:)]) {
		[delegate onRequestFailed:error];
	}
	
    
    NSLog(@"%@",error);
    
   
}

- (void)connection:(MyNetConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    totalLength=[response expectedContentLength];
    NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
    NSInteger statusCode = [resp statusCode];    
    if (statusCode >= 400) {
        // Destroy the connection.
        [connection cancel];
		NSString *connectionIdentifier = [connection identifier];
		[_connections removeObjectForKey:connectionIdentifier];
	}
}
-(float)getTotalLength
{
    
    return totalLength;
    
    
}

- (void)dealloc {
    
    [self closeAllConnections];
	[[_connections allValues] makeObjectsPerformSelector:@selector(cancel)];
    _connections=nil;
	
}

#pragma mark Connection methods


- (NSUInteger)numberOfConnections
{
    return [_connections count];
}


- (NSArray *)connectionIdentifiers
{
    return [_connections allKeys];
}

- (void)closeAllConnections
{
    [[_connections allValues] makeObjectsPerformSelector:@selector(cancel)];
    [_connections removeAllObjects];
}
- (NSString *)URLEncodedString:(NSString *)str
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)str,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              NULL,
                                                              kCFStringEncodingUTF8));
    return encodedString;
}



- (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params
{
    NSURL* parsedURL = [NSURL URLWithString:[baseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:[self parseQueryString:[parsedURL query]]];
    if (params) {
        [paramsDic setValuesForKeysWithDictionary:params];
    }
    
    NSMutableString *signString = [NSMutableString stringWithString:DaZhongAppKey];
    NSMutableString *paramsString = [NSMutableString stringWithFormat:@"appkey=%@", DaZhongAppKey];
    NSArray *sortedKeys = [[paramsDic allKeys] sortedArrayUsingSelector: @selector(compare:)];
    for (NSString *key in sortedKeys) {
        if (![key isEqualToString:@"appkey"]) {
            [signString appendFormat:@"%@%@", key, [paramsDic objectForKey:key]];
            [paramsString appendFormat:@"&%@=%@", key, [paramsDic objectForKey:key]];
        }
        
      
    }
    [signString appendString:DaZhongAppSceret];
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    NSData *stringBytes = [signString dataUsingEncoding: NSUTF8StringEncoding];
    if (CC_SHA1([stringBytes bytes], [stringBytes length], digest)) {
        /* SHA-1 hash has been calculated and stored in 'digest'. */
        NSMutableString *digestString = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH];
        for (int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
            unsigned char aChar = digest[i];
            [digestString appendFormat:@"%02X", aChar];
        }
        [paramsString appendFormat:@"&sign=%@", [digestString uppercaseString]];
        return [NSString stringWithFormat:@"%@://%@%@?%@", [parsedURL scheme], [parsedURL host], [parsedURL path], [paramsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    } else {
        return nil;
    }
}

-(NSDictionary *)parseQueryString:(NSString *)query {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:6];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        
        if ([elements count] <= 1) {
            return nil;
        }
        
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}


-(NSString *)parseUrlWithDic:(NSDictionary *)dic AndUrl:(NSMutableString *)baseUrl
{



    NSArray *sortedKeys = [[dic allKeys] sortedArrayUsingSelector: @selector(compare:)];
    for (NSString *key in sortedKeys) {
      
        
            [baseUrl appendFormat:@"&%@=%@", key, [dic objectForKey:key]];
        
        
        
    }

    return baseUrl;


}
@end
