//
//  ECScannerCodeViewController.h
//  Utilities
//
//  Created by 赵 进喜 on 14-7-23.
//  Copyright (c) 2014年 everzones. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarReaderView.h"

@interface ECScannerCodeViewController : UIViewController<ZBarReaderViewDelegate,UITableViewDataSource,UITableViewDelegate>
{

    ZBarReaderView *mReaderView;
    
    
    NSString *code;
    
    
   
    // NSMutableArray *mItems;
    
   
    
    UIImageView *line;
    
    NSTimer *mTimer;
    

}
@property (weak, nonatomic) IBOutlet UIImageView *readerViewBg;
//@property (weak, nonatomic) IBOutlet UITableView *resultTabView;
@property (weak, nonatomic) IBOutlet UIImageView *scannerhelper;
@property (weak, nonatomic) IBOutlet UIImageView *viewBg;
- (IBAction)back:(UIButton *)sender;

@end
