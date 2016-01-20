//
//  AppTextFileResponse.h
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
#import <Foundation/Foundation.h>
#import "HTTPResponseHandler.h"
@interface AppTextFileResponse : HTTPResponseHandler
{

}
+ (NSString *)pathForFile;
@property(nonatomic,strong)NSDictionary *dic;
@end
