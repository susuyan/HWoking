//
//  KEPostCodeDetailController.m
//  KECallsAttribution
//
//  Created by lichenWang on 14-1-8.
//  Copyright (c) 2014年 KERNEL. All rights reserved.
//

#import "KEPostCodeDetailController.h"
#import "KEPostcode.h"
#import "KEPostSearchCell.h"
#import "ChineseToPinyin.h"
@interface KEPostCodeDetailController ()

@end

@implementation KEPostCodeDetailController

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
    [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:@"KEPostSearchCell" bundle:nil] forCellReuseIdentifier:@"searchResultsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"KEPostSearchCell" bundle:nil] forCellReuseIdentifier:@"searchResultsCell"];

    
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
        return self.searchResultsArray.count;
    }else{
        return self.array.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        static NSString *CellIdentifier = @"searchResultsCell";
        KEPostSearchCell *searchCell = [self.searchDisplayController.searchResultsTableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        KEPostcode * post = self.searchResultsArray[indexPath.row];
        searchCell.areaNameLabel.text = post.areaName;
        searchCell.postCodeLabel.text = [NSString stringWithFormat:@"邮编:%@",post.code];;
        return searchCell;
    }else if (tableView == self.tableView){
        
        
        static NSString *CellIdentifier = @"searchResultsCell";
        KEPostSearchCell *searchCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        KEPostcode * post = self.array[indexPath.row];
        searchCell.areaNameLabel.text = post.areaName;
        searchCell.postCodeLabel.text = [NSString stringWithFormat:@"邮编:%@",post.code];;
        return searchCell;

//        static NSString *CellIdentifier = @"Cell";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//        KEPostcode * postcode = self.array[indexPath.row];
//        cell.textLabel.text = postcode.areaName;
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"邮编:%@",postcode.code];
//        return cell;
    }
    return nil;
}
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    NSMutableArray * testArray = [NSMutableArray array];
    [self.array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        KEPostcode * post = obj;
        if ([post.areaName rangeOfString:searchText].location != NSNotFound) {
            [testArray addObject:post];
        }
    }];
    self.searchResultsArray = [NSArray arrayWithArray:testArray];
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
