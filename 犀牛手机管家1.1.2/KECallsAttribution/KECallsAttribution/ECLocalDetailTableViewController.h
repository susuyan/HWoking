//
//  ECLocalDetailTableViewController.h
//  KECallsAttribution
//
//  Created by 赵 进喜 on 14-8-19.
//  Copyright (c) 2014年 K.BLOCK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWStarRateView.h"
@interface ECLocalDetailTableViewController : UITableViewController<UIActionSheetDelegate>
{

    NSMutableArray *listItems;


}
@property (weak, nonatomic) IBOutlet UILabel *catLbl;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
- (IBAction)backButtonPressed:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *costLbl;
//@property (weak, nonatomic) IBOutlet UILabel *phoneNum;
//@property (weak, nonatomic) IBOutlet UILabel *address;
@property(strong,nonatomic)NSDictionary *mItem;
@property (weak, nonatomic) IBOutlet UITextView *desc;
@property (weak, nonatomic) IBOutlet CWStarRateView *rateView;
@property (weak, nonatomic) IBOutlet UILabel *productLbl;
@property (weak, nonatomic) IBOutlet UILabel *decorationLbl;
@property (weak, nonatomic) IBOutlet UILabel *serviceLbl;
@property (weak, nonatomic) IBOutlet UILabel *reviewLbl;
- (IBAction)viewReviews:(UIButton *)sender;
@end
