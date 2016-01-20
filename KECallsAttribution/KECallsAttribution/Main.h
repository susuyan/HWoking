//
//  Main.h
//  GameGuide
//
//  Created by lichenWang on 13-12-9.
//  Copyright (c) 2013年 EverZones. All rights reserved.
//
#import"AppUtil.h"


#import"MobClick.h"


#ifndef GameGuide_Main_h
#define GameGuide_Main_h


#define DEVICE [[UIDevice currentDevice].systemVersion integerValue] < 7.0
#define VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define BUNDLEID [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define EVERTIME_READ_DATA_COUNTS 30000;
#define IS_IOS7 (BOOL)([[[UIDevice currentDevice] systemVersion]floatValue]>=7.0 ? YES : NO)
#define IS_IOS8 (BOOL)([[[UIDevice currentDevice] systemVersion]floatValue]>=8.0 ? YES : NO)



#ifndef kSystemVersion
#define kSystemVersion [UIDevice systemVersion]
#endif

#ifndef kiOS6Later
#define kiOS6Later (kSystemVersion >= 6)
#endif

#ifndef kiOS7Later
#define kiOS7Later (kSystemVersion >= 7)
#endif

#ifndef kiOS8Later
#define kiOS8Later (kSystemVersion >= 8)
#endif

#ifndef kiOS9Later
#define kiOS9Later (kSystemVersion >= 9)
#endif


#define APPSLOTID @"60836"//app列表
#define TAOBAOSLOTID @"60924"//淘宝

//爱帮
#define AiBangAppKey @"6fc35bf51ea16a90b0091f0023d8398b"
//大众点评
#define DaZhongAppKey @"82230749"
#define DaZhongAppSceret @"243c23adc98c452fac314ed6bb72899a"

//大众点评
#define CC_SHA1_DIGEST_LENGTH   20          /* digest length in bytes */
#define CC_SHA1_BLOCK_BYTES     64          /* block size in bytes */
#define CC_SHA1_BLOCK_LONG      (CC_SHA1_BLOCK_BYTES / sizeof(CC_LONG))


/*
    需要修改
 */
#define APPLE_ID @"993531325"
//#define APP_ID 47443
#define APP_KEY @"69b855a20c002366129afe5af1e148b5"
#define UMENG_APP_ID @"52de2da556240bce620144cc"
#define UMENG_APP_SHARE_ID @"52da412756240b498805ec08"
//#define ADMOB_APP_ID @"a1535498aeac4e4"
//#define ADMOB_SCREEN_APP_ID @"a15354c6550ac35"
#define kProductIdInAppPurchase @"guishudiremoveads"//内购

#define ADMOB_APP_ID [AppUtil productWasPurchased]? @"test":@"ca-app-pub-2167649791927577/4685051641"
#define ADMOB_SCREEN_APP_ID [AppUtil productWasPurchased]? @"test":@"ca-app-pub-2167649791927577/6161784847"


//广点通
#define GDT_APP_ID [AppUtil productWasPurchased]? @"test":@"1103693962"
#define GDT_BANNER_APP_ID [AppUtil productWasPurchased]? @"test":@"6040803078445255"
#define GDT_SCREEN_APP_ID [AppUtil productWasPurchased]? @"test":@"2090007068143206"

#define UID [[NSUserDefaults standardUserDefaults]valueForKey:@"uid"]

#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"\n%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif


#endif
