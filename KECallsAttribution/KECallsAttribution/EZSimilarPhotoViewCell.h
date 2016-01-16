//
//  EZSimilarPhotoViewCell.h
//  TestImageCompare
//
//  Created by 赵 进喜 on 15/5/27.
//  Copyright (c) 2015年 everzones. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZPhotoObject.h"
#import "ChannelView.h"
@interface EZSimilarPhotoViewCell : UITableViewCell
@property(assign,nonatomic)BOOL isAllSelected;
@property(strong,nonatomic)NSArray *mItems;
-(void)setInfo:(NSArray *)photos;
+(int)getHeightWithCount:(int)count;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *timeTxt;
- (IBAction)selectAll:(UIButton *)sender;
@end
