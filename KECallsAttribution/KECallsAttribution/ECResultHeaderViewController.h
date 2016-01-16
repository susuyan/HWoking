//
//  ECResultHeaderViewController.h
//  Utilities
//
//  Created by 赵 进喜 on 14-7-23.
//  Copyright (c) 2014年 everzones. All rights reserved.
//
#import <UIKit/UIKit.h>


@interface ECResultHeaderViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *manuLbl;
@property (weak, nonatomic) IBOutlet UILabel *brandLbl;
@property (weak, nonatomic) IBOutlet UILabel *specLbl;
@property (weak, nonatomic) IBOutlet UILabel *gtinLbl;

@property (weak, nonatomic) IBOutlet UILabel *priceLbl;


-(void)setInfo:(NSDictionary *)item;


@end
