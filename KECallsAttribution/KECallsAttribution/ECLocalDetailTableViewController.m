//
//  ECLocalDetailTableViewController.m
//  KECallsAttribution
//
//  Created by 赵 进喜 on 14-8-19.
//  Copyright (c) 2014年 K.BLOCK. All rights reserved.
//

#import "ECLocalDetailTableViewController.h"
#import "UIImageView+WebCache.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <AddressBook/AddressBook.h>
#import "ECWebViewController.h"
@interface ECLocalDetailTableViewController ()

@end

@implementation ECLocalDetailTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
//    UIImageView *bg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_page_bg"]];
//    
//    [self.tableView setBackgroundView:bg];

    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    
    listItems=[NSMutableArray array];
    
    
    
    
    NSArray *categoroes=[_mItem objectForKey:@"categories"];
    
    if (categoroes.count>0) {
        
        NSString *category=[categoroes objectAtIndex:0];
        
        for (int i=1; i<categoroes.count; i++) {
            
            
            category=[NSString stringWithFormat:@"%@/%@",category,[categoroes objectAtIndex:i]];
            
        }

        self.catLbl.text=category;
        
    }
    
    
    
    
    
    self.nameLbl.text=[_mItem objectForKey:@"name"];
    
    self.costLbl.text=[[_mItem objectForKey:@"avg_price"] stringValue];
    
//    self.phoneNum.text=[_mItem objectForKey:@"telephone"];
//    
//    self.address.text=[_mItem objectForKey:@"address"];
    
    self.desc.text=[_mItem objectForKey:@"desc"];
    
    self.rateView.scorePercent=[[_mItem objectForKey:@"avg_rating"] floatValue]/5;
    
    self.productLbl.text=[[_mItem objectForKey:@"product_score"]stringValue];
    self.decorationLbl.text=[[_mItem objectForKey:@"decoration_score"]stringValue];
    
    self.serviceLbl.text=[[_mItem objectForKey:@"service_score"]stringValue];
    
    self.reviewLbl.text=[NSString stringWithFormat:@"%@条评论",[[_mItem objectForKey:@"review_count"]stringValue]];
    
    
    NSString *url=[_mItem objectForKey:@"photo_url"];
    
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"nopic"]];
    
    
    
    
    
    
    BOOL tuan=[[_mItem objectForKey:@"has_deal"] boolValue];
    
    
    
    
    BOOL  youhui=[[_mItem objectForKey:@"has_coupon"] boolValue];
    
    
    BOOL yuding =[[_mItem objectForKey:@"has_online_reservation"] boolValue];
    
    
    if (tuan) {
        
        NSDictionary *dic=@{@"icon": @"gr_store_groupon",@"title":[[[_mItem objectForKey:@"deals"]objectAtIndex:0] objectForKey:@"description"],@"url":[[[_mItem objectForKey:@"deals"]objectAtIndex:0] objectForKey:@"url"]};
        
        [listItems addObject:dic];
    }
    
    if (youhui) {
        
        NSDictionary *dic=@{@"icon": @"gr_store_coupon",@"title":[_mItem objectForKey:@"coupon_description"],@"url":[_mItem objectForKey:@"coupon_url"]};
        
        [listItems addObject:dic];

        
    }
    
    if (yuding) {
        
        
        NSDictionary *dic=@{@"icon": @"gr_store_reserve",@"title":@"在线预订",@"url":[_mItem objectForKey:@"online_reservation_url"]};
        
        [listItems addObject:dic];

        
    }
    
    NSLog(@"________%@",listItems);

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==2+listItems.count) {
        return 0.1;
    }
    
    return 60;

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return 2+listItems.count+1;//防止最后一行分割线条消失
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{


    if (indexPath.row==0) {
        
        
        UIActionSheet *tel=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil
    otherButtonTitles:[NSString stringWithFormat:@"拨打 %@",[_mItem objectForKey:@"telephone"]], nil];
        tel.tag=1;
        
        [tel showInView:self.view];
        
    }else if(indexPath.row==1)
    {
    
        UIActionSheet *map=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil
                                             otherButtonTitles:@"使用地图打开", nil];
        
        [map showInView:self.view];

        map.tag=2;
    }
    else if (indexPath.row==2+listItems.count)
    {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//防止最后一行线条不显示，多添加一行
    }
    else
        {
    
        ECWebViewController *web=[self.storyboard instantiateViewControllerWithIdentifier:@"ECWebViewController"];
        
        NSDictionary *dic=[listItems objectAtIndex:indexPath.row-2];
        
        
        web.strUrl=[dic objectForKey:@"url"];
        
        
        
        [self.navigationController pushViewController:web animated:YES];
    
    
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (actionSheet.tag==1) {
        
        if (buttonIndex==0) {
            
//            NSString *url=[NSString stringWithFormat:@"tel://%@",self.phoneNum.text];
//            
//            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
            NSURL * telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",[_mItem objectForKey:@"telephone"]]];
            UIWebView*callWebview =[[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
            [self.view addSubview:callWebview];


        }
        
        
    }else
    {
    
        if (buttonIndex==0) {
            
            
            
//                 NSString *source=@"来电归属地助手";
//                 NSString *urlOfSource = [source stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                 
//                 NSString *url=[NSString stringWithFormat:@"map://navi?sourceApplication=%@&backScheme=laidianguishudi&lat=%@&lon=%@&dev=1&style=0&key=a24ac3c3d62dc35466864374b0033eb1",urlOfSource,[_mItem objectForKey:@"lat"],[_mItem objectForKey:@"lng"]];
//                 
//                 
//                 
//                 
//                 
//                 [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
            
            
            NSDictionary *addressDict = @{(NSString*)kABPersonAddressStreetKey : [_mItem objectForKey:@"address"]};
            
            CLLocationCoordinate2D endCoor = CLLocationCoordinate2DMake([[_mItem objectForKey:@"latitude"]doubleValue],[[_mItem objectForKey:@"longitude"] doubleValue]);
            
//            MKCoordinateSpan span=MKCoordinateSpanMake([[_mItem objectForKey:@"lat"]doubleValue], [[_mItem objectForKey:@"lng"] doubleValue] );
//            NSValue *value=[NSValue valueWithBytes:&span objCType:@encode(MKCoordinateSpan)];
            
            
            
            MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:endCoor addressDictionary:addressDict]];
            toLocation.name = self.nameLbl.text;
       
//           [MKMapItem openMapsWithItems:@[toLocation,currentLocation]
//                           launchOptions:@{MKLaunchOptionsShowsTrafficKey:[NSNumber numberWithBool:YES]}];
            [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, toLocation, nil]
             
                           launchOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving, [NSNumber numberWithBool:YES], nil]
                                          
                                                                     forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]]];
            
            
            
            
            
            
            
            
        }

             
        
            
            
    }
     

}
- (NSString *)URLEncodedString:(NSString *)str
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)str,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              NULL,
                                                              kCFStringEncodingUTF8));
    return encodedString;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identify=@"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell==nil) {
        
        
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        
        
    }
    
    
    UIImageView *icon=[[UIImageView alloc]initWithFrame:CGRectMake(20, 18, 24, 24)];
    
    [cell.contentView addSubview:icon];
    
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(50, 15, SCREEN_WIDTH-40-30, 30)];
    
    [cell.contentView addSubview:title];
    
    
    
    if (indexPath.row==0) {
        icon.image=[UIImage imageNamed:@"gr_store_phone"];
        
        title.text=[_mItem objectForKey:@"telephone"];
        
    }else if (indexPath.row==1)
    {
        icon.image=[UIImage imageNamed:@"gr_store_address"];
        title.text=  [_mItem objectForKey:@"address"];
    
    }else if (indexPath.row==listItems.count+2)
    {
    
    
    }
    
    else
    {
    
        NSDictionary *dic=[listItems objectAtIndex:indexPath.row-2];
        
        
        icon.image=[UIImage imageNamed:[dic objectForKey:@"icon"]];
    
    
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
        title.text=[dic objectForKey:@"title"];
        
        
        
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    // Configure the cell...
    
    return cell;
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

- (IBAction)backButtonPressed:(UIButton *)sender {
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)viewReviews:(UIButton *)sender {
    
    
    ECWebViewController *web=[self.storyboard instantiateViewControllerWithIdentifier:@"ECWebViewController"];
    
    
    
    
    web.strUrl=[_mItem objectForKey:@"review_list_url"];
    
    
    
    [self.navigationController pushViewController:web animated:YES];

    
}
@end
