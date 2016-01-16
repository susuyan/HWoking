//
//  DetailViewController.m
//  ShareGif
//
//  Created by 赵 进喜 on 13-8-20.
//  Copyright (c) 2013年 everzones. All rights reserved.
//

#import "DetailViewController.h"

#import "MD5.h"

#import "UIImageView+WebCache.h"
#import "ImageViewController.h"
#import "MobClick.h"
@interface DetailViewController ()

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc
{
    _mScrollView =nil;
    _refreshView =nil;
       
   
       
    _item=nil;
   
    
    mEngine=nil;
    
    mItems=nil;

    
}
////隐藏状态栏的方法
//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
//    //UIStatusBarStyleLightContent = 1; //白色文字，深色背景时使用
//}

//- (BOOL)prefersStatusBarHidden
//{
//    return NO; //返回NO表示要显示，返回YES将hiden
//}
//
-(void)viewWillDisappear:(BOOL)animated
{

    [super viewWillDisappear:animated];
    
    
    
    [MobClick endLogPageView:@"wallpaper"];


}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden=NO;
    
    [MobClick beginLogPageView:@"wallpaper"];
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=@"壁纸";
    
    [self initNav];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    mItems=[[NSMutableArray alloc]initWithCapacity:12];
    mEngine=[[MyNetEngine alloc]initWithDelegate:self];
    page=1;
    [self initScrollView];
   
    
    if (mItems.count>0) {
        //NSLog(@"%@",mItems);
        [self refreshScrollViewWith:mItems];
    }
        [self loadData];
}


-(void)initScrollView{
    UIScrollView *scroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT-64)];
    _mScrollView=scroll;
    scroll.tag=1001;
    [self.view addSubview:_mScrollView];
    self.mScrollView.contentSize=CGSizeMake(320,625);
    _mScrollView.scrollEnabled=YES;
    _mScrollView.userInteractionEnabled=YES;
    _mScrollView.delegate=self;

    isLoading=NO;
    
    RefreshHeaderAndFooterView *refresh=[[RefreshHeaderAndFooterView alloc]initWithFrame:CGRectMake(0, 0, _mScrollView.contentSize.width, _mScrollView.contentSize.height)];
    
    _refreshView=refresh;
    _refreshView.delegate=self;
    [_mScrollView addSubview:_refreshView];
    
}


-(void)initNav
{
    
    
    UIButton *back=[UIButton buttonWithType:UIButtonTypeCustom];
    
    
    back.frame=CGRectMake(0, 0, 32, 32);
    
    
    [back setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backToLast) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]initWithCustomView:back];
    
    
    self.navigationItem.leftBarButtonItem=backItem;
    
    if (IS_IOS7) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    
    
}
-(void)backToLast
{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
}

//刷新scrollview
-(void)refreshScrollViewWith:(NSArray *)items
{
   

    for (int i=0;i<items.count;i++) {
      //  NSAssert([items isKindOfClass:[NSArray class]], @"不是一个数组啊");
        NSDictionary *item=[items objectAtIndex:i];
        
      int index=(int)[mItems indexOfObject:item];
        
        UIImageView *itemView=[[UIImageView alloc]init];
        itemView.userInteractionEnabled=YES;
                
        CGPoint position=[self getPositionWithIndex:index];
        
        itemView.frame=CGRectMake(position.x, position.y, 100, 150);
        [_mScrollView addSubview:itemView];
    
        //NSLog(@"%d  %d",i,index);
        
        itemView.tag=index;
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapItemView:)];
        [itemView addGestureRecognizer:tap];
        
       
        
        NSString *thumb=[[mItems objectAtIndex:index] objectForKey:@"thu_path"];
        
        //NSLog(@"%@",thumb);
        //NSString *groupId=[[mItems objectAtIndex:index]objectForKey:@"group_id"];
        [itemView setImageWithURL:[NSURL URLWithString:thumb] placeholderImage:[UIImage imageNamed:@"default_bg"]];
        
       
    }
}



-(void)tapItemView:(UITapGestureRecognizer *)tap
{
    int tag=tap.view.tag;
    ImageViewController *imageViewer=[[ImageViewController alloc]initWithItems:mItems AndImageIndex:tag];
    [self.navigationController pushViewController:imageViewer animated:YES];
//    if (_delegate&&[_delegate respondsToSelector:@selector(pushToImageview:)]) {
//        [_delegate pushToImageview:imageViewer];
//    }
}
-(CGPoint)getPositionWithIndex:(int)index
{
    
    
    
    int row=floor(index/3);

   // NSLog(@"%d",row);
    int x=5+(index%3)*(100+5);
    
    int y= 5+row*(150+5);

    CGPoint point=CGPointMake(x,y);
    
    
    return point;

}
-(void)loadData
{
    page=1;
	
	
	    
    [mEngine getWallPaperItemsListatPage:page];
    
    
    
}
-(void)onItemsReceived:(NSDictionary *)item
{

    [self doneLoadingViewData];
    
    if ([[item objectForKey:@"status"]intValue]==1) {
        if (page==1) {
            [mItems removeAllObjects];
            for (id view in _mScrollView.subviews ) {
                
                if ([view isKindOfClass:[UIImageView class]]) {
                    [view removeFromSuperview];
                }
            }
        }
        NSArray *items=[item objectForKey:@"msg"];
        if ([items isKindOfClass:[NSArray class]]) {
            
            NSMutableArray *thisArray=[items mutableCopy];
            
            for (id item in items) {
                if ([mItems containsObject:item]) {
                    [thisArray removeObject:item];
                }
            }
            
            [mItems addObjectsFromArray:thisArray];
        }

        
        int count;
                        
        if (mItems.count%3==0) {
          count=(int)(mItems.count/3);
               }else{
                   count=(int)(mItems.count/3)+1;
             }
        
              if (count<4) {
                   count=4;
              }
        
        int height=5+count*(150+5);

        _mScrollView.contentSize=CGSizeMake(320, height);
        _refreshView.frame=CGRectMake(0, 0, _mScrollView.contentSize.width, _mScrollView.contentSize.height);
        
        //	if (page == 1)
        //		[[CacheManager sharedManager] saveItemsToFile:mItems cacheId:mCacheId];
        
        if (items.count>0) {
            [self refreshScrollViewWith:items];

        }
    
    }

}



- (void)doneLoadingViewData{
	
	//  model should call this when its done loading
	isLoading = NO;
    [self.refreshView RefreshScrollViewDataSourceDidFinishedLoading:self.mScrollView];
	
}
#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
    [self.refreshView RefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.refreshView RefreshScrollViewDidEndDragging:scrollView];
	
}
#pragma mark -
#pragma mark RefreshHeaderAndFooterViewDelegate Methods

- (void)RefreshHeaderAndFooterDidTriggerRefresh:(RefreshHeaderAndFooterView*)view{
	isLoading = YES;
    if (view.refreshHeaderView.state == PullRefreshLoading) {//下拉刷新动作的内容
       // NSLog(@"header");
        [self loadData];
        //[self performSelector:@selector(doneLoadingViewData) withObject:nil afterDelay:3.0];
        
    }else if(view.refreshFooterView.state == PullRefreshLoading){//上拉加载更多动作的内容
        page ++;
      [mEngine getWallPaperItemsListatPage:page];
       // NSLog(@"footer");
        //[self performSelector:@selector(doneLoadingViewData) withObject:nil afterDelay:3.0];
    }
}

- (BOOL)RefreshHeaderAndFooterDataSourceIsLoading:(RefreshHeaderAndFooterView*)view{
	
	return isLoading; // should return if data source model is reloading
	
}
- (NSDate*)RefreshHeaderAndFooterDataSourceLastUpdated:(RefreshHeaderAndFooterView*)view{
    return [NSDate date];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
