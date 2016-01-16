//
//  ECLocalLifeViewController.m
//  KECallsAttribution
//
//  Created by 赵 进喜 on 14-8-18.
//  Copyright (c) 2014年 K.BLOCK. All rights reserved.
//

#import "ECLocalLifeViewController.h"
#import "BusinessCell.h"
#import "MJRefresh.h"
#import "ECLocalDetailTableViewController.h"

@interface ECLocalLifeViewController ()

@end

@implementation ECLocalLifeViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc
{
    [mEngine closeAllConnections];
    mEngine=nil;
    
    [SVProgressHUD dismiss];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BusinessCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
    
    

    
    mPage=1;
    mEngine=[[MyNetEngine alloc]initWithDelegate:self];
    
    mItems=[NSMutableArray array];
    
    
    
    [self setRefresh];
    
    [self reloadData];
    // Do any additional setup after loading the view.
}
-(void)setRefresh
{
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];

}
-(void)reloadData
{

    mPage=1;
    
    [mEngine searchBusinessWithCity:self.cityName Query:_searchKeyword Category:_category Type:type Lng:_mlng Lat:_mlat Page:mPage];
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    
    [self.view endEditing:YES];


}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    

    mPage=1;
    
    [mEngine searchBusinessWithCity:self.cityName Query:_searchKeyword Category:_category Type:type Lng:_mlng Lat:_mlat Page:mPage];
    
     [SVProgressHUD showWithStatus:@"正在加载..."];
    
    [self.view endEditing:YES];

    return YES;
}

-(void)getDataWithLng:(double)lng Lat:(double)lat City:(NSString *)city
{

    [SVProgressHUD showWithStatus:@"正在加载..."];

    mPage=1;
    
    // [mEngine searchBusinessWithCity:self.cityName Query:_searchKeyword Category:_category Type:type Lng:mlng Lat:mlat Page:mPage];

}


- (void)footerRereshing
{
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    
    mPage++;
    
  
    
     [mEngine searchBusinessWithCity:self.cityName Query:_searchKeyword Category:_category Type:type Lng:_mlng Lat:_mlat Page:mPage];
    
}



-(void)onItemsReceived:(NSDictionary *)item
{
     [SVProgressHUD dismiss];
    
    

    if (mPage==1) {
        
        
        [mItems removeAllObjects];
        self.tableView.contentOffset=CGPointMake(0, 0);
    }else
    {
    
        [self.tableView footerEndRefreshing];
    }
    
    
    if ([[item objectForKey:@"status"] isEqualToString:@"OK"]) {
        
        
        NSMutableArray *items=[item objectForKey:@"businesses"];
                        
        [mItems addObjectsFromArray:items];
        
        
       

        
    }
    
     [self.tableView reloadData];
    
   

   
}
-(void)onRequestFailed:(NSError *)error
{

     [SVProgressHUD dismiss];
    [self.tableView footerEndRefreshing];

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 160;

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return mItems.count;


}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *identify=@"Cell";
    BusinessCell *cell=[tableView dequeueReusableCellWithIdentifier:identify];
    
//    if (cell==nil) {
//        cell=(BusinessCell*)[[[NSBundle mainBundle]loadNibNamed:@"BusinessCell" owner:nil options:nil] lastObject];
//    
//    }
    
    NSDictionary *item=[mItems objectAtIndex:indexPath.row];
    
    
    [cell setInfo:item];
    
    
    return cell;
    

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    ECLocalDetailTableViewController *detail=[self.storyboard instantiateViewControllerWithIdentifier:@"ECLocalDetailTableViewController"];
    
    
    detail.mItem=[mItems objectAtIndex:indexPath.row];
    
    
    [self.navigationController pushViewController:detail animated:YES];


    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    [self.view endEditing:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backPressed:(UIButton *)sender {
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (IBAction)selectType:(UIButton *)sender {
    
    
    type=sender.tag-1;
    
    
    
    
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.selectedTypeImage.frame=sender.frame;
    }];
    
    [self reloadData];

}

- (IBAction)changeType:(UIButton *)sender {
    
    
    UIButton *button=(UIButton *)[self.typeView viewWithTag:sender.tag-10];
    
    [self selectType:button];
    
}

@end
