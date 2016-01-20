//
//  EZCustomActionView.h
//  KECallsAttribution
//
//  Created by 赵 进喜 on 14/12/12.
//  Copyright (c) 2014年 K.BLOCK. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TouchMenu)(int);

@interface EZCustomActionView : UIView
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic)TouchMenu touchMenuBlock;

-(void)showInView:(UIView *)view;

-(void)dismiss;

- (IBAction)tapDismiss:(UITapGestureRecognizer *)sender;

- (IBAction)touchMenu:(UIButton *)sender;

- (IBAction)hideAction:(UIButton *)sender;

@end
