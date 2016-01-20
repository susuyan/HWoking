//
//  KEUsefulTelephoneNumbersController.m
//  KECallsAttribution
//
//  Created by lichenWang on 14-1-6.
//  Copyright (c) 2014年 KERNEL. All rights reserved.
//

#import "KEUsefulTelephoneNumbersController.h"
#import "KEDetailPhoneNumberViewController.h"
@interface KEUsefulTelephoneNumbersController ()
@property (nonatomic, strong)NSMutableArray * array;
@property (nonatomic, strong)NSDictionary * dictionary;
@end

@implementation KEUsefulTelephoneNumbersController

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
    
    [MobClick beginLogPageView:@"changyongdianhua"];
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"changyongdianhua"];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dictionary = [NSDictionary dictionary];
	NSString* path = [[NSBundle mainBundle] pathForResource:@"PhoneNumberData"
                                                     ofType:@"plist"];
    self.array = [NSMutableArray arrayWithContentsOfFile:path];
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
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    self.dictionary = self.array[indexPath.row];
    cell.textLabel.text = self.dictionary[@"name"];
    return cell;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"DetailPhoneNumber"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        KEDetailPhoneNumberViewController * detailPhoneNumberViewController = segue.destinationViewController;
        detailPhoneNumberViewController.dictionary = self.array[indexPath.row];
    }
}
- (IBAction)back:(UIButton *)sender {
     [self.navigationController popViewControllerAnimated:YES];
}
@end
