//
//  EZResultTableVC.m
//  KECallsAttribution
//
//  Created by 赵 进喜 on 14/12/4.
//  Copyright (c) 2014年 K.BLOCK. All rights reserved.
//

#import "EZResultTableVC.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
@interface EZResultTableVC ()

@end

@implementation EZResultTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.tableView setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background"]]];
    
    
    resultHeader=[[ECResultHeaderViewController alloc]initWithNibName:@"ECResultHeaderViewController" bundle:nil];
    self.tableView.tableHeaderView=resultHeader.view;
    mItems=[[NSMutableArray alloc]initWithCapacity:10];
    
    
    [self dealWithCode:_myCode];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void)dealWithCode:(NSString *)strCode
{
    
    
    if ([strCode hasPrefix:@"http"]||[strCode hasPrefix:@"www"]) {
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:strCode]];
        
        
       
        
    }else
    {
        
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        
        NSString *url=[NSString stringWithFormat:@"http://121.199.34.78:82/api/fotoable/%@?key=7f2081f3454b14ac6c3a500f9549abe1",strCode];
        
        
        
        [[AFHTTPRequestOperationManager manager]GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            
            NSLog(@"%@",responseObject);
            
            
            
            [resultHeader setInfo:responseObject];
            
            
            
            mItems=[responseObject objectForKey:@"shops"];
            
            
            
            
            
            
            
            
            
            
            
            
            [self.tableView reloadData];
            
            
            
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
                       
        }];
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identify=@"Cell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell==nil) {
        
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
        
        
    }
    
    
    NSDictionary *dic=[mItems objectAtIndex:indexPath.row];
    
    
    [cell.textLabel setTextColor:[UIColor darkGrayColor]];
    [cell.detailTextLabel setTextColor:[UIColor darkGrayColor]];
    
    cell.textLabel.text=[dic objectForKey:@"shopName"];
    
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@元",[dic objectForKey:@"price"]];
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return mItems.count;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{


 [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
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

- (IBAction)buttonPressed:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
