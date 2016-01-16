//
//  BusinessCell.h
//  KECallsAttribution
//
//  Created by 赵 进喜 on 14-8-18.
//  Copyright (c) 2014年 K.BLOCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessCell : UITableViewCell
{

   
    int iconCount;

    NSDictionary *mItem;

}
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *telLbl;
-(void)setInfo:(NSDictionary *)item;
@property (weak, nonatomic) IBOutlet UIImageView *tuanImage;
@property (weak, nonatomic) IBOutlet UIImageView *huiImage;
@property (weak, nonatomic) IBOutlet UIImageView *dingImage;
@property (weak, nonatomic) IBOutlet UIImageView *infoImage;

@end
