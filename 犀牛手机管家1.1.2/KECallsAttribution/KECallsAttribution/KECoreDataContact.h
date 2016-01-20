//
//  KECoreDataContact.h
//  KECallsAttribution
//
//  Created by lichenWang on 14-2-13.
//  Copyright (c) 2014年 KERNEL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface KECoreDataContact : NSManagedObject<NSCopying>

@property (nonatomic, retain) NSString * contactAreaName;
@property (nonatomic, retain) NSString * contactName;
@property (nonatomic, retain) NSString * contactPhoneNumber;
@property (nonatomic, retain) NSString * contactType;
@property (nonatomic, retain) NSData * imageData;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * showCallerID;
@property (nonatomic, retain) NSString * carrierName;
@property (nonatomic, retain) NSNumber * recordID;


- (id)copyWithZone:(NSZone *)zone;
@end
