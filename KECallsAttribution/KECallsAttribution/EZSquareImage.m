//
//  EZSquareImage.m
//  MyContacts
//
//  Created by 赵 进喜 on 15/1/21.
//  Copyright (c) 2015年 everzones. All rights reserved.
//

#import "EZSquareImage.h"

@implementation EZSquareImage
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initSquareImage];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    
    if (self=[super initWithCoder:aDecoder]) {
        
        
        [self initSquareImage];
        
    }
    return self;
}
-(void)initSquareImage
{
    
    [self.layer setCornerRadius:6];
    self.layer.masksToBounds = YES;
    
//    self.layer.borderWidth = 2;
//    self.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    
    
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

@end
