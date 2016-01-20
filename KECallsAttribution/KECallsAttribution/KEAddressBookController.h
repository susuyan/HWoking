//
//  KEAddressBookController.h
//  KECallsAttribution
//
//  Created by lichenWang on 14-1-6.
//  Copyright (c) 2014年 KERNEL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
@interface KEAddressBookController : UITableViewController<UIActionSheetDelegate,ABPersonViewControllerDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
{

    UIActionSheet *dialAction;
    
    
    UIActionSheet *searchAction;

}
- (IBAction)back:(UIButton *)sender;

- (IBAction)recoverAddressBook:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *contactsLabel;
@property(strong,nonatomic)UISearchDisplayController *mySearchDisplayController;
@property(strong,nonatomic)NSMutableArray *searchResultArray;
@end
