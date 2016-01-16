//
//  ECCheaterVC.h
//  KECallsAttribution
//
//  Created by 赵 进喜 on 14/12/18.
//  Copyright (c) 2014年 K.BLOCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECCheaterVC : UITableViewController<UISearchBarDelegate>
{
    int mPage;

    NSMutableArray *mItems;
    NSMutableArray *resultArray;
    
}
- (IBAction)reportNumber:(UIButton *)sender;
- (IBAction)backButtonPressed:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@end
