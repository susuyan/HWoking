//
//  CircleView.h
//  TestCircle
//
//  Created by melonzone on 14-9-26.
//  Copyright (c) 2014年 Joseph Fu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleView : UIView

@property (nonatomic, assign) float rating;
@property (nonatomic, assign) float lineWidth;
@property (nonatomic, strong) UIColor *ringColor;
- (void)animateWithDuration:(NSTimeInterval)duration rating:(float)rating;
- (void)setRating:(float)rating;
@end
