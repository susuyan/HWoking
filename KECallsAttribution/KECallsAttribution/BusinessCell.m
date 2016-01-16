//
//  BusinessCell.m
//  KECallsAttribution
//
//  Created by 赵 进喜 on 14-8-18.
//  Copyright (c) 2014年 K.BLOCK. All rights reserved.
//

#import "BusinessCell.h"
#import "UIImageView+WebCache.h"
@implementation BusinessCell

- (void)awakeFromNib
{
    // Initialization code
   
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setInfo:(NSDictionary *)item
{
    
    mItem=item;
    
    iconCount=0;
    
    self.huiImage.hidden=YES;
    
    self.dingImage.hidden= YES;
    self.tuanImage.hidden=YES;
    
    self.name.frame=CGRectMake(20, 12, SCREEN_WIDTH-40, 25);
    
    
    
    BOOL tuan=[[item objectForKey:@"has_deal"] boolValue];
    
    
    
    BOOL  youhui=[[item objectForKey:@"has_coupon"] boolValue];
    
    
    BOOL yuding =[[item objectForKey:@"has_online_reservation"] boolValue];
    
    
    

    
  //  NSLog(@"%@",item);
    
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
    
    
        dispatch_async(dispatch_get_main_queue(), ^{
        
        
        
            for (int i=0; i<3; i++) {
                
                
                switch (i) {
                    case 0:
                        [self setIconWith:_tuanImage AndExsit:tuan];
                        break;
                    case 1:
                        [self setIconWith:_huiImage AndExsit:youhui];
                        break;
                        
                    case 2:
                        [self setIconWith:_dingImage AndExsit:yuding];
                        break;
                        
                        
                    default:
                        break;
                }
                
                
            }

        
        
        });
    
    
    });
    
    

    
    
    
    
    
    
    
    
    

    self.name.text=[item objectForKey:@"name"];
    
    self.addressLbl.text=[item objectForKey:@"address"];
    
    self.telLbl.text=item [@"telephone"];
    
    float distance =[[item objectForKey:@"distance"] floatValue];
    
    
    if (distance<1000) {
        self.distance.text=[NSString stringWithFormat:@"%dm",(int)distance];
    }else
    {
        self.distance.text=[NSString stringWithFormat:@"%.1fkm",distance/1000];

    
    }
    
    NSString *url=[item objectForKey:@"photo_url"];
    
    [self.infoImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"nopic"]];


    [self reloadInputViews];
}

-(void)setIconWith:(UIImageView *)imageView AndExsit:(BOOL)exsit
{

    if (exsit) {
        iconCount++;
        
        
        imageView.hidden=NO;
        
        imageView.frame=CGRectMake(20+(iconCount-1)*30, 12, 25, 25);
        self.name.frame=CGRectMake(20+iconCount*30, self.name.frame.origin.y, SCREEN_WIDTH-40-iconCount*30,self.name.frame.size.height );

        
        
        
        
        
        
    }else
    {
    
        imageView.hidden=YES;
    
    }

   

}


@end
