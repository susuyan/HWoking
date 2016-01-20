//
//  EZAdView.h
//  TestAd
//
//  Created by 赵 进喜 on 15/7/22.
//  Copyright (c) 2015年 everzones. All rights reserved.
//


typedef void(^TapBlock)(void);

#import <UIKit/UIKit.h>
@interface EZAdView : UIView
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIImageView *adImageView;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adViewheight;

@property (weak, nonatomic) IBOutlet UIImageView *kuangView;

@property(strong,nonatomic)TapBlock tapBlock;

- (IBAction)tapAdView:(UITapGestureRecognizer *)sender;

-(void)showInView:(UIView *)mView;

-(void)hideView;
- (IBAction)closeButton:(UIButton *)sender;
@end


