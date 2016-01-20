//
//  ECPersonHelper.h
//  MyContacts
//
//  Created by 赵 进喜 on 15/1/5.
//  Copyright (c) 2015年 everzones. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import "ECContactObject.h"
#import <sqlite3.h>
#import "MBProgressHUD.h"
@interface ECPersonHelper : NSObject

@property(nonatomic)ABAddressBookRef addressBook;
@property(nonatomic,strong)NSMutableArray *allContracts;
@property(nonatomic,strong)NSMutableArray *allGroupContacts;
@property (nonatomic, copy)NSString *databaseFilePath;
@property (nonatomic, copy)NSString *telDatabaseFilePath;
@property (nonatomic)sqlite3 *database;
@property (nonatomic)sqlite3 *telRegionDatabase;
@property (nonatomic, copy)NSString *query;
@property(nonatomic,strong)MBProgressHUD *mProgress;


@property(nonatomic,strong)NSMutableArray *history_record;


+(ECPersonHelper *)sharePersonHelper;
-(void)initContactsDatabase;


-(void)inquiryNumber:(NSString *)number relultBlock:(void(^)(NSString *address))resultBlock;

-(void)addHistory_recordWithRecordID:(NSNumber *)recordID  name:(NSString *)name  phoneNumber:(NSString *)phoneNum mark:(NSString*)mark;
- (void)saveItemsToFile:(NSArray *)items cacheId:(NSString *)cacheId ;

-(UIImage *)getDefaultHeadImage;//默认头像
-(int)getDefaultHeadImageIdWithIndex:(NSInteger)index;
@end
