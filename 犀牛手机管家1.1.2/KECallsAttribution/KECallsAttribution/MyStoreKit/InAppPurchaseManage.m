//
//  InAppPurchaseManage.m
//  DuanziHD
//
//  Created by melonzone on 11-10-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "InAppPurchaseManage.h"

@implementation InAppPurchaseManage
// InAppPurchaseManager.m
@synthesize delegate;

- (void)dealloc {
//    [mEngine closeAllConnections];
//    [mEngine release];
    [super release];
}


- (void)requestProUpgradeProductData
{
    NSSet *productIdentifiers = [NSSet setWithObject:kProductIdInAppPurchase];
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
    
    // we will release the request object in the delegate callback
}


//- (void)showProductInfo {
//}


#pragma mark -
#pragma mark SKProductsRequestDelegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSString *invalidProductId = nil;
    for (int i=0; i<[response.invalidProductIdentifiers count]; i++)
    {
        invalidProductId = [response.invalidProductIdentifiers objectAtIndex:i];
        NSLog(@"Invalid product id: %@" , invalidProductId);
    }
    
    if (invalidProductId) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取产品信息失败，请重新尝试！"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"好的"
                                              otherButtonTitles:nil];
        alert.tag = 102;
        [alert show];
        [alert release];
    } else {
        NSArray *products = response.products;
        proUpgradeProduct = [products count] == 1 ? [[products firstObject] retain] : nil;
        if (proUpgradeProduct)
        {
            if ([self canMakePurchases]) {
                [self purchaseProUpgrade];
            }
            //        [self showProductInfo];
            [proUpgradeProduct release];
        }
    }
    // finally release the reqest we alloc/init’ed in requestProUpgradeProductData
    [productsRequest release];
}


- (void)loadStore
{
    // restarts any purchases if they were interrupted last time the app was open
    if ([AppUtil productWasPurchased]) {
        //已购买
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"去除广告"
                                                        message:@"仅需少量的费用，就能享受到清爽的使用体验，您的支持是我们前进的动力！\n"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"恢复购买",@"继续", nil];
        //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"购买去广告"
        //                                                    message:[NSString stringWithFormat:@"Product title: %@\nProduct description: %@\nProduct price: %@\nProduct id: %@\n",proUpgradeProduct.localizedTitle, proUpgradeProduct.localizedDescription, proUpgradeProduct.price, proUpgradeProduct.productIdentifier]
        //                                                   delegate:self
        //                                          cancelButtonTitle:@"取消"
        //                                          otherButtonTitles:@"购买", nil];
        alert.tag = 101;
        [alert show];
        [alert release];
    }
}

//
// call this before making a purchase
//
- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}

//
// kick off the upgrade transaction
//
- (void)purchaseProUpgrade
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"purchaseProductInfoReceived" object:self userInfo:nil];
    
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:kProductIdInAppPurchase];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma -
#pragma Purchase helpers

//
// saves a record of the transaction by storing the receipt to disk
//
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
    if ([transaction.payment.productIdentifier isEqualToString:kProductIdInAppPurchase])
    {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"proUpgradeTransactionReceipt"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//
// enable pro features
//
- (void)provideContent:(NSString *)productId
{
    if ([productId isEqualToString:kProductIdInAppPurchase])
    {
        // enable the pro features
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isProUpgradePurchased" ];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//
// removes the transaction from the queue and posts a notification with the transaction result
//


//交易成功
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
    // remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
    if (wasSuccessful)
    {
        // send out a notification that we’ve finished the transaction
        if (delegate&&[delegate respondsToSelector:@selector(purchasedSuccessfully:)]) {
            [delegate purchasedSuccessfully:YES];
        }
        [SFHFKeychainUtils storeUsername:BUNDLEID andPassword:@"YES" forServiceName:kProductIdInAppPurchase updateExisting:YES error:nil];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"购买成功，谢谢您的支持！"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"好的"
                                              otherButtonTitles:nil];
        alert.tag = 104;
        [alert show];
        [alert release];
        //向服务器提交transactReceipt
        //        NSString *strReceipt = [[NSString alloc] initWithData:transaction.transactionReceipt encoding:NSUTF8StringEncoding];
        //        NSString *uuid = [[UIDevice currentDevice] uniqueIdentifier];
        //        [mEngine saveTransactionReceiptWithAppId:kAppBundleId productId:transaction.payment.productIdentifier transactionReceipt:strReceipt deviceId:uuid];
        //        [strReceipt release];
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
    }
    else
    {
        // send out a notification for the failed transaction
        NSLog(@"productIdentifier:%@", transaction.payment.productIdentifier);
        NSLog(@"transactionIdentifier:%@", transaction.transactionIdentifier);
        //    NSString *strReceipt = [[NSString alloc] initWithData:[GTMBase64 decodeData:transaction.transactionReceipt] encoding:NSUTF8StringEncoding];
        NSString *strReceipt = [[NSString alloc] initWithData:transaction.transactionReceipt encoding:NSUTF8StringEncoding];
        NSLog(@"transactionReceipt:%@", strReceipt);
        NSLog(@"transactionDate:%@", transaction.transactionDate);
        [strReceipt release];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"购买失败，请重新尝试！"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        alert.tag = 103;
        [alert show];
        [alert release];
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
    }
}

//
// called when the transaction was successful
//
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction];
    [self provideContent:transaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
    
    //打印transaction内容:
    //    NSLog(@"ffjwei");
    //    NSLog(@"productIdentifier:%@", transaction.payment.productIdentifier);
    //    NSLog(@"transactionIdentifier:%@", transaction.transactionIdentifier);
    //    //    NSString *strReceipt = [[NSString alloc] initWithData:[GTMBase64 decodeData:transaction.transactionReceipt] encoding:NSUTF8StringEncoding];
    //    NSLog(@"transactionReceipt:%@", strReceipt);
    //    NSLog(@"productIdentifier:%@", transaction.transactionDate);
}

//
// called when a transaction has been restored and and successfully completed
//
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction.originalTransaction];
    [self provideContent:transaction.originalTransaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

//
// called when a transaction has failed
//
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    NSError *error = transaction.error;
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // error!
        [self finishTransaction:transaction wasSuccessful:NO];
    }
    else
    {
        // this is fi                                  ne, the user just cancelled, so don’t notify
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver methods

//
// called when the transaction status is updated
//
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            default:
                break;
        }
    }
}


#pragma mark UIAlertView Delegate method
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 101) {
        if (buttonIndex == 2) {
            [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
            // get the product description (defined in early sections)
           // mEngine = [[MyNetEngine alloc] initWithDelegate:self];
            [self requestProUpgradeProductData];
        }else if(buttonIndex==1)
        {
            [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
//            [self requestProUpgradeProductData];
            [[SKPaymentQueue defaultQueue]restoreCompletedTransactions];
        
        }else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"purchaseProductInfoReceived" object:self userInfo:nil];
        }
    }
}


#pragma mark MyNetEngine delegate method
- (void)onSaveTransactionReceipt:(NSDictionary *)item {
    NSLog(@"保存成功！");
}

@end
