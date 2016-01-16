//
//  HPromptView.h
//  Harassment
//
//  Created by EverZones on 15/11/18.
//  Copyright (c) 2015年 EverZones. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonAction)(int);
@interface HPromptView : UIView
@property (strong, nonatomic)ButtonAction buttonBlock;
@property (weak, nonatomic) IBOutlet UIView *promptView;

- (void)dismiss;
-(void)showInView:(UIView *)view;
@end
