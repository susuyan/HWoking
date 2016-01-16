//
//  CircleView.m
//  TestCircle
//
//  Created by melonzone on 14-9-26.
//  Copyright (c) 2014年 Joseph Fu. All rights reserved.
//

#import "CircleView.h"

@interface CircleView ()


@property (nonatomic, strong) CAShapeLayer *backgroundLayer;
@property (nonatomic, strong) CAShapeLayer *ratingLayer;

@end

@implementation CircleView

- (void)awakeFromNib
{
    [super awakeFromNib];
    _lineWidth = 2.0;
    _rating = 0.0;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _lineWidth = 2.0;
        _rating = 0.0;
    }
    return self;
}

- (void)setLineWidth:(float)lineWidth
{
    _lineWidth = lineWidth;

    [self updateLayerPath];

}

- (void)animateWithDuration:(NSTimeInterval)duration rating:(float)rating
{
    _rating = rating;
    [self updateRatingLayerColor];
    NSTimeInterval finalDuration = MAX(duration, 0.0);
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = finalDuration;
    pathAnimation.fromValue = [NSNumber numberWithFloat:_ratingLayer.strokeEnd];//设置起点
    pathAnimation.toValue = [NSNumber numberWithFloat:_rating];
    _ratingLayer.strokeEnd = _rating;
    [_ratingLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
}

- (void)setRating:(float)rating
{
    _rating = rating;
    [self updateRatingLayerColor];
    self.ratingLayer.strokeEnd = _rating;
}

- (void)updateRatingLayerColor
{
//    UIColor *ratingColor;
//    if (_rating >= 0.95) {
//        ratingColor = [UIColor redColor];
//    }
//    else if (_rating >= 0.9) {
//        ratingColor = [UIColor yellowColor];
//    }
//    else if (_rating >= 0.35) {
//        ratingColor = [UIColor greenColor];
//    }
//    else {
//        ratingColor = [UIColor purpleColor];
//    }
    
//    _ratingLayer.strokeColor = ratingColor.CGColor;
    
    
     _ratingLayer.strokeColor = _ringColor.CGColor;
}



- (void)updateLayerPath
{
    CGRect innerRect = CGRectInset(self.bounds, _lineWidth/2.0, _lineWidth/2.0);
    
    CGFloat radius = CGRectGetWidth(innerRect)/2.0;
    CGPoint center = CGPointMake(CGRectGetWidth(self.bounds)/2.0, CGRectGetHeight(self.bounds)/2.0);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:radius
                                                    startAngle:M_PI * 0.75
                                                      endAngle:M_PI * 0.75 + M_PI * 1.5
                                                     clockwise:1];
    
    _backgroundLayer.path = path.CGPath;
    _backgroundLayer.lineWidth = _lineWidth;
    
    _ratingLayer.path = path.CGPath;
    _ratingLayer.lineWidth = _lineWidth;
    

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.backgroundLayer == nil) {
        
        _backgroundLayer = [[CAShapeLayer alloc] init];
        
        CGRect innerRect = CGRectInset(self.bounds, _lineWidth/2.0, _lineWidth/2.0);
        CGFloat radius = CGRectGetWidth(innerRect)/2.0;
        CGPoint center = CGPointMake(CGRectGetWidth(self.bounds)/2.0, CGRectGetHeight(self.bounds)/2.0);
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                            radius:radius
                                                        startAngle:M_PI * 0.75
                                                          endAngle:M_PI * 0.75 + M_PI * 1.5
                                                         clockwise:1];
        
        _backgroundLayer.path = path.CGPath;
        _backgroundLayer.fillColor = [UIColor clearColor].CGColor;
        _backgroundLayer.lineWidth = _lineWidth;
       
        _backgroundLayer.strokeColor = [UIColor colorWithWhite:0.5 alpha:0.3].CGColor;
        
        [self.layer insertSublayer:_backgroundLayer atIndex:0];
        
    }
    
    if (self.ratingLayer == nil) {
        
        _ratingLayer = [[CAShapeLayer alloc] init];
        
        CGRect innerRect = CGRectInset(self.bounds, _lineWidth/2.0, _lineWidth/2.0);
        CGFloat radius = CGRectGetWidth(innerRect)/2.0;
        CGPoint center = CGPointMake(CGRectGetWidth(self.bounds)/2.0, CGRectGetHeight(self.bounds)/2.0);
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                            radius:radius
                                                        startAngle:M_PI * 0.75
                                                          endAngle:M_PI * 0.75 + M_PI * 1.5
                                                         clockwise:1];
        _ratingLayer.path = path.CGPath;
        _ratingLayer.fillColor = [UIColor clearColor].CGColor;
        _ratingLayer.lineWidth = _lineWidth;
        _ratingLayer.strokeEnd = _rating;
        [self.layer addSublayer:_ratingLayer];
    }

    [self updateRatingLayerColor];
    
}

@end
