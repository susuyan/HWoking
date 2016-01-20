//
//  HOptimizeCell.h
//  KECallsAttribution
//
//  Created by EverZones on 16/1/19.
//  Copyright © 2016年 K.BLOCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HOptimizeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *optimizeCardIcon;
@property (weak, nonatomic) IBOutlet UILabel *optimizeCardTitle;
@property (weak, nonatomic) IBOutlet UILabel *optimizeCardDetailTitle;
@property (weak, nonatomic) IBOutlet UIButton *optimizeCardButton;

- (void)cellDataSource:(NSMutableArray *)dataArray IndexPath:(NSIndexPath *)indexPath;
@end
