//
//  Lunbo.h
//  汽车日报new
//
//  Created by 董健 on 15/3/11.
//  Copyright (c) 2015年 董健. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LunboDeletage <NSObject>
- (void)pushNext:(NSInteger)num;
@end
@interface Lunbo : UIView<UIScrollViewDelegate>

@property (nonatomic, strong)NSMutableArray *imagearr;
@property (nonatomic, strong)UIScrollView *backview;

@property (nonatomic, assign)int pageNumber;                //轮播对应显示的页面；
@property (nonatomic, assign)float pagefloat;

@property (nonatomic, strong)UIPageControl *pagecontrol;//轮播图页数；
@property (nonatomic,assign)id<LunboDeletage>delegate;
@end
