//
//  HPromptView.m
//  Harassment
//
//  Created by EverZones on 15/11/18.
//  Copyright (c) 2015年 EverZones. All rights reserved.
//

#import "HPromptView.h"
#import "HMacro.h"

@implementation HPromptView

- (void) awakeFromNib {

}

- (instancetype)init {
    
    if (self == [super init]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"HPromptView" owner:nil options:nil] objectAtIndex:0];
        self.promptView.layer.cornerRadius = 6;
        self.promptView.layer.masksToBounds = YES;
    }
    
    return self;
    
}
- (void)dismiss {
    [UIView animateWithDuration:0.33 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform=CGAffineTransformMakeTranslation(0, 0);
        
    } completion:^(BOOL finished) {
        self.hidden=YES;
        [self removeFromSuperview];
    }];
}

- (void)showInView:(UIView *)view {
    
    self.frame = CGRectMake(0, 0, WIDTH(view), HEIGHT(view));
    
    [UIView animateWithDuration:0.33 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        self.hidden = NO;
        self.transform = CGAffineTransformMakeTranslation(0, 0);
        
    } completion:^(BOOL finished) {
        
    }];
    
}
- (IBAction)noLongerRemindAction:(UIButton *)sender {
    _buttonBlock((int)sender.tag);
    [self dismiss];
    
}

- (IBAction)clickUpdate:(UIButton *)sender {
    _buttonBlock((int)sender.tag);
    [self dismiss];
}
- (IBAction)tapGestureAction:(UITapGestureRecognizer *)sender {
    [self dismiss];
}

@end
