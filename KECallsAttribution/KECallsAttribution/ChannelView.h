//
//  ChannelView.h
//  News
//
//  Created by 赵 进喜 on 14-3-19.
//  Copyright (c) 2014年 everzones. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZPhotoObject.h"
typedef void(^ChannelBlock)(EZPhotoObject *,BOOL);


@interface ChannelView : UIImageView
{

    BOOL hasSelected;


}
@property(assign,nonatomic)BOOL isSelected;
@property(strong,nonatomic)UIImageView *selectedView;
@property(strong,nonatomic)EZPhotoObject *photo;
@property(copy,nonatomic)ChannelBlock touchBlock;
@end
