//
//  ECCheaterVC.m
//  KECallsAttribution
//
//  Created by 赵 进喜 on 14/12/18.
//  Copyright (c) 2014年 K.BLOCK. All rights reserved.
//

#import "ECCheaterVC.h"
#import "ECCheaterCell.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import<MessageUI/MFMailComposeViewController.h>
#import "MobClick.h"
#import "NSString+ContainsMethod.h"
@interface ECCheaterVC ()<MFMailComposeViewControllerDelegate>
@property(strong,nonatomic)ECCheaterCell *currentCell;
@property(nonatomic,strong)ECCheaterCell *tempCell;
@end

@implementation ECCheaterVC
-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"haomabaoguang"];


}
-(void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"haomabaoguang"];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"ECCheaterCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:@"ECCheaterCell" bundle:nil] forCellReuseIdentifier:@"result"];

    
    
    _currentCell=[self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    _tempCell = [[ECCheaterCell alloc] init];
    
    [self setRefresh];
    
    mPage=1;
    
    mItems=[NSMutableArray array];
    
    resultArray=[NSMutableArray array];
    
    self.tableView.allowsSelection=NO;
    self.searchDisplayController.searchResultsTableView.allowsSelection=NO;
    
    
    self.tableView.estimatedRowHeight = 105;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.searchDisplayController.searchResultsTableView.estimatedRowHeight=105;
    self.searchDisplayController.searchResultsTableView.rowHeight=UITableViewAutomaticDimension;
    
    
    [self reloadData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



-(void)setRefresh {
    
    [self.tableView addHeaderWithTarget:self action:@selector(reloadData)];
    
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    
    
}
-(void)reloadData {
    
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    mPage=1;
    [self.view endEditing:YES];
    
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers]];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html", nil];

    
    
    [manager GET:[NSString stringWithFormat:@"http://www.93app.com/laidianguishu/get_report_number_list.php?ucode=%@&version=%@&page=%d",UID,VERSION,mPage] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self onItemsReceived:responseObject];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD dismiss];
        
        self.tableView.contentOffset=CGPointMake(0, 0);
        [self.tableView headerEndRefreshing];
    }];
    
}
- (void)footerRereshing {
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    
    mPage++;
    
    
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers]];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html", nil];

    
    
    [manager GET:[NSString stringWithFormat:@"http://www.93app.com/laidianguishu/get_report_number_list.php?ucode=%@&version=%@&page=%d",UID,VERSION,mPage] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self onItemsReceived:responseObject];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD dismiss];
        
        [self.tableView footerEndRefreshing];
        
    }];

    
    
}

-(void)onItemsReceived:(NSDictionary *)item {
    [SVProgressHUD dismiss];
    
    
    if (mPage==1) {
        
        [mItems removeAllObjects];
        [self.tableView headerEndRefreshing];
        self.tableView.contentOffset=CGPointMake(0, 0);
    }else {
        
        [self.tableView footerEndRefreshing];
    }
    
    
    if ([[item objectForKey:@"status"]intValue]==1) {
        
        
        NSMutableArray *items=[item objectForKey:@"report_number_info_list"];
        
        [mItems addObjectsFromArray:items];
        
    }
    
    [self.tableView reloadData];
    
    
    
    
}

-(void)onSearch:(NSDictionary *)item {
    
    
    [resultArray removeAllObjects];
    

    [SVProgressHUD dismiss];



    if ([[item objectForKey:@"status"]intValue]==1) {
        
        
        NSMutableArray *items=[item objectForKey:@"report_list"];
        
        [resultArray addObjectsFromArray:items];
        
        
        
        
        
    }
    
    [self.searchDisplayController.searchResultsTableView reloadData];





}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    
    
    if (tableView==self.tableView) {
        return mItems.count;
    }else if (tableView==self.searchDisplayController.searchResultsTableView) {
    
        return resultArray.count;
    
    }
    
    
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    ECCheaterCell *cell;
    
    
    if (tableView==self.tableView) {
        
        cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        
        NSDictionary *info=[mItems objectAtIndex:indexPath.row];
        
        
        [cell setInfo:info];
        
        
        
        
    }else if (tableView == self.searchDisplayController.searchResultsTableView) {
    
        cell=[tableView dequeueReusableCellWithIdentifier:@"result"];
        NSDictionary *info=[resultArray objectAtIndex:indexPath.row];
        
        [cell setInfo:info];

    
    }
    
        
//    cell.touchBlock=^(NSString *telNum){
//    
//    
//    
//    
//    
//    
//    
//    
//    };
//      

    
    
    return cell;


}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ECCheaterCell *cell=(ECCheaterCell *)self.currentCell;
    
    NSDictionary *info=[mItems objectAtIndex:indexPath.row];
    
    int height=[ECCheaterCell getCellHeightWith:[info objectForKey:@"detail"] font:cell.detailLbl.font width:cell.detailLbl.frame.size.width];
    
    return height+10;
    
}



//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    
//    if (tableView==self.tableView) {
//        
//        _tempCell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
//        NSDictionary *info=[mItems objectAtIndex:indexPath.row];
//
//        
//        [_tempCell setInfo:info];
//        
//        
//        
//    }else if (tableView == self.searchDisplayController.searchResultsTableView) {
//        
//        _tempCell =[tableView dequeueReusableCellWithIdentifier:@"result"];
//        NSDictionary *info=[resultArray objectAtIndex:indexPath.row];
//        
//        
//        [_tempCell setInfo:info];
//        
//        
//    }
//    
//    CGFloat height = [_tempCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//    height += 1;
//    return height;
//}


//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    return  UITableViewAutomaticDimension;
//
//}


//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    ECCheaterCell *cell=(ECCheaterCell *)self.currentCell;
////    cell.detailLbl.text=@"hasdfahkhfkdahkfhakhdfkadhkhkhkhfkbksbcvjkbcjbbkbvckbvkbkvkvhhkvhkahvkahvkahkvhakhvakhakvhkahvkhakhvkhkv";
////    
////    
////    [cell.detailLbl sizeToFit];
////    
////        [cell.contentView updateConstraints];
////        [cell.contentView setNeedsLayout];
////        [cell.contentView layoutIfNeeded];
////
////    
////    
////    [cell.contentView setNeedsLayout];
////    
////    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
////
////    return height+1;
//
//  //  return 200;
//       int height=[ECCheaterCell getCellHeightWith:@"hasdfahkhfkdahkfhakhdfkadhkhkhkhfkbksbcvjkbcjbbkbvckbvkbkvkvhhkvhkahvkahvkahkvhakhvakhakvhkahvkhakhvkhkv" font:cell.detailLbl.font width:cell.detailLbl.frame.size.width];
//    
//    return height;
//
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
////    ECCheaterCell *cell=(ECCheaterCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
////    
////    [cell.contentView setNeedsLayout];
////    [cell.contentView layoutIfNeeded];
////    
////    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//    
//    
//    
//    
//    return height;
//
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)reportNumber:(UIButton *)sender {
    
    [self showMailPicker:nil];
    
}

- (IBAction)backButtonPressed:(UIButton *)sender {
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
- (void)showMailPicker:(id)sender {
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil){
        // We must always check whether the current device is configured for sending emails
        if ([mailClass canSendMail]){
            [self displayComposerSheet];
        }else{
            [self launchMailAppOnDevice];
        }
    }else{
        [self launchMailAppOnDevice];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)launchMailAppOnDevice {
    
}
-(void)displayComposerSheet {
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    [picker setToRecipients:[NSArray arrayWithObject:@"support@93app.com"]];
    [picker setSubject:@"号码举报-手机归属地"];
    picker.title = @"号码举报";
    //[picker setMessageBody:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"] isHTML:NO];
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {

    
    if ([self.searchBar.text containsString:@"-"]) {
        self.searchBar.text=[self.searchBar.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    
    
    
    if (![self isMobileNumber:self.searchBar.text]) {
        
        
        [SVProgressHUD showErrorWithStatus:@"号码格式不正确"];
        
        
        
        return;
    }


    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers]];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html", nil];
    
    [manager GET:[NSString stringWithFormat:@"http://www.93app.com/laidianguishu/get_a_report_number_info_list.php?ucode=%@&version=%@&number=%@",UID,VERSION,self.searchBar.text] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self onSearch:responseObject];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD dismiss];
        
        self.tableView.contentOffset=CGPointMake(0, 0);
        [self.tableView headerEndRefreshing];
    }];

    
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {



    [resultArray removeAllObjects];



}



//判断是不是电话号码

- (BOOL)isMobileNumber:(NSString *)mobileNum {
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,181
     22         */
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
     NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];

    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)
        || ([regextestphs evaluateWithObject:mobileNum] == YES)){
        return YES;
    }
    else {
        return NO;
    }
}
@end
