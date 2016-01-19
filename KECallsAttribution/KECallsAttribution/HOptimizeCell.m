//
//  HOptimizeCell.m
//  KECallsAttribution
//
//  Created by EverZones on 16/1/19.
//  Copyright © 2016年 K.BLOCK. All rights reserved.
//

#import "HOptimizeCell.h"

@implementation HOptimizeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.5f);
    self.layer.shadowOpacity = .5f;
    self.layer.shadowRadius = 0.5f;
    
    
    
    self.backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"status_card_bg"]];
    
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
}

#pragma mark - Prevate
- (void)cellDataSource:(NSMutableArray *)dataArray IndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = [dataArray objectAtIndex:indexPath.row];
    
    NSString *iconName = [dict objectForKey:@"optimizeCardIcon"];
    NSString *title = [dict objectForKey:@"optimizeCardTitle"];
    NSString *detailTitle = [dict objectForKey:@"optimizeCardDetailTitle"];
    NSString *buttonTitle = [dict objectForKey:@"optimizeCardButton"];
    
    _optimizeCardIcon.image = [UIImage imageNamed:iconName];
    _optimizeCardTitle.text = title;
    _optimizeCardDetailTitle.text = detailTitle;
    [_optimizeCardButton setTitle:buttonTitle forState:UIControlStateNormal];
}
@end
