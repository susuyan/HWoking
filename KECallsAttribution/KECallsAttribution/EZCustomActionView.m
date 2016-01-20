//
//  EZCustomActionView.m
//  KECallsAttribution
//
//  Created by 赵 进喜 on 14/12/12.
//  Copyright (c) 2014年 K.BLOCK. All rights reserved.
//

#import "EZCustomActionView.h"

@implementation EZCustomActionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)init
{

    if (self==[super init]) {
        
        
        self=[[[NSBundle mainBundle]loadNibNamed:@"EZCustomActionView" owner:nil options:nil]objectAtIndex:0];
        
        
    }

    return self;

}
-(void)initSubViews
{


    self.hidden=YES;
    self.alpha=0.5;
    
    


}

-(void)showInView:(UIView *)view
{

    self.frame=view.window.frame;
    
    
    [UIView animateWithDuration:0.33 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        
         [view.window addSubview:self];
        
        
      
         self.hidden=NO;
        
        
        self.contentView.transform=CGAffineTransformMakeTranslation(0, -300);
        
        
        
    } completion:^(BOOL finished) {
        
    
    
    
    }];
    


}
-(void)dismiss
{


    [UIView animateWithDuration:0.33 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        
        
        
        
        
        self.contentView.transform=CGAffineTransformMakeTranslation(0, 0);
        
        
        
        
        
        
    } completion:^(BOOL finished) {
        
        
         self.hidden=YES;
        
        
        [self removeFromSuperview];
        
    }];




}

- (IBAction)tapDismiss:(UITapGestureRecognizer *)sender {
    
    [self dismiss];
}

- (IBAction)touchMenu:(UIButton *)sender {
    
    
    _touchMenuBlock((NSInteger)sender.tag);
    
    [self dismiss];
}

- (IBAction)hideAction:(UIButton *)sender {
    
    [self dismiss];
    
}
@end
