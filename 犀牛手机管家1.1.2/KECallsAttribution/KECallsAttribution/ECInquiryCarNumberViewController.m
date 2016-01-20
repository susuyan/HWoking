//
//  ECInquiryCarNumberViewController.m
//  KECallsAttribution
//
//  Created by 赵 进喜 on 14-5-20.
//  Copyright (c) 2014年 K.BLOCK. All rights reserved.
//

#import "ECInquiryCarNumberViewController.h"
#import "ECCarCode.h"
#import <sqlite3.h>
#import "ECCarCodeSearchCell.h"
@interface ECInquiryCarNumberViewController ()

@end

@implementation ECInquiryCarNumberViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    
    
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"chepai"];
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"chepai"];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:@"ECCarCodeSearchCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"result"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ECCarCodeSearchCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];

    
    _allArray=[NSMutableArray arrayWithCapacity:10];
    _searchResultArray=[NSMutableArray arrayWithCapacity:10];
    
    
    NSString *provincePath=[[NSBundle mainBundle]pathForResource:@"cityprovince" ofType:@"plist"];
    
    _provinceDic=[[NSDictionary alloc]initWithContentsOfFile:provincePath];
    
    [self initAllData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)initAllData
{

    NSString *databaseFilePath=[[NSBundle mainBundle]pathForResource:@"car_post" ofType:@"db"];
    
    NSString *query=@"SELECT * FROM chepai";
    
    sqlite3 *database;
    if (sqlite3_open([databaseFilePath UTF8String], &database)
        != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"打开数据库失败！");
    }
    //执行查询
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement,nil) == SQLITE_OK) {
       // sqlite3_bind_text(statement, 1, [string UTF8String], -1, NULL);
        //依次读取数据库表格FIELDS中每行的内容，并显示在对应的TextField
        while (sqlite3_step(statement) == SQLITE_ROW) {
            //获得数据
            char *code = (char *)sqlite3_column_text(statement, 0);
            char *city = (char *)sqlite3_column_text(statement, 1);
            int idx=sqlite3_column_int(statement, 2);
           // self.successful = YES;
            //更新View
            
            ECCarCode *mCode=[[ECCarCode alloc]init];
            mCode.cityName=[NSString stringWithUTF8String:city];
            mCode.carCode=[NSString stringWithUTF8String:code];
            mCode.idx=idx;
            [self.allArray addObject:mCode];
         
            
            
        }
        sqlite3_finalize(statement);
    }    //关闭数据库
    sqlite3_close(database);

    [self.tableView reloadData];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.searchResultArray.count;
    }else{
        return self.allArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.tableView) {
        
        static NSString *identify=@"cell";
        ECCarCodeSearchCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
        // Configure the cell...
        ECCarCode *code=[self.allArray objectAtIndex:indexPath.row];
        
        NSString *province=[_provinceDic objectForKey:[NSString stringWithFormat:@"%d",code.idx]];
        
        if (province) {
            
            
             cell.cityLbl.text=[NSString stringWithFormat:@"(%@)%@",province,code.cityName];
        }else
        {
        
            cell.cityLbl.text=code.cityName;
        
        }
        
       
        cell.codeLbl.text=code.carCode;
        
        return cell;

        
    }else if (tableView==self.searchDisplayController.searchResultsTableView)
    {
        static NSString *identify=@"result";
        ECCarCodeSearchCell *cell = [self.searchDisplayController.searchResultsTableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
        
        ECCarCode *code=[self.searchResultArray objectAtIndex:indexPath.row];
        
        NSString *province=[_provinceDic objectForKey:[NSString stringWithFormat:@"%d",code.idx]];
        
        if (province) {
            
            
            cell.cityLbl.text=[NSString stringWithFormat:@"(%@)%@",province,code.cityName];
        }else
        {
            
            cell.cityLbl.text=code.cityName;
            
        }
        
        
        cell.codeLbl.text=code.carCode;
        
        return cell;

    
    }

    
    return nil;
    
   }


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    NSMutableArray * testArray = [NSMutableArray array];
    [self.allArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ECCarCode * code = obj;
        if ([code.cityName rangeOfString:searchText].location != NSNotFound) {
            [testArray addObject:code];
        }else if ([code.carCode rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
        
            [testArray addObject:code];
        
        }
    }];
    self.searchResultArray = [NSMutableArray arrayWithArray:testArray];
}
-(BOOL)searchDisplayController:(UISearchDisplayController*)controller shouldReloadTableForSearchString:(NSString *)searchString {
    NSString * string = [self.searchDisplayController.searchBar scopeButtonTitles][self.searchDisplayController.searchBar.selectedScopeButtonIndex];
    [self filterContentForSearchText:searchString scope:string];
    return YES;
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    NSString * string = self.searchDisplayController.searchBar.scopeButtonTitles[searchOption];
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:string];
    return YES;
}

- (IBAction)back:(UIButton *)sender {
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
@end
