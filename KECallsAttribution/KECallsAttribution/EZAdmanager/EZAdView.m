//
//  EZAdView.m
//  TestAd
//
//  Created by 赵 进喜 on 15/7/22.
//  Copyright (c) 2015年 everzones. All rights reserved.
//

#import "EZAdView.h"
#import <QuartzCore/QuartzCore.h>
#define  KSizeScale  [[UIScreen mainScreen]bounds].size.width/320

@implementation EZAdView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)drawRect:(CGRect)rect
{

    [super drawRect:rect];
    
    
    
    self.adImageView.layer.cornerRadius=6.0f;

    self.adImageView.layer.masksToBounds = YES;
    
    self.adImageView.layer.borderWidth = 2.0;
    self.adImageView.layer.borderColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]  CGColor];

}

-(void)layoutSubviews
{

    
    [self.kuangView setImage:[[UIImage imageNamed:@"adViewbg"]resizableImageWithCapInsets:UIEdgeInsetsMake(50, 50, 50, 50) resizingMode:UIImageResizingModeStretch]];
    
  
    self.adViewWidth.constant=240*KSizeScale;
    
    
    self.adViewheight.constant=350*KSizeScale;
    
    
       



}

- (IBAction)tapAdView:(UITapGestureRecognizer *)sender {
    
    
    
   
    
    _tapBlock();

    
    
}

-(void)showInView:(UIView *)mView
{
    
     [mView.window addSubview:self];
    
    
    int y=[[UIScreen mainScreen]bounds].size.width/2+self.adViewWidth.constant/2;
    
    self.contentView.transform=CGAffineTransformMakeTranslation(-y, 0);
    

    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^
    {
        
        
        
        
        self.contentView.transform=CGAffineTransformIdentity;
        
        
    } completion:^(BOOL finished) {
        
       
        
    }];
    
    

    


}
-(void)hideView
{
    
   int y=[[UIScreen mainScreen]bounds].size.width/2+self.adViewWidth.constant/2;

    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^
     {
         
         self.contentView.transform=CGAffineTransformMakeTranslation(y, 0);

         
     } completion:^(BOOL finished) {
         
         self.contentView.transform=CGAffineTransformIdentity;
         
        [self removeFromSuperview];
         
     }];



}

- (IBAction)closeButton:(UIButton *)sender {
    
    
    
    [self hideView];
    
    
}





@end
