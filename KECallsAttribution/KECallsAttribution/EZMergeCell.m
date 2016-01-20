//
//  EZMergeCell.m
//  ContactBackup
//
//  Created by 赵 进喜 on 15/3/19.
//  Copyright (c) 2015年 everzones. All rights reserved.
//

#import "EZMergeCell.h"
#import <AddressBook/AddressBook.h>
#import "EZMoreCell.h"
#import "MBProgressHUD.h"
#import "ECPersonHelper.h"
@implementation EZMergeCell
- (void)awakeFromNib {
    // Initialization code
    
    
    [_moreTableView registerNib:[UINib nibWithNibName:@"EZMoreCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"more"];
    
    self.moreTableView.delegate=self;
    
    
    self.moreTableView.dataSource=self;
    
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 60;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;


}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return allContacts.count;


}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    EZMoreCell *cell=[_moreTableView dequeueReusableCellWithIdentifier:@"more"];
    
    
//    if (cell==nil) {
//        
//        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"more"];
//        
//       
//    }
//    
    
    
    
    cell.nameLabel.text=nil;
    
    int imageID=[[ECPersonHelper sharePersonHelper] getDefaultHeadImageIdWithIndex:indexPath.row];
    
    cell.headImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"people_%d",imageID]];
    cell.numberLabel.text=nil;
    avatarImage=nil;
    firstName=nil;
    lastName=nil;
    company=nil;
    midName=nil;
    
    
    
    
    ABRecordRef record=(__bridge ABRecordRef)([allContacts objectAtIndex:indexPath.row]);
    
    
    CFStringRef compositeNameRef = ABRecordCopyCompositeName(record);
    NSString * compositeName = (__bridge NSString *)(ABRecordCopyCompositeName(record));
    
    compositeNameRef != NULL ? CFRelease(compositeNameRef) : NULL;
    
    cell.nameLabel.text=compositeName;
    
    
    
     NSData *image = (__bridge NSData*)ABPersonCopyImageData(record);
    if (image) {
          cell.headImage.image=[UIImage imageWithData:image];
        
        
    }
  
    
    
    
    ABMultiValueRef  phones = ABRecordCopyValue(record, kABPersonPhoneProperty);
    int count=(int)ABMultiValueGetCount(phones);
    
        
    
    if (count>0) {
        CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(phones, 0);
        NSString * phoneNumber = (__bridge NSString *)phoneNumberRef;

        cell.numberLabel.text=[NSString stringWithFormat:@"%@(%d个号码)",phoneNumber,count];
        
    }
    
    
    return cell;

}
-(void)setInfo:(NSDictionary *)info
{

    keyName=[info allKeys][0];
    
    allContacts=info[keyName];
    
    
    

    [_moreTableView reloadData];


}

- (IBAction)mergeContacts:(UIButton *)sender {
    
    
    
    
    NSMutableDictionary *allNumbers=[NSMutableDictionary dictionaryWithCapacity:10];
    
    
    
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

        
        
        
        
        ABMultiValueRef  phones = ABRecordCopyValue(record, kABPersonPhoneProperty);
        int count=(int)ABMultiValueGetCount(phones);
        
    
        for (int j=0; j<count; j++) {
            
            
            
            CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(phones, j);
            NSString * phoneNumber = (__bridge NSString *)phoneNumberRef;

            
             NSString *label=(__bridge NSString *)(ABMultiValueCopyLabelAtIndex(phones, j));
            
            
            [allNumbers setObject:label forKey:phoneNumber];
            
            
        }
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    [self addNewPersonWithAllNumbers:allNumbers];
    
    
    
    
    
}



//新建联系人
-(void)addNewPersonWithAllNumbers:(NSDictionary *)nameDic
{
    
    
    
    ABRecordRef record=ABPersonCreate();
    
    
    
    

    ABMutableMultiValueRef multiValue = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
    CFErrorRef error = NULL;
    multiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    
   
    
    
    //添加号码和标签
    for (int i=0; i<nameDic.allKeys.count; i++) {
        
        
        NSString *number=nameDic.allKeys[i];
        NSString *label=nameDic[number];
        
        
       ABMultiValueAddValueAndLabel(multiValue, (__bridge CFTypeRef)(number), (__bridge CFStringRef)(label), NULL);
        
    }
    
    
    
     ABRecordSetValue(record, kABPersonPhoneProperty, multiValue , &error);
    
    
    
    
    
    
    
    ABRecordSetValue(record, kABPersonFirstNameProperty, (__bridge CFTypeRef)(firstName), NULL);
    ABRecordSetValue(record, kABPersonLastNameProperty, (__bridge CFTypeRef)(lastName), NULL);
    ABRecordSetValue(record, kABPersonOrganizationProperty, (__bridge CFTypeRef)(company), NULL);
    ABRecordSetValue(record, kABPersonMiddleNameProperty, (__bridge CFTypeRef)(midName), NULL);

    
    ABPersonSetImageData(record, (__bridge CFDataRef)(avatarImage), NULL);
    
    
    
    ABNewPersonViewController *new=[[ABNewPersonViewController alloc]init];
    
    
    new.newPersonViewDelegate=self;
    
    
  
    
    
    new.displayedPerson=record;
    
   
    
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:new];
    
    
    UIViewController *root=[self getLast];
    
    
    [root presentViewController:nav animated:YES completion:nil];
    
    
//    [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
    
    
    
    
}



//新建联系人，添加到已有联系人
- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person
{
    
    
    if (person!=nil) {
        
        
        [MBProgressHUD showHUDAddedTo:newPersonView.view animated:YES];
        
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            
            
           
            
            
             ABAddressBookRef addressBook=ABAddressBookCreateWithOptions(NULL, NULL);
            
            
            for (int i=0; i<allContacts.count; i++) {
                
                
                ABRecordRef record=(__bridge ABRecordRef)([allContacts objectAtIndex:i]);
                
                
                ABAddressBookRemoveRecord(addressBook, record, NULL);
                
                
            
            }
            
           
            ABAddressBookSave(addressBook, NULL);
            
            
            CFRelease(addressBook);
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                
                _mergeDidFinish(keyName);
                
                
                [MBProgressHUD hideAllHUDsForView:newPersonView.view animated:YES];
                
                
                
                
            });
        });
        
        
        
        
        
        
        
    }
    
    [newPersonView dismissViewControllerAnimated:YES completion:^{
    
    
    
   // _mergeDidFinish(self.co)
    
    
    
    }];
    
}

-(UIViewController *)getLast
{


    for (UIViewController* next = self.window.rootViewController; next; next =
         next.presentedViewController) {

        if (next.presentedViewController==nil) {
            return next;
        }


    }

    return self.window.rootViewController ;

}


@end
