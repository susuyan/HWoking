//
//  KEInquiryPostCodeController.m
//  KECallsAttribution
//
//  Created by lichenWang on 14-1-7.
//  Copyright (c) 2014年 KERNEL. All rights reserved.
//

#import "KEInquiryPostCodeController.h"
#import "KEPostCodeDetailController.h"
#import "KEPostcode.h"
@interface KEInquiryPostCodeController ()
@property (nonatomic, strong)NSMutableDictionary * dataDictionary;
@end

@implementation KEInquiryPostCodeController

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
    
    [MobClick beginLogPageView:@"youbianchaxun"];
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"youbianchaxun"];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataDictionary = [NSMutableDictionary dictionary];
    [self readPostcode];

}
- (void)readPostcode
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"KEPostcode"
                                                     ofType:@"k"];
    NSData *saveData = [NSData dataWithContentsOfFile:path];
    if (saveData.length) {
        NSKeyedUnarchiver * keyedUnarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:saveData];
        self.dataDictionary = [keyedUnarchiver decodeObjectForKey:@"KEPostcodeForEric"];
        [keyedUnarchiver finishDecoding];
    }
    
    //[self archiverData];
    
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
    return self.dataDictionary.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [self.dataDictionary allKeys][indexPath.row];
    return cell;
}

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PostCode"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        KEPostCodeDetailController * postCodeDetailController = segue.destinationViewController;
        postCodeDetailController.array = [self.dataDictionary allValues][indexPath.row];
        postCodeDetailController.title = [self.dataDictionary allKeys][indexPath.row];
    }
}
- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)archiverData
{


    KEPostcode *post=  self.dataDictionary[@"广东"][62];


    post.areaName=@"雷州市";
    
    
    
    self.dataDictionary[@"广东"][62]=post;
    
    
    
    NSMutableData *data=[[NSMutableData alloc]init];
    
    
   NSKeyedArchiver *arch= [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    
    [arch encodeObject:self.dataDictionary forKey:@"KEPostcodeForEric"];


    [arch finishEncoding];
    
    
    
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    path =[path stringByAppendingPathComponent:@"KEPostcode.k"];
    
    [data writeToFile:path atomically:YES];
    
    

}


@end
