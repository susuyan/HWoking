//
//  EZSquareImage.h
//  MyContacts
//
//  Created by 赵 进喜 on 15/1/21.
//  Copyright (c) 2015年 everzones. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^Block)();
@interface EZSquareImage : UIImageView
@property(copy,nonatomic)Block touchBlock;
@end
