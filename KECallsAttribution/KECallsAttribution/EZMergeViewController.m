//
//  EZMergeViewController.m
//  ContactBackup
//
//  Created by 赵 进喜 on 15/3/19.
//  Copyright (c) 2015年 everzones. All rights reserved.
//

#import "EZMergeViewController.h"
#import "EZMergeCell.h"
#import "MBProgressHUD.h"
static NSString *CellIdentifier = @"contact";

@interface EZMergeViewController ()
{

    MBProgressHUD *autoLoading;


}
@end

@implementation EZMergeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EZMergeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CellIdentifier];
    
    
    self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backHomeAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [_allDic allKeys].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EZMergeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    
    NSString *key=[_allDic allKeys][indexPath.row];
    
    NSArray *array=[_allDic objectForKey:key];

    
    [cell setInfo:@{key:array}];
    
    
    cell.mergeDidFinish=^(NSString *keyName){
    
        [_allDic removeObjectForKey:keyName];
        
        
        
        [self.tableView reloadData];
    
    
    };
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *key=[_allDic allKeys][indexPath.row];
    
    NSArray *array=[_allDic objectForKey:key];
    
    
    
    return array.count*60;



}


- (IBAction)autoMerge:(UIButton *)sender {
    
    
   autoLoading=[MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        
        
        
        [self doAutoMerge];
      
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
            
            
            [_allDic removeAllObjects];
            
            [self.tableView reloadData];
            
            
        });
 
    
    
});



}


-(void)doAutoMerge {


    ABAddressBookRef addressBook=ABAddressBookCreateWithOptions(NULL, NULL);
    
    
    
    
    if (addressBook == nil) {
        return;
    }
    
    
    
    __block BOOL accessGranted = NO;
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        
        
        accessGranted = granted;
        
        
        dispatch_semaphore_signal(sema);
        
        
        
        
    });
    
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    // CFRelease(addressBook);
    
    if (!accessGranted) {
        return;
    }
    
    
    
    
    //所有联系人 begin
    for (int q=0; q<_allDic.allKeys.count; q++) {
        
        
        autoLoading.labelText=[NSString stringWithFormat:@"正在合并：%d/%d",q+1,_allDic.allKeys.count];
        
        
        
        NSArray *allContacts=_allDic[_allDic.allKeys[q]];
        
        
        
        NSMutableDictionary *allNumbers=[NSMutableDictionary dictionaryWithCapacity:10];
        
        
        
        NSData *avatarImage;
        
        
        NSString *firstName;
        
        NSString *lastName;
        
        
        NSString *midName;
        
        
        NSString *company;
        
        
        //同名  begin
        for (int i=0; i<allContacts.count; i++) {
            
            
            
            
            
            ABRecordRef record=(__bridge ABRecordRef)([allContacts objectAtIndex:i]);
            
            
            
            NSData *image = (__bridge NSData*)ABPersonCopyImageData(record);
            
            if (image) {
                avatarImage=image;
            }
            
            
            NSString *first=(__bridge NSString *)(ABRecordCopyValue(record, kABPersonFirstNameProperty));
            
            if (first&&![first isEqualToString:@""]) {
                firstName=first;
            }
            
            NSString *last=(__bridge NSString *)(ABRecordCopyValue(record, kABPersonLastNameProperty));
            
            
            if (last&&![last isEqualToString:@""]) {
                lastName=last;
            }
            
            
            NSString *mid=(__bridge NSString *)(ABRecordCopyValue(record, kABPersonMiddleNameProperty));
            
            
            if (mid&&![mid isEqualToString:@""]) {
                midName=mid;
            }
            
            
            NSString *com=(__bridge NSString *)(ABRecordCopyValue(record, kABPersonOrganizationProperty));
            
            if (com&&![com isEqualToString:@""]) {
                company=com;
            }
            
            
            
            
            //号码标签  begin
            ABMultiValueRef  phones = ABRecordCopyValue(record, kABPersonPhoneProperty);
            int count=(int)ABMultiValueGetCount(phones);
            
            
            for (int j=0; j<count; j++) {
                
                
                
                CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(phones, j);
                NSString * phoneNumber = (__bridge NSString *)phoneNumberRef;
                
                
                NSString *label=(__bridge NSString *)(ABMultiValueCopyLabelAtIndex(phones, j));
                
                
                [allNumbers setObject:label forKey:phoneNumber];
                
                
            }
            //号码标签  end
            
            
        }
        //同名  end
        
        
        ABRecordRef record=ABPersonCreate();
        
        
        
        
        
        ABMutableMultiValueRef multiValue = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
        CFErrorRef error = NULL;
        multiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        
        
        
        
        //添加号码和标签
        for (int i=0; i<allNumbers.allKeys.count; i++) {
            
            
            NSString *number=allNumbers.allKeys[i];
            NSString *label=allNumbers[number];
            
            
            ABMultiValueAddValueAndLabel(multiValue, (__bridge CFTypeRef)(number), (__bridge CFStringRef)(label), NULL);
            
        }
        
        
        
        ABRecordSetValue(record, kABPersonPhoneProperty, multiValue , &error);
        
        
        ABRecordSetValue(record, kABPersonFirstNameProperty, (__bridge CFTypeRef)(firstName), NULL);
        ABRecordSetValue(record, kABPersonLastNameProperty, (__bridge CFTypeRef)(lastName), NULL);
        ABRecordSetValue(record, kABPersonOrganizationProperty, (__bridge CFTypeRef)(company), NULL);
        ABRecordSetValue(record, kABPersonMiddleNameProperty, (__bridge CFTypeRef)(midName), NULL);
        
        
        ABPersonSetImageData(record, (__bridge CFDataRef)(avatarImage), NULL);
        //保存新生成的联系人
        ABAddressBookAddRecord(addressBook, record, NULL);
        
        
        //移除之前的联系人
        for (int i=0; i<allContacts.count; i++) {
            
            
            ABRecordRef mRecord=(__bridge ABRecordRef)([allContacts objectAtIndex:i]);
            
            
            ABAddressBookRemoveRecord(addressBook, mRecord, NULL);
            
            
            
        }
        
        
        ABAddressBookSave(addressBook, NULL);
        
        
        
    }
    
    
    ABAddressBookSave(addressBook, NULL);
    
    CFRelease(addressBook);
    
    //所有联系人 end
    



}

@end
