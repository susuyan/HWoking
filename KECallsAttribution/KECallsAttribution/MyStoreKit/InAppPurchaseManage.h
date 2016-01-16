//
//  InAppPurchaseManage.h
//  DuanziHD
//
//  Created by melonzone on 11-10-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
//#import "AppConst.h"
//#import "NSArray+TKCategory.h"
//#import "AppVars.h"
#import "AppUtil.h"
//#import "GTMBase64.h"
//#import "MyNetEngine.h"
#import "SFHFKeychainUtils.h"
@class InAppPurchaseObserver;

#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"
#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"

@protocol InAppPurchaseManageDelegate <NSObject>
@optional
- (void)purchasedSuccessfully:(BOOL)wasSuccessful;

@end

@interface InAppPurchaseManage : NSObject <SKProductsRequestDelegate>{
    SKProduct *proUpgradeProduct;
    SKProductsRequest *productsRequest;
    id<InAppPurchaseManageDelegate> delegate;
    InAppPurchaseObserver *inAppObserver;
  //  MyNetEngine *mEngine;
}
@property (nonatomic, assign) id<InAppPurchaseManageDelegate> delegate;

- (void)loadStore;
- (BOOL)canMakePurchases;
- (void)purchaseProUpgrade;

- (void)requestProUpgradeProductData;
@end

