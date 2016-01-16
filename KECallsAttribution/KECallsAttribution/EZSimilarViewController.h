//
//  EZSimilarViewController.h
//  TestImageCompare
//
//  Created by 赵 进喜 on 15/5/27.
//  Copyright (c) 2015年 everzones. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EZSimilarViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{


    BOOL isSmartSelect;


}
//@property(nonatomic,strong)NSMutableArray *allSimilarImages;
@property(nonatomic,strong)NSMutableDictionary *allDics;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)autoSelect:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *showCountButton;
- (IBAction)deleteSelectedImages:(UIButton *)sender;
- (IBAction)backToLast:(UIButton *)sender;
@end
