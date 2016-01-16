//
//  DetailViewController.h
//  ShareGif
//
//  Created by 赵 进喜 on 13-8-20.
//  Copyright (c) 2013年 everzones. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshHeaderAndFooterView.h"
#import "MyNetEngine.h"
#import "DetailPushDelegate.h"

@interface DetailViewController : UIViewController<UIScrollViewDelegate,RefreshHeaderAndFooterViewDelegate,MyNetEngineDelegate>
{
    
//    UILabel *numLbl;
//    UILabel *biaoqing;
    MyNetEngine *mEngine;
    int page;
    NSMutableArray *mItems;

  

    BOOL isLoading;
    
    NSString *mCacheId;
    
//    NSString *picId;
//    
//    NSData *gifData;
    
    

}
@property(retain,nonatomic)NSDictionary *item;
@property(retain,nonatomic)UIScrollView *mScrollView;
@property(retain,nonatomic)RefreshHeaderAndFooterView *refreshView;
@property(assign,nonatomic)id <DetailPushDelegate>delegate;
-(void)loadData;


@end
