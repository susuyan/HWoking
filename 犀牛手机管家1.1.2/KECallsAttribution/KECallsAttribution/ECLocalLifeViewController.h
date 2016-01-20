//
//  ECLocalLifeViewController.h
//  KECallsAttribution
//
//  Created by 赵 进喜 on 14-8-18.
//  Copyright (c) 2014年 K.BLOCK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNetEngine.h"
#import <CoreLocation/CoreLocation.h>
#import "SVProgressHUD.h"
@interface ECLocalLifeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MyNetEngineDelegate,UITextFieldDelegate>
{

    MyNetEngine *mEngine;
    
    int mPage;
    
    NSMutableArray *mItems;
    
    int type;
    

}

@property (weak, nonatomic) IBOutlet UITableView *tableView;



@property (weak, nonatomic) IBOutlet UIImageView *selectedTypeImage;


@property (nonatomic, copy) NSString * cityName;

@property(assign,nonatomic)double mlng;
@property(assign,nonatomic)double mlat;

@property (nonatomic, copy) NSString * category;

@property(copy,nonatomic)NSString *searchKeyword;

@property (weak, nonatomic) IBOutlet UIView *typeView;

- (IBAction)backPressed:(UIButton *)sender;

- (IBAction)selectType:(UIButton *)sender;
- (IBAction)changeType:(UIButton *)sender;

@end
