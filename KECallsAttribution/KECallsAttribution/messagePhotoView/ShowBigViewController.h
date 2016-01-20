//
//  ShowBigViewController.h
//  testKeywordDemo
//
//  Created by mei on 14-8-18.
//  Copyright (c) 2014年 Bluewave. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <UIKit/UIKit.h>
#import "ZYQAssetPickerController.h"
#import "MessagePhotoView.h"
@interface ShowBigViewController : UIViewController<UIScrollViewDelegate,UINavigationControllerDelegate>
{
    UINavigationBar *mynavigationBar;
     UIImageView    *_imagvtitle;
   
    UIButton        *rightbtn;
    UIScrollView    *_scrollerview;
    UIButton        *_btnOK;
   
    
}



@property(nonatomic,strong) NSMutableArray *arrayOK;     //选中的图片数组


@end
