//
//  EZAppHelper.h
//  TestImageCompare
//
//  Created by 赵 进喜 on 15/5/28.
//  Copyright (c) 2015年 everzones. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EZPhotoObject.h"

#define SelectedArray  [[EZAppHelper shareAppHelper] mutableArrayValueForKey:@"selectedArray"]

@interface EZAppHelper : NSObject
+(instancetype)shareAppHelper;
@property(strong,nonatomic)NSMutableArray *selectedArray;
@property(strong,nonatomic)NSMutableArray *allSimilarPhotos;

@end
