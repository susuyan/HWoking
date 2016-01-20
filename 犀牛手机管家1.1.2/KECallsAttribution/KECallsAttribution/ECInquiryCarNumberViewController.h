//
//  ECInquiryCarNumberViewController.h
//  KECallsAttribution
//
//  Created by 赵 进喜 on 14-5-20.
//  Copyright (c) 2014年 K.BLOCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECInquiryCarNumberViewController : UITableViewController<UISearchBarDelegate,UISearchDisplayDelegate>
@property(strong,nonatomic)NSMutableArray *allArray;
@property(strong,nonatomic)NSMutableArray *searchResultArray;
@property(strong,nonatomic)NSDictionary *provinceDic;
- (IBAction)back:(UIButton *)sender;
@end
