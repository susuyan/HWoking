//
//  ECQuickContractController.h
//  KECallsAttribution
//
//  Created by 赵 进喜 on 14-9-9.
//  Copyright (c) 2014年 K.BLOCK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleImage.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
@interface ECQuickContractController : UITableViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,ABPeoplePickerNavigationControllerDelegate>

- (IBAction)hideKeyboard:(UITapGestureRecognizer *)sender;
- (IBAction)backButtonPressed:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet CircleImage *avatarView;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
- (IBAction)getContact:(UIButton *)sender;
- (IBAction)addToScreen:(UIButton *)sender;

@end
