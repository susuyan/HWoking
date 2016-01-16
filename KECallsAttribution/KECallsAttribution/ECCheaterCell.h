//
//  ECCheaterCell.h
//  KECallsAttribution
//
//  Created by 赵 进喜 on 14/12/18.
//  Copyright (c) 2014年 K.BLOCK. All rights reserved.
//


//typedef void(^TouchBlock)(NSString *);

#import <UIKit/UIKit.h>
#import<MessageUI/MFMailComposeViewController.h>
@interface ECCheaterCell : UITableViewCell<MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *telText;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *detailLbl;
@property (weak, nonatomic) IBOutlet UILabel *sourceLbl;
//@property(nonatomic,nonatomic)TouchBlock touchBlock;
- (IBAction)appealLbl:(UIButton *)sender;
+(int)getCellHeightWith:(NSString *)detail font:(UIFont *)font width:(float)width;

-(void)setInfo:(NSDictionary *)info;


@end
