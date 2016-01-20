//
//  ECAppRecommendVC.m
//  KECallsAttribution
//
//  Created by 赵 进喜 on 14-10-28.
//  Copyright (c) 2014年 K.BLOCK. All rights reserved.
//

#import "ECAppRecommendVC.h"
#import <StoreKit/StoreKit.h>
@interface ECAppRecommendVC ()<SKStoreProductViewControllerDelegate>
{

    NSArray *urlArray;

}
@end

@implementation ECAppRecommendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
  
    urlArray=@[@{@"title":@"全民切水果",@"detail":@"2014最具视觉冲击的游戏2014最具视觉冲击的游戏2014最具视觉冲击的游戏2014最具视觉冲击的游戏2014最具视觉冲击的游戏2014最具视觉冲击的游戏",@"icon":@"1",@"appid":@"858988471"},@{@"title":@"全民切水果",@"detail":@"2014最具视觉冲击的游戏",@"icon":@"1",@"appid":@"858988471"},@{@"title":@"全民切水果",@"detail":@"2014最具视觉冲击的游戏",@"icon":@"1",@"appid":@"858988471"},@{@"title":@"全民切水果",@"detail":@"2014最具视觉冲击的游戏",@"icon":@"1",@"appid":@"858988471"},@{@"title":@"全民切水果",@"detail":@"2014最具视觉冲击的游戏",@"icon":@"1",@"appid":@"858988471"},@{@"title":@"全民切水果",@"detail":@"2014最具视觉冲击的游戏",@"icon":@"1",@"appid":@"858988471"}];
    
    
    
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return urlArray.count;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{


    return 80;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identify=@"Cell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identify];
    
    
    
    if (cell==nil) {
        
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
        
        
        cell.accessoryType=UITableViewCellAccessoryDetailButton;
        
        
        
        
    }
    
    
    
    
    UIButton *install=[UIButton buttonWithType:UIButtonTypeCustom];
    
    install.frame=CGRectMake(0, 0, 46, 26);
    
    [install setBackgroundImage:[UIImage imageNamed:@"installButton"] forState:UIControlStateNormal];
    [install addTarget:self action:@selector(touchInstallButton:Event:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView=install;
    
    
    
    cell.imageView.image=[UIImage imageNamed:urlArray[indexPath.row][@"icon"]];
    
    cell.textLabel.text=[NSString stringWithFormat:@"%@",urlArray[indexPath.row][@"title"]];
    cell.textLabel.numberOfLines=2;

    
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",urlArray[indexPath.row][@"detail"]];
    cell.detailTextLabel.numberOfLines=3;
    [cell.detailTextLabel setTextColor:[UIColor grayColor]];
 

    
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
  
    
        
        SKStoreProductViewController *storeController = [[SKStoreProductViewController alloc] init];
        storeController.delegate = self;
    

       [self presentViewController:storeController animated:YES completion:nil];
    
        NSDictionary *productParameters = @{ SKStoreProductParameterITunesItemIdentifier : urlArray[indexPath.row][@"appid"] };
        
        
        [storeController loadProductWithParameters:productParameters completionBlock:^(BOOL result, NSError *error)
         {
             if (result)
             {
                
             }
             else
             {
                 //Warning
                 
                              }
         }];



    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];


}

-(void)touchInstallButton:(UIButton *)sender Event:(UIEvent *)event
{

    NSSet *touches=[event allTouches];
    
    UITouch *touch=[touches anyObject];
    
    
    CGPoint point=[touch locationInView:self.tableView];
    
    
    NSIndexPath *indexPath=[self.tableView indexPathForRowAtPoint:point];
    
    
    
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];



}

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
-(void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{

    [viewController dismissViewControllerAnimated:YES completion:nil];

}
- (IBAction)backButtonPressed:(UIButton *)sender {
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
