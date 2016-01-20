//
//  HSQLHelper.m
//  Harassment
//
//  Created by EverZones on 15/11/11.
//  Copyright (c) 2015年 EverZones. All rights reserved.
//

#import "HSQLHelper.h"
#import "HStringHelper.h"
static HSQLHelper *sqlHelper;

@interface HSQLHelper () {
    sqlite3 *_database;
}

@end

@implementation HSQLHelper

+ (instancetype)sharedManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sqlHelper = [[HSQLHelper alloc] init];
    });
    [sqlHelper openSQL];
    
    return sqlHelper;
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

#pragma mark - private method
- (void)openSQL {

    if (sqlite3_open([[HStringHelper getDataBasePath] UTF8String], &_database) != SQLITE_OK) {
        sqlite3_close(_database);
        NSAssert(0, @"Failed to open database");
    }

}

- (void)closeSQL {
    sqlite3_close(_database);
}

#pragma mark - public method
- (NSString *)selectAreaWithAreaCode:(NSString *)areaCode {

    NSString *selectArea = [NSString stringWithFormat:@"SELECT MobileArea FROM Dm_Mobile where AreaCode='%@'", areaCode];
    NSString *areaString;
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_database, [selectArea UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            const unsigned char *areaName = sqlite3_column_text(stmt, 0);
            areaString = [NSString stringWithUTF8String:(const char*)areaName];
            break;
        }
        sqlite3_finalize(stmt);
    }
    [self closeSQL];
    return areaString;
}

- (NSString *)selectAreaWithPhoneNumber:(NSString *)phoneNumber {
    NSString *SelectArea = [NSString stringWithFormat:@"SELECT MobileArea FROM Dm_Mobile where MobileNumber='%@'", phoneNumber];
    NSString *areaString;
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_database, [SelectArea UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            const unsigned char *areaName = sqlite3_column_text(stmt, 0);
            areaString = [NSString stringWithUTF8String:(const char*)areaName];
            break;
        }
        sqlite3_finalize(stmt);
    }
    [self closeSQL];
    return areaString;
}

- (NSString *)selectTypeWithPhoneNumber:(NSString *)phoneNumber {
    NSString *SelectArea = [NSString stringWithFormat:@"SELECT MobileType FROM Dm_Mobile where MobileNumber='%@'", phoneNumber];
    NSString *areaString;
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(_database, [SelectArea UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            const unsigned char *areaName = sqlite3_column_text(stmt, 0);
            areaString = [NSString stringWithUTF8String:(const char*)areaName];
            break;
        }
        sqlite3_finalize(stmt);
    }
    [self closeSQL];
    return areaString;
}

- (NSString*)checkCarriers:(NSString*)string{
    NSString * carriers = nil;
    if ([[string substringToIndex:3] isEqualToString:@"130"] || [[string substringToIndex:3] isEqualToString:@"131"]) {
        carriers = @"MOBILE130131";
    }else if ([[string substringToIndex:3] isEqualToString:@"132"] || [[string substringToIndex:3] isEqualToString:@"133"]) {
        carriers = @"MOBILE132133";
    }else if ([[string substringToIndex:3] isEqualToString:@"134"] || [[string substringToIndex:3] isEqualToString:@"135"]) {
        carriers = @"MOBILE134135";
    }else if ([[string substringToIndex:3] isEqualToString:@"136"] || [[string substringToIndex:3] isEqualToString:@"137"]) {
        carriers = @"MOBILE136137";
    }else if ([[string substringToIndex:3] isEqualToString:@"138"] || [[string substringToIndex:3] isEqualToString:@"139"]) {
        carriers = @"MOBILE138139";
    }else if ([[string substringToIndex:3] isEqualToString:@"145"] || [[string substringToIndex:3] isEqualToString:@"147"]) {
        carriers = @"MOBILE145147";
    }else if ([[string substringToIndex:3] isEqualToString:@"150"] || [[string substringToIndex:3] isEqualToString:@"151"]) {
        carriers = @"MOBILE150151";
    }else if ([[string substringToIndex:3] isEqualToString:@"152"] || [[string substringToIndex:3] isEqualToString:@"153"]) {
        carriers = @"MOBILE152153";
    }else if ([[string substringToIndex:3] isEqualToString:@"155"] || [[string substringToIndex:3] isEqualToString:@"156"]) {
        carriers = @"MOBILE155156";
    }else if ([[string substringToIndex:3] isEqualToString:@"157"] || [[string substringToIndex:3] isEqualToString:@"158"]) {
        carriers = @"MOBILE157158";
    }else if ([[string substringToIndex:3] isEqualToString:@"159"] || [[string substringToIndex:3] isEqualToString:@"180"]) {
        carriers = @"MOBILE159180";
    }else if ([[string substringToIndex:3] isEqualToString:@"181"] || [[string substringToIndex:3] isEqualToString:@"182"]) {
        carriers = @"MOBILE181182";
    }else if ([[string substringToIndex:3] isEqualToString:@"183"] || [[string substringToIndex:3] isEqualToString:@"184"]) {
        carriers = @"MOBILE183184";
    }else if ([[string substringToIndex:3] isEqualToString:@"185"] || [[string substringToIndex:3] isEqualToString:@"186"]) {
        carriers = @"MOBILE185186";
    }else if ([[string substringToIndex:3] isEqualToString:@"187"] || [[string substringToIndex:3] isEqualToString:@"188"]|| [[string substringToIndex:3] isEqualToString:@"189"]) {
        carriers = @"MOBILE187188189";
    }
    return carriers;
}


@end
