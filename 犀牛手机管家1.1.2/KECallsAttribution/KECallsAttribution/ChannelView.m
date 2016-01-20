//
//  ChannelView.m
//  News
//
//  Created by 赵 进喜 on 14-3-19.
//  Copyright (c) 2014年 everzones. All rights reserved.
//

#import "ChannelView.h"

@implementation ChannelView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initViews];
        // Initialization code
    }
    return self;
}
-(void)initViews
{
    self.userInteractionEnabled=YES;

    _selectedView=[[UIImageView alloc]initWithFrame:CGRectMake((self.bounds.size.width-40)*0.5, (self.bounds.size.height-40)*0.5, 40, 40)];
    
    _selectedView.image=[UIImage imageNamed:@"channel_selected"];
    _selectedView.hidden=YES;
    _isSelected=NO;
    
    
    [self addSubview:_selectedView];

    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapChannel:)];
    
    [self addGestureRecognizer:tap];

}

-(void)layoutSubviews
{

    _selectedView.frame=CGRectMake((self.bounds.size.width-40)*0.5, (self.bounds.size.height-40)*0.5, 40, 40);


}
-(void)setIsSelected:(BOOL )selected
{

    hasSelected=selected;
    
    if (hasSelected) {
        
        
        
        _selectedView.hidden=NO;
        
        
    }else
    {
        
        _selectedView.hidden=YES;
        
        
    }


}

-(void)tapChannel:(UITapGestureRecognizer *)tap
{
    
    
    
    
    self.isSelected=!hasSelected;
    
    
    
    _touchBlock(self.photo,hasSelected);
    
    
    
   

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
