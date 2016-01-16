//
//  ECBlackListViewController.h
//  KECallsAttribution
//
//  Created by 赵 进喜 on 14-5-19.
//  Copyright (c) 2014年 K.BLOCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECBlackListViewController : UIViewController<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *numberText;
@property(nonatomic)BOOL isPush;
@property(copy,nonatomic)NSString *blackNumber;
@property (weak, nonatomic) IBOutlet UIImageView *guideView;
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;
- (IBAction)addBlackList:(UIButton *)sender;
- (IBAction)hideKeyboard:(UITapGestureRecognizer *)sender;

- (IBAction)back:(UIButton *)sender;
@end
