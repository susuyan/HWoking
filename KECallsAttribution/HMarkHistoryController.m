//
//  HMarkHistoryController.m
//  Harassment
//
//  Created by EverZones on 15/11/9.
//  Copyright (c) 2015年 EverZones. All rights reserved.
//

#import "HMarkHistoryController.h"
#import "HVcardImporter.h"
#import "HMarkHistoryCell.h"
@interface HMarkHistoryController ()<UIActionSheetDelegate>

@property (nonatomic, strong) NSMutableArray *phoneNumbers;
@property (nonatomic, strong) NSMutableArray *markTypes;

@property (nonatomic, strong) UIActionSheet *sheet;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;


@end

@implementation HMarkHistoryController

#pragma mark - LifeCyle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_button"] style:UIBarButtonItemStyleDone target:self action:@selector(backAction:)];
    backItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = backItem;

   
    _phoneNumbers = [NSMutableArray array];
    _markTypes = [NSMutableArray array];
    _sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
    [self initDatasource];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews {
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
                                        forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}
#pragma mark - Private
- (void)backAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)initDatasource {
   
    [HVcardImporter CheckAddressBookAuthorization:^(bool isAuthorized) {
        if (isAuthorized) {
            HVcardImporter *importer = [[HVcardImporter alloc] init];
            NSDictionary *markDic = [importer getMarkedHistoricalData];
            self.phoneNumbers = [markDic objectForKey:@"phoneNumbers"];
            self.markTypes = [markDic objectForKey:@"labels"];

        }else {
            //TODO: 标记历史页的通讯录权限获取。
            UIAlertView * alart = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请您设置允许APP访问您的通讯录\n设置>隐私>通讯录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alart show];
        }
    }];
    
}
#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self.phoneNumbers removeObjectAtIndex:self.selectedIndexPath.row + 1];
        [self.markTypes removeObjectAtIndex:self.selectedIndexPath.row + 1];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
            HVcardImporter *importer = [[HVcardImporter alloc] init];
            [importer updateMarkedContactsWithIndexPath:self.selectedIndexPath];
            
            
            
        });
        
        

        
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.phoneNumbers.count - 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HMarkHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HMarkHistoryCell" forIndexPath:indexPath];
    [cell setupCellWith:self.phoneNumbers[indexPath.row + 1] markType:self.markTypes[indexPath.row + 1]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    self.selectedIndexPath = indexPath;
    [self.sheet showInView:self.tableView];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
