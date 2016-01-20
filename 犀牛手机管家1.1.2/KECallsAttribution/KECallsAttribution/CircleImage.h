//
//  CircleImage.h
//  Ringtone
//
//  Created by 赵 进喜 on 14-2-17.
//  Copyright (c) 2014年 everzones. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Block)();

@interface CircleImage : UIImageView

@property(copy,nonatomic)Block touchBlock;

@end
