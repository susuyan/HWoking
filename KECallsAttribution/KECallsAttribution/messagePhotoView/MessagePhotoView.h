//
//  ZBShareMenuView.h
//  MessageDisplay
//
//  Created by zhoubin@moshi on 14-5-13.
//  Copyright (c) 2014年 Crius_ZB. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <UIKit/UIKit.h>
#import "MessagePhotoMenuItem.h"
#import "ZYQAssetPickerController.h"
#import "ShowBigViewController.h"

#define kZBMessageShareMenuPageControlHeight 30


@protocol MessagePhotoViewDelegate <NSObject>


@optional
- (void)didSelectePhotoMenuItem:(MessagePhotoMenuItem *)shareMenuItem atIndex:(NSInteger)index;

-(void)addPicker:(ZYQAssetPickerController *)picker;          //UIImagePickerController
-(void)addUIImagePicker:(UIImagePickerController *)picker;

@end

@interface MessagePhotoView : UIView<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,MessagePhotoItemDelegate,ZYQAssetPickerControllerDelegate>{
    //下拉菜单
    UIActionSheet *myActionSheet;
    
    //图片2进制路径
    NSString* filePath;
}
@property(nonatomic,strong) UIScrollView *scrollview;

/**
 *  第三方功能Models
 */
@property (nonatomic, strong) NSMutableArray *photoMenuItems;

@property(nonatomic,strong) NSMutableArray *itemArray;

@property (nonatomic, assign) id <MessagePhotoViewDelegate> delegate;

-(void)reloadDataWithImage:(UIImage *)image;

- (void)reloadData;

@end
