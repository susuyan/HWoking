//
//  EZMergeCell.h
//  ContactBackup
//
//  Created by 赵 进喜 on 15/3/19.
//  Copyright (c) 2015年 everzones. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>


typedef void(^MergeDidFinish)(NSString *name);

@interface EZMergeCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource,ABNewPersonViewControllerDelegate>
{


    NSArray *allContacts;

    
    
    NSData *avatarImage;
    
    
    NSString *firstName;
    
    
    NSString *lastName;
    
    
     NSString *midName;
    
    
    NSString *company;
    
    
    NSString *keyName;
    

}
@property (weak, nonatomic) IBOutlet UITableView *moreTableView;

@property(strong,nonatomic)MergeDidFinish mergeDidFinish;
- (IBAction)mergeContacts:(UIButton *)sender;
-(void)setInfo:(NSDictionary *)info;



@end
