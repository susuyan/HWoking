//
//  HOptimizeTableViewController.m
//  KECallsAttribution
//
//  Created by EverZones on 16/1/19.
//  Copyright © 2016年 K.BLOCK. All rights reserved.
//

#import "HOptimizeTableViewController.h"
#import "HOptimizeCell.h"
#import "HDefaults.h"
#import "EZScanPhotoVC.h"
#import "EMCeSuViewController.h"
#import "EZProtectVC.h"
#import "UIDevice+HInfo.h"
@interface HOptimizeTableViewController ()

@property(nonatomic, strong) NSMutableArray *dataSourceArray;

@end

@implementation HOptimizeTableViewController
#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSourceArray = [NSMutableArray array];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupDataSource];
    [self setupHederView];
    [self.tableView reloadData];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initial
/**
 *  设置headerView
 */
- (void)setupHederView {
    self.deviceNameLabel.text = [NSString stringWithFormat:@"您的%@",[UIDevice devicenName]];
    self.optimizeNumsLabel.text = [NSString stringWithFormat:@"%d个优化建议",[self getOptimizeNums]];
}

/**
 *  根据优化建议数，来初始化数据源
 */
- (void)setupDataSource {
    [self.dataSourceArray removeAllObjects];
    //是否开启防骚扰
    if (![HDefaults sharedDefaults].isOpenHarassment) {
        NSDictionary *dicContactsCard = @{@"optimizeCardIcon": @"harassment_icon" ,
                                          @"optimizeCardTitle": @"立即开启防骚扰模式" ,
                                          @"optimizeCardDetailTitle": @"智能生成号码库，来电为您识别陌生号码，诈骗电话" ,
                                          @"optimizeCardButton": @"立即开启" };

        [self.dataSourceArray addObject:dicContactsCard];
    }
    //判断内存是否小于600M
    if ([HDefaults sharedDefaults].isHintFreeSpace) {
        NSDictionary *dicContactsCard = @{@"optimizeCardIcon": @"photoclean_icon" ,
                                          @"optimizeCardTitle": @"相似照片清理" ,
                                          @"optimizeCardDetailTitle": @"检测相似照片，清理手动无用的照片，节省空间，加速手机运行" ,
                                          @"optimizeCardButton": @"立即清理" };
        
        [self.dataSourceArray addObject:dicContactsCard];
    }
    //是否进行网络测速
    if ([HDefaults sharedDefaults].isTestedSpeed) {
        NSDictionary *dicContactsCard = @{@"optimizeCardIcon": @"testspeed_icon" ,
                                          @"optimizeCardTitle": @"网络测速建议" ,
                                          @"optimizeCardDetailTitle": @"测试当前网络，让你有个安全快速的网络环境" ,
                                          @"optimizeCardButton": @"立即测速" };
        
        [self.dataSourceArray addObject:dicContactsCard];
    }
    
    
    

}
/**
 *  获取优化建议数
 */
- (int)getOptimizeNums {
    int optimizeNum = 0;
    HDefaults *defaults = [HDefaults sharedDefaults];
    
    if (!defaults.isOpenHarassment) {
        ++optimizeNum;
    }
    if (defaults.isHintFreeSpace) {
        ++optimizeNum;
    }
    if (defaults.isTestedSpeed) {
        ++optimizeNum;
    }
    
    return optimizeNum;
}


#pragma mark - IBAction
- (IBAction)optimizeAction:(UIButton *)sender {
    NSString *optimizeString = sender.titleLabel.text;
    if ([optimizeString isEqualToString:@"立即开启"]) {
        //跳转到防骚扰界面
        EZProtectVC *protect = [self.storyboard instantiateViewControllerWithIdentifier:@"EZProtectVC"];
        [self.navigationController pushViewController:protect animated:YES];
    }else if ([optimizeString isEqualToString:@"立即清理"]) {
        //跳转到照片清理界面
        EZScanPhotoVC *scan=[self.storyboard instantiateViewControllerWithIdentifier:@"EZScanPhotoVC"];
        [self.navigationController pushViewController:scan animated:YES];

    }else if ([optimizeString isEqualToString:@"立即测速"]) {
        //跳转到网络测速界面
        EMCeSuViewController *cesu = [self.storyboard instantiateViewControllerWithIdentifier:@"EMCeSuViewController"];
        [self.navigationController pushViewController:cesu animated:YES];
    }
}

- (IBAction)backAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Tabelview Delegate & Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSourceArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HOptimizeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HOptimizeCellID" forIndexPath:indexPath];
    
    [cell cellDataSource:self.dataSourceArray IndexPath:indexPath];
    
  
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 156.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}


@end
