//
//  EZGuideCell.m
//  GameGuide
//
//  Created by lichenWang on 13-12-9.
//  Copyright (c) 2013年 EverZones. All rights reserved.
//

#import "EZGuideCell.h"
#import "UILabel+Size.h"
#import "UIImageView+WebCache.h"
#define MAX_WIDTH_OF_TEXT           290
#define SPACE_WIDTH_OF_CELL         5
@implementation EZGuideCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_lexi"]];
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_selected_lexi"]];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
      
    
    
    
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
- (void)setGuide:(EZGuide *)guide{
    
    
      self.contentBackground.image=[[UIImage imageNamed:@"mainCellBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
    
    
    _guide = guide;
    self.userName.text = guide.userName;
    self.dateInformation.text = [self changUnixTime:guide.dateInformation];
    [self.headPortrait setImageWithURL:[NSURL URLWithString:guide.headPortrait] placeholderImage:[UIImage imageNamed:@"zhanweitu"]];
    
    self.content.text = guide.content;
    CGRect bounds = CGRectMake(0, 0, MAX_WIDTH_OF_TEXT, 99999.9);
    bounds = [self.content textRectForBounds:bounds limitedToNumberOfLines:0];
    CGRect frameOfLabel = CGRectZero;
    frameOfLabel.size = bounds.size;
    frameOfLabel.origin.x = 15;
    frameOfLabel.origin.y = 50;
    self.content.frame = frameOfLabel;
    //NSLog(@"-------%f========height=%f",bounds.size.width,bounds.size.height);
    CGRect imageViewFrame = self.contentBackground.frame;
    imageViewFrame.size.height = self.content.frame.size.height+ 3*SPACE_WIDTH_OF_CELL +35;
    self.contentBackground.frame = imageViewFrame;
    
    CGRect cellBounds = self.bounds;
    cellBounds.size.height = frameOfLabel.size.height + 3 * SPACE_WIDTH_OF_CELL +55;
    self.bounds = cellBounds;
}

+ (CGFloat) heightForMessage:(EZGuide *)guide
{
    CGSize size = [UILabel calcLabelSizeWithString:guide.content andFont:[UIFont systemFontOfSize:18] maxLines:99999 lineWidth:MAX_WIDTH_OF_TEXT];
    CGFloat f;
    if (DEVICE) {
        f = size.height + 3 * SPACE_WIDTH_OF_CELL + 40;
    }else{
        f = size.height + 3 * SPACE_WIDTH_OF_CELL + 60;
    }
    return f;
}
- (NSString*)changUnixTime:(NSString*)time{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    formatter.dateFormat = @"YYYY-MM-dd";
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[time integerValue]];
    return [formatter stringFromDate:date];
}
@end
