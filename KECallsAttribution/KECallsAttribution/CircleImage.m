//
//  CircleImage.m
//  Ringtone
//
//  Created by 赵 进喜 on 14-2-17.
//  Copyright (c) 2014年 everzones. All rights reserved.
//

#import "CircleImage.h"

@implementation CircleImage

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initCircleImage];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{

    if (self=[super initWithCoder:aDecoder]) {
        
        
        [self initCircleImage];
        
    }
    return self;
}
-(void)initCircleImage
{

    self.userInteractionEnabled=YES;
    
    [self.layer setCornerRadius:CGRectGetHeight([self bounds]) / 2];
    self.layer.masksToBounds = YES;
    
    self.layer.borderWidth = 2;
    self.layer.borderColor = [[UIColor whiteColor] CGColor];


   
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage)];
    
    [self addGestureRecognizer:tap];
    

}
-(void)tapImage
{

    
    if (_touchBlock) {
         _touchBlock();
    }

   

}

-(void)setImage:(UIImage *)image
{

    
    [super setImage:image];
    
    
    self.layer.contents = (id)[image CGImage];


    
    

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
