//
//  EZPhotoObject.h
//  TestImageCompare
//
//  Created by 赵 进喜 on 15/5/25.
//  Copyright (c) 2015年 everzones. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EZPhotoObject.h"
#import <AssetsLibrary/ALAsset.h>
#import <Photos/Photos.h>

@interface EZPhotoObject : NSObject
@property(strong,nonatomic)UIImage * thumbImage;
@property(strong,nonatomic)UIImage * bigImage;
//@property(strong,nonatomic)ALAsset *asset;
@property(strong,nonatomic)PHAsset *asset;
@property(copy,nonatomic)NSString *url;
@property(copy,nonatomic)NSString *identify;

@property(copy,nonatomic)NSString *catid;
@end
