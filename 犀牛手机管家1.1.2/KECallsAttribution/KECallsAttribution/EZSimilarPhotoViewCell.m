//
//  EZSimilarPhotoViewCell.m
//  TestImageCompare
//
//  Created by 赵 进喜 on 15/5/27.
//  Copyright (c) 2015年 everzones. All rights reserved.
//

#import "EZSimilarPhotoViewCell.h"
#import "EZAppHelper.h"
#define leftspace 15

#define space ([UIScreen mainScreen].bounds.size.width-leftspace*2-270)/2


//数组本身不支持KVO

@implementation EZSimilarPhotoViewCell

- (void)awakeFromNib {
    
    
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setInfo:(NSArray *)photos
{
    _mItems=photos;
    
    for (ChannelView *channel in self.backView.subviews) {
        [channel removeFromSuperview];
    }
    
    
   
    
    EZPhotoObject  *first=photos[0];
    
//    NSDate *date=[first.asset valueForProperty:ALAssetPropertyDate];
   
    
    NSDate *date=first.asset.creationDate;
    
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    
    
    formatter.dateFormat=@"YYYY年MM月dd日";
    
    
    
    
    
    self.timeTxt.text=[formatter stringFromDate:date];
    
    
    
    
    
    

   //m int height=0;
    
    
    for (int i=0; i<photos.count; i++) {
        
        
        
        
        
        ChannelView *channel=[[ChannelView alloc]init];
        
        CGPoint position=[self getPositionWithIndex:i];
        
        
        
        channel.frame=CGRectMake(position.x, position.y, 90, 90);
            
        
            
        
        channel.photo=[photos objectAtIndex:i];
        
        
        channel.image=channel.photo.thumbImage;
        [self.backView addSubview:channel];
        if ([[EZAppHelper shareAppHelper].selectedArray containsObject:channel.photo]) {
            [channel setIsSelected:YES];
        }
        
        
        
        channel.touchBlock=^(EZPhotoObject *photo,BOOL isSelected){
        
        
            
            if (isSelected) {
                
                
                
               // [[EZAppHelper shareAppHelper].selectedArray addObject:photo];
            
                [SelectedArray addObject:photo];
                
                
            }else
            {
            
                [SelectedArray removeObject:photo];
                
            
            }
            
            
            
            if ([[self checkSelectedPhoto]count]==_mItems.count) {
                
                
                self.isAllSelected=YES;
                
            }else
            {
            
                 self.isAllSelected=NO;
            
            
            }
            
            
        
        };
        
        
        

        
    }

    if ([[self checkSelectedPhoto]count]==_mItems.count) {
        
        
        self.isAllSelected=YES;
        
    }else
    {
        
        self.isAllSelected=NO;
        
        
    }


}

-(CGPoint)getPositionWithIndex:(int)index
{
    
    
    
    int row=floor(index/3);
    
    // NSLog(@"%d",row);
    int x=leftspace+(index%3)*(90+space);
    
    int y= 10+row*(90+5);
    
    CGPoint point=CGPointMake(x,y);
    
    
    return point;
    
}
+(int)getHeightWithCount:(int)count
{




   int rowCount=ceil(count/3.0f);
    
    
   int height=10+(rowCount-1)*(90+5)+10+90;
    
  
   return height+35;


}
- (IBAction)selectAll:(UIButton *)sender {
    
    self.isAllSelected=!self.isAllSelected;
    
    
    //添加或者删除
    if (_isAllSelected) {
        
        
        
        [SelectedArray addObjectsFromArray:[self checkUnSelectedPhoto]];
        
        
        for (ChannelView *channel in self.backView.subviews) {
            [channel setIsSelected:YES];
        }

        
    }else
    {
        
        
        
        [SelectedArray removeObjectsInArray:_mItems];
        
        
        
        for (ChannelView *channel in self.backView.subviews) {
            [channel setIsSelected:NO];
        }

    
        
    }

    
    
    
}
-(void)setIsAllSelected:(BOOL)isAllSelected
{

    _isAllSelected=isAllSelected;

//更改按钮状况
    if (isAllSelected) {
        
        
        
        [_selectButton setImage:[UIImage imageNamed:@"selected_pick"] forState:UIControlStateNormal];
        
        
        
    }else
    {
        
        
        [_selectButton setImage:[UIImage imageNamed:@"unselected_pick"] forState:UIControlStateNormal];

        
        
    }





}
-(NSArray *)checkSelectedPhoto
{

    NSMutableArray *temp=[NSMutableArray array];
    
    for (EZPhotoObject *photo in _mItems) {
        
        
        if ([[EZAppHelper shareAppHelper].selectedArray containsObject:photo]) {
            
            
            [temp addObject:photo];
            
        }
        
    }

    return temp;

}


-(NSArray *)checkUnSelectedPhoto
{
    
    NSMutableArray *temp=[NSMutableArray array];
    
    for (EZPhotoObject *photo in _mItems) {
        
        
        if (![[EZAppHelper shareAppHelper].selectedArray containsObject:photo]) {
            
            
            [temp addObject:photo];
            
        }
        
    }
    
    return temp;
    
}

@end
