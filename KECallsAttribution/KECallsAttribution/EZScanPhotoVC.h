//
//  EZScanPhotoVC.h
//  KECallsAttribution
//
//  Created by 赵 进喜 on 15/7/6.
//  Copyright (c) 2015年 K.BLOCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EZScanPhotoVC : UIViewController
{
    
    
    
    
    NSMutableArray *allPhotos;
    
    
    
    NSMutableArray *allSreenShots;
    
    
    NSMutableArray *allImages;
    
    
    
}


- (IBAction)skipToCleanPage:(UIButton *)sender;
- (IBAction)backToLast:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *cleanButton;

@property (weak, nonatomic) IBOutlet UILabel *cleanTips;
@end
