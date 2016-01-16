//
//  KEPostCodeDetailController.h
//  KECallsAttribution
//
//  Created by lichenWang on 14-1-8.
//  Copyright (c) 2014年 KERNEL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KEPostCodeDetailController : UITableViewController<UISearchBarDelegate,UISearchDisplayDelegate>
@property (nonatomic, strong)NSArray * array;
@property (nonatomic, strong)NSArray * searchResultsArray;
- (IBAction)back:(UIButton *)sender;
@end
