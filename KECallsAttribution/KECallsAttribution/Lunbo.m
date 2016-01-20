//
//  Lunbo.m
//  汽车日报new
//
//  Created by 董健 on 15/3/11.
//  Copyright (c) 2015年 董健. All rights reserved.
//

#import "Lunbo.h"

@implementation Lunbo

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
        self.imagearr = [NSMutableArray array];
        self.pageNumber = 0;
        self.pagefloat = 0;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 6.0;

        [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(time) userInfo:nil repeats:YES];
        
        
    }
    return self;
}

- (void)time
{
    if (self.backview.contentOffset.x != self.frame.size.width * (self.imagearr.count - 1)) {
        [UIView animateWithDuration:1 animations:^{
            self.backview.contentOffset = CGPointMake(self.backview.contentOffset.x + self.frame.size.width, 0);
            self.pageNumber++;
            self.pagecontrol.currentPage = self.pageNumber;
        }];
    }else {
        self.pageNumber = 0;
        self.pagecontrol.currentPage = self.pageNumber;
        self.backview.contentOffset = CGPointMake(self.frame.size.width, 0);
    }
}




- (void)imageWithFormArr:(NSMutableArray *)arr
{

    self.backview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.backview.pagingEnabled = YES;
    self.backview.delegate = self;
    self.backview.showsHorizontalScrollIndicator = NO;
    self.backview.contentSize = CGSizeMake(self.frame.size.width * (self.imagearr.count + 2), self.frame.size.height);
    self.backview.contentOffset = CGPointMake(self.frame.size.width, 0);
    
    
    
    self.pagecontrol = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 15, self.frame.size.width, 10)];
    self.pagecontrol.currentPageIndicatorTintColor = [UIColor blackColor];
    self.pagecontrol.numberOfPages = arr.count;
    self.pagecontrol.pageIndicatorTintColor = [UIColor grayColor];

    NSObject *first = [self.imagearr firstObject];
    NSObject *last = [self.imagearr lastObject];
    
    if (last) {
        [arr insertObject:last atIndex:0];
    }
    if (first) {
        [arr insertObject:first atIndex:arr.count];
    }

    
    
    
    for (int i = 0 ; i < arr.count; i++) {
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height)];
       // image.backgroundColor = [UIColor orangeColor];
        image.userInteractionEnabled = YES;
        image.image = [UIImage imageNamed:[arr objectAtIndex:i]];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(self.frame.size.width * i, 0, self.frame.size.width - 10, self.frame.size.height);
        button.tag = 1000 + i;
//        [button setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
       // button.backgroundColor = [UIColor greenColor];
        [self.backview addSubview:image];
        [self.backview addSubview:button];
    }
    [self addSubview:self.backview];
    [self addSubview:self.pagecontrol];
}

- (void)button:(UIButton *)button
{
    NSLog(@"%ld", (long)button.tag);
    [self.delegate pushNext:button.tag];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    NSLog(@"%f", self.pagefloat);
    NSLog(@"%f", scrollView.contentOffset.x);
    
    if (self.pagefloat < scrollView.contentOffset.x) {
        self.pageNumber++;
    }else{
        self.pageNumber--;
    }
    NSLog(@"%d", self.pageNumber);
    
    
    if (scrollView.contentOffset.x <= 100) {
        self.backview.contentOffset = CGPointMake(self.frame.size.width * (self.imagearr.count - 2), 0);
        self.pageNumber = 3;
    }else if(scrollView.contentOffset.x >= self.frame.size.width * (self.imagearr.count - 1) - 100){
        self.backview.contentOffset = CGPointMake(self.frame.size.width, 0);
        self.pageNumber = 0;

    }
   
    NSLog(@"se%d", self.pageNumber);
    self.pagecontrol.currentPage = self.pageNumber;
    
    
    self.pagefloat = scrollView.contentOffset.x;
}

- (void)setImagearr:(NSMutableArray *)imagearr
{
    if (_imagearr != imagearr) {
        _imagearr = imagearr;
    }

    if (imagearr) {
        [self imageWithFormArr:imagearr];
    }

}


@end
