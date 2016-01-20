//
//  KEAddressBookController.m
//  KECallsAttribution
//
//  Created by lichenWang on 14-1-6.
//  Copyright (c) 2014年 KERNEL. All rights reserved.
//

#import "KEAddressBookController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "KEContactAddressBook.h"
#import "ChineseToPinyin.h"
#import "KEContactCell.h"
#import "KBAppDelegate.h"
#import "KECoreDataContact.h"
#import <sqlite3.h>
#import "MBProgressHUD.h"
#import "UIColor+Art.h"
@interface KEAddressBookController ()<UIAlertViewDelegate>
@property (strong, nonatomic) NSMutableArray * contacts;
@property (nonatomic, strong)NSMutableDictionary * sectionDictionary;
@property (nonatomic, strong)NSMutableArray * dataArray;
@property (nonatomic, strong)NSMutableArray * keyArray;
@property (nonatomic)ABAddressBookRef addressBook;
@property (nonatomic, copy)NSString * phoneNumber;
@property (nonatomic, copy)NSString * phoneId;
@property (nonatomic,copy)NSIndexPath *selectedIndexPath;
@property (nonatomic, copy)KECoreDataContact * editedContract;
@property (nonatomic, copy)NSString *databaseFilePath;
@property (nonatomic, copy)NSString *telDatabaseFilePath;

@property (nonatomic, strong)UIAlertView * updateAlertView;
@property (nonatomic, strong)UIAlertView * deleteAlertView;
@property (nonatomic, strong)MBProgressHUD * progressHUD;
@property (nonatomic, copy)NSString *query;
@property (nonatomic)sqlite3 *database;
@property (nonatomic)sqlite3 *telRegionDatabase;

@end

@implementation KEAddressBookController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    
    self.keyArray = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];
    self.contacts = [NSMutableArray array];
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    self.editButtonItem.tintColor = [UIColor whiteColor];
//    self.editButtonItem.action = @selector(change:);
    if (DEVICE) {
        UIImage * imageNavigationBar = [UIImage imageNamed:@"skin_preview_loading_background"];
        UIImage * resizableImageNavigationBar = [imageNavigationBar resizableImageWithCapInsets:UIEdgeInsetsMake(5,5,5,5) resizingMode:UIImageResizingModeTile];
        [self.editButtonItem setBackgroundImage:resizableImageNavigationBar forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    }else{
        self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        self.tableView.sectionIndexColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"address_color"]];
    }

    [self.tableView registerNib:[UINib nibWithNibName:@"KEContactCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
      // [self.tableView setTintColor:[UIColor colorWithHex:0x037CFE]];
    
    if (IS_IOS7) {
        
         [self.tableView setTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"address_color"]]];
        
    }
    
    
    self.tableView.sectionIndexColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"address_color"]];
    
    
    [self initSearch];
    
    
    //注册一个更新联系人的通知
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAddressBook) name:@"updateContact" object:nil];
   
}
//- (void)change:(id)sender
//{
//    [self.tableView setEditing:!self.tableView.editing animated:YES];
//    if (self.tableView.editing) {
//        self.editButtonItem.title = @"完成";
//    }else{
//        self.editButtonItem.title = @"编辑";
//    }
//}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"tongxunlu"];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
   
    [MobClick beginLogPageView:@"tongxunlu"];
    
    
    //通讯录修改之后，coredata数据需要修改
    ABRecordRef person=[self getPersonWithRecordId:self.phoneId];
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    if (self.phoneId) {
        
        
        // 删除CoreData中的对象
        //  1.  获取MOC
        KBAppDelegate * appDelegate =
        [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext * context = appDelegate.managedObjectContext;

        
        [self.contacts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            
            KECoreDataContact *temp=(KECoreDataContact *)obj;
            
            if ([temp.recordID isEqualToValue:self.editedContract.recordID]) {
                //  2.  删除对象
                [context deleteObject:temp];
                
            }
            
            
        }];

        
        //更新已经改变的数据
        if (ABMultiValueGetCount(phone)>0) {
            
            for(int i = 0; i < ABMultiValueGetCount(phone); i++) {
                
                KECoreDataContact * coreDataContact =
                [NSEntityDescription insertNewObjectForEntityForName:@"KECoreDataContact"
                                              inManagedObjectContext:context];
                
                
                coreDataContact.firstName= (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
                
                coreDataContact.lastName=(__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
                
                coreDataContact.imageData=(__bridge NSMutableData*)ABPersonCopyImageData(person);
                
                coreDataContact.recordID= [NSNumber numberWithInt: (int)ABRecordGetRecordID(person)];
                
                coreDataContact.contactName=(__bridge NSString *)(ABRecordCopyCompositeName(person));
                
                coreDataContact.contactPhoneNumber=(__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, i);
                
                
                NSString * stringToCheckGroup = nil;
                if([[self currentLanguage] compare:@"zh-Hans" options:NSCaseInsensitiveSearch]==NSOrderedSame || [[self currentLanguage] compare:@"zh-Hant" options:NSCaseInsensitiveSearch]==NSOrderedSame) {
                    stringToCheckGroup = coreDataContact.lastName;
                    //NSLog(@"current Language == Chinese");
                }else{
                    stringToCheckGroup = coreDataContact.firstName;
                    // NSLog(@"current Language == English");
                }
                char str = [ChineseToPinyin sortSectionTitle:stringToCheckGroup];
                coreDataContact.contactType = [NSString stringWithFormat:@"%c",str];
                
                 [self attributionToInquiries:coreDataContact];
                
            }
            if(phone != NULL) CFRelease(phone);
            {
                CFRelease(person);
            }
            
            
        }
        
    }
    
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL firstDelete = [userDefaults boolForKey:@"firstDelete"];
    if (!firstDelete) {
        [userDefaults setBool:YES forKey:@"firstDelete"];
        self.updateAlertView = [[UIAlertView alloc] initWithTitle:@"查询归属地"
                                                            message:@"本操作可以一键查询通讯录里面的联系人的归属地"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"一键查询",nil];
        [self.updateAlertView show];
    }
    [self getDataToCoreData];
    [self.tableView reloadData];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == self.updateAlertView && buttonIndex == 1) {
        [self updateAddressBook];
    }else if(alertView == self.deleteAlertView){
        if (buttonIndex == 1) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"deleteReminder"];
        }else{
            self.tableView.editing = NO;
            self.editButtonItem.title = @"编辑";
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"deleteReminder"];
        }
    }else if (alertView.tag==10000) {
        
        if (buttonIndex==1) {
              [self dealWithDeleteActionWithIndexPath:self.selectedIndexPath];
        }
        
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)getDataToCoreData {
    
    [self.contacts removeAllObjects];
    
    [self.dataArray removeAllObjects];
    
    
    for (int i = 0 ; i < 26; i++) {
        [self.keyArray addObject:[NSString stringWithFormat:@"%c",'A'+i]];
        NSMutableDictionary * dictionary = [@{@"isCreated":@NO,[NSString stringWithFormat:@"%c",'A'+i]:[NSMutableArray array]} mutableCopy];
        [self.dataArray addObject:dictionary];
        
    }
    [self.keyArray addObject:[NSString stringWithFormat:@"%c",'#']];
    NSMutableDictionary * dictionary = [@{@"isCreated":@NO,[NSString stringWithFormat:@"%c",'#']:[NSMutableArray array]} mutableCopy];
    [self.dataArray addObject:dictionary];//分组算法
    
    //  1.  获取MOC
    KBAppDelegate * appDelegate =
    [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext * context = appDelegate.managedObjectContext;
    
    //  2.  创建查询
    NSFetchRequest * request =
    [NSFetchRequest fetchRequestWithEntityName:@"KECoreDataContact"];
    
    //  3.  获取数据
    self.contacts = [[context executeFetchRequest:request error:nil] mutableCopy];
 
    [self.contacts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {//数据分组
        KECoreDataContact * contact = obj;
        for (NSMutableDictionary * dictionary in self.dataArray) {
//            if ([[dictionary allKeys][0] isEqualToString:contact.contactType]) {
//                [[dictionary allValues][0] addObject:contact];
//                [dictionary setValue:@YES  forKey:@"isCreated"];
//            }
            if ([[dictionary allKeys] containsObject:contact.contactType]) {
                [[dictionary allValues][0] addObject:contact];
                [dictionary setValue:@YES  forKey:@"isCreated"];
            }

        }
    }];
    
    NSArray * arr = [NSArray arrayWithArray:self.dataArray];
    [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSMutableDictionary * dic = obj;
        if (![dic[@"isCreated"] boolValue]) {
            [self.dataArray removeObject:dic];
            [self.keyArray removeObject:[dic allKeys][0]];
        }
    }];
    self.contactsLabel.text = [NSString stringWithFormat:@"%d 位联系人",self.contacts.count];
}
- (void)getAddressBookAddCoreData {
    // 1.  获取MOC
    KBAppDelegate * appDelegate =
    [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext * context = appDelegate.managedObjectContext;
    
    [self deleteAllObjectsWithEntityName:@"KECoreDataContact" inContext:context];
    
    KEContactAddressBook * contactAddressBook = [[KEContactAddressBook alloc] init];
    NSMutableArray * array = [contactAddressBook allContacts];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        self.progressHUD.labelText=[NSString stringWithFormat:@"正在查询:%d/共:%d",idx+1,(int)array.count];
        
        KEContactAddressBook * contactAddressBook = obj;
        NSArray * phoneArray =[contactAddressBook.phoneInfo allValues];
        
        
        // 2. 创建对象
        KECoreDataContact * coreDataContact =
        [NSEntityDescription insertNewObjectForEntityForName:@"KECoreDataContact"
                                      inManagedObjectContext:context];
        
        // 3. 修改属性
        if (phoneArray.count) {
            coreDataContact.contactPhoneNumber = phoneArray[0];
        }
        coreDataContact.contactName = contactAddressBook.compositeName;
        coreDataContact.imageData = contactAddressBook.imageData;
        coreDataContact.firstName = contactAddressBook.firstName;
        coreDataContact.lastName = contactAddressBook.lastName;
        coreDataContact.recordID = [NSNumber numberWithInt:contactAddressBook.recordID];
        
        NSString * stringToCheckGroup = nil;
        if([[self currentLanguage] compare:@"zh-Hans" options:NSCaseInsensitiveSearch]==NSOrderedSame || [[self currentLanguage] compare:@"zh-Hant" options:NSCaseInsensitiveSearch]==NSOrderedSame)
        {
            stringToCheckGroup = contactAddressBook.lastName;
            //NSLog(@"current Language == Chinese");
        }else{
            stringToCheckGroup = contactAddressBook.firstName;
            // NSLog(@"current Language == English");
        }
        char str = [ChineseToPinyin sortSectionTitle:stringToCheckGroup];
        coreDataContact.contactType = [NSString stringWithFormat:@"%c",str];
        [self attributionToInquiries:coreDataContact];
    }];
}
-(NSString*)currentLanguage {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLang = [languages objectAtIndex:0];
    return currentLang;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (tableView==self.tableView) {
                
        UIView* myView = [[UIView alloc] init];
        
        myView.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:0.92];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, 20)];
        titleLabel.textColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"address_color"]];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text=[self.dataArray[section] allKeys][0];
        [myView addSubview:titleLabel];
        return myView;

        
    }else {
    
        return nil;
    
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (tableView==self.tableView) {
        return self.dataArray.count;
    }else {
        return 1;
    
    }
    
}
//- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return [self.dataArray[section] allKeys][0];
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog(@"section:%d",section);
    
    if (tableView==self.tableView) {
        return [[self.dataArray[section] allValues][0] count];

    }else
    {
    
     return  self.searchResultArray.count;
    
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    if (tableView==self.tableView) {
        
        
        return self.keyArray;
        
    }else {
    
        return @[];
    
    }
    
    
}
//点击右侧索引表项时调用
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
    // 获取所点目录对应的indexPath值
    NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    
    // 让table滚动到对应的indexPath位置
    [tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    return index;}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (tableView==self.tableView) {
        
        
        static NSString *CellIdentifier = @"Cell";
        KEContactCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

        cell.contact = [self.dataArray[indexPath.section] allValues][0][indexPath.row];
        
        NSLog(@"%@",cell.contact);
        return cell;

        
    }else {
    
        static NSString *CellIdentifier = @"result";
        KEContactCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.contact = [self.searchResultArray objectAtIndex:indexPath.row];
        
        NSLog(@"%@",cell.contact);
        return cell;

    
    
    
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    KECoreDataContact * contact;
    
    if (tableView==self.tableView) {
        
        contact = [self.dataArray[indexPath.section] allValues][0][indexPath.row];

        
    }else {
    
        contact=[self.searchResultArray objectAtIndex:indexPath.row];
    
    }
    
    
    self.phoneNumber = [contact.contactPhoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    self.phoneNumber = [self.phoneNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    self.phoneNumber = [self.phoneNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    self.phoneNumber = [self.phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.phoneNumber=[self.phoneNumber stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    self.phoneNumber = [[self.phoneNumber componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
    self.phoneNumber = [self.phoneNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];

  
    
    self.selectedIndexPath=indexPath;
    
    self.phoneId=[contact.recordID  stringValue];
    self.editedContract=[contact copy];
    
    
    
    if(tableView==self.tableView) {
        
        if (dialAction==nil) {
            dialAction=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拨打电话",@"编辑联系人", @"删除联系人",nil];
        }
        
        
        
        
        [dialAction setTitle:self.phoneNumber];
        
        [dialAction showInView:self.view];

        
        
        
    }else {
        if (searchAction==nil) {
            
            searchAction=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拨打电话",@"编辑联系人",nil];
            
            
        }
        
        
        [searchAction setTitle:self.phoneNumber];
        
        [searchAction showInView:self.view];

        
        
    }
    

    
    
    
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
  }

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    NSLog(@"%d",buttonIndex);
    
    switch (buttonIndex) {
            
        case 0:
        {
            NSURL * telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.phoneNumber]];
            UIWebView*callWebview =[[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
                [self.view addSubview:callWebview];

        }
            break;
            
        case 1:
        {
            
            ABRecordRef person=[self getPersonWithRecordId:self.phoneId];
        
            [self goToEditPage:person];
            
        }
            break;

        case 2:
        {
            
            if (actionSheet==dialAction) {
                
                
//                [self dealWithDeleteActionWithIndexPath:self.selectedIndexPath];
                
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要从系统通讯录删除联系人么,删除之后将无法恢复" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
                alert.tag=10000;
                
                [alert show];
                
            }
            
            
        }
            break;
            
        default:
            break;
    }
    
    
}


- (ABRecordRef)getPersonWithRecordId:(NSString *)recordId {
    
    //TODO: 要加通讯录访问权限设置
    
    
    
    ABAddressBookRef addressBook =  ABAddressBookCreateWithOptions(NULL, NULL);
    
    CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    
    for(int i = 0; i < CFArrayGetCount(results); i++) {
        
        ABRecordRef person = CFArrayGetValueAtIndex(results, i);
        
        //读取firstname
        
        NSString *tempId =[NSString stringWithFormat:@"%d",ABRecordGetRecordID(person)];
        
        if(tempId != nil) {
            
            
            if ([tempId isEqualToString:recordId]) {
                
                
                return person;
                
            }
            
            
        }
        
        
    }
    return nil;
    
}


-(void)goToEditPage:(ABRecordRef)person {
    
    
    
    // Fetch the address book
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    // Search for the person named "Appleseed" in the address book
    
    // Display "Appleseed" information if found in the address book
    
    
    ABPersonViewController *picker = [[ABPersonViewController alloc] init] ;
   
    picker.personViewDelegate = self;
    picker.displayedPerson = person;
    // Allow users to edit the person’s information
    picker.allowsEditing = YES;
    
    
//     [[UIBarButtonItem appearance]setTintColor:[UIColor whiteColor]];
//    
//    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
   
    
    [self.navigationController pushViewController:picker animated:YES];
    
    
    CFRelease(addressBook);
    
    
    
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        
//        // 删除CoreData中的对象
//        //  1.  获取MOC
//        KBAppDelegate * appDelegate =
//        [[UIApplication sharedApplication] delegate];
//        NSManagedObjectContext * context = appDelegate.managedObjectContext;
//        
//        //  2.  删除对象
//        [context deleteObject:[self.dataArray[indexPath.section] allValues][0][indexPath.row]];
//        
//        
//        // 系统的对象
//        //[self deleteContact:[self.dataArray[indexPath.section] allValues][0][indexPath.row]];
//
//        // 删除C层缓存的数组里的对象
//        NSLog(@"CURRENT:%@",[self.dataArray[indexPath.section] allValues][0][indexPath.row]);
//        [self.contacts removeObject:[self.dataArray[indexPath.section] allValues][0][indexPath.row]];
//        [[self.dataArray[indexPath.section] allValues][0] removeObject:[self.dataArray[indexPath.section] allValues][0][indexPath.row]];
//
//        NSArray * array = [NSArray arrayWithArray:[self.dataArray[indexPath.section] allValues][0]];
//        if (array.count == 0) {
//            self.dataArray[indexPath.section][@"isCreated"] = @NO;
//            NSArray * arr = [NSArray arrayWithArray:self.dataArray];
//            [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                NSMutableDictionary * dic = obj;
//                if (![dic[@"isCreated"] boolValue]) {
//                    [self.dataArray removeObject:dic];
//                    [self.keyArray removeObject:[dic allKeys][0]];
//                     NSIndexSet * indexPathSection = [NSIndexSet indexSetWithIndex:indexPath.section];
//                    [self.tableView deleteSections:indexPathSection withRowAnimation:UITableViewRowAnimationFade];
//                    //NSLog(@"indexPathSection:-----------");
//                }
//            }];
//        }else{
//           [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        }
//    }   
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
//}
- (void)deleteContact:(KECoreDataContact*)contact {
    // 初始化并创建通讯录对象，记得释放内存
    ABAddressBookRef addressBook;
    addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    // 获取通讯录中所有的联系人
    NSArray *array = (__bridge NSArray*)ABAddressBookCopyArrayOfAllPeople(addressBook);
    // 遍历所有的联系人并删除
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ABRecordRef people = (__bridge ABRecordRef)obj;
        ABRecordRef record = (__bridge ABRecordRef)[array objectAtIndex:idx];
        if ([contact.recordID integerValue]== (int)ABRecordGetRecordID(record)) {
            ABAddressBookRemoveRecord(addressBook, people,NULL);
        }
    }];
    // 保存修改的通讯录对象
    ABAddressBookSave(addressBook, NULL);
    // 释放通讯录对象的内存
    if (addressBook) {
        CFRelease(addressBook);
    }
}

-(void)dealWithDeleteActionWithIndexPath:(NSIndexPath *)indexPath {

    
    // 删除CoreData中的对象
    //  1.  获取MOC
    KBAppDelegate * appDelegate =
    [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext * context = appDelegate.managedObjectContext;
    
    
    
        
        //  2.  删除对象
        [context deleteObject:[self.dataArray[indexPath.section] allValues][0][indexPath.row]];
        
        
        // 系统的对象
        [self deleteContact:[self.dataArray[indexPath.section] allValues][0][indexPath.row]];
        
        // 删除C层缓存的数组里的对象
        NSLog(@"CURRENT:%@",[self.dataArray[indexPath.section] allValues][0][indexPath.row]);
        [self.contacts removeObject:[self.dataArray[indexPath.section] allValues][0][indexPath.row]];
        [[self.dataArray[indexPath.section] allValues][0] removeObject:[self.dataArray[indexPath.section] allValues][0][indexPath.row]];
        
        NSArray * array = [NSArray arrayWithArray:[self.dataArray[indexPath.section] allValues][0]];
        if (array.count == 0) {
            self.dataArray[indexPath.section][@"isCreated"] = @NO;
            NSArray * arr = [NSArray arrayWithArray:self.dataArray];
            [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSMutableDictionary * dic = obj;
                if (![dic[@"isCreated"] boolValue]) {
                    [self.dataArray removeObject:dic];
                    [self.keyArray removeObject:[dic allKeys][0]];
                    NSIndexSet * indexPathSection = [NSIndexSet indexSetWithIndex:indexPath.section];
                    [self.tableView deleteSections:indexPathSection withRowAnimation:UITableViewRowAnimationFade];
                    //NSLog(@"indexPathSection:-----------");
                }
            }];
        }else {
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }

        
    
}




- (IBAction)back:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)updateAddressBook {
    //TODO: 更新通讯录
    self.progressHUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    self.progressHUD.labelText = @"正在查询...";
    self.databaseFilePath = [[NSBundle mainBundle] pathForResource:@"database"
                                                            ofType:@"sqlite3"];
    
    self.telDatabaseFilePath =[[NSBundle mainBundle] pathForResource:@"Region"
                                                              ofType:@"sqlite"];
    
    
    if (sqlite3_open([self.databaseFilePath UTF8String], &_database)
        != SQLITE_OK) {
        sqlite3_close(self.database);
        NSAssert(0, @"打开数据库失败！");
    }
    
    if (sqlite3_open([self.telDatabaseFilePath UTF8String], &_telRegionDatabase)
        != SQLITE_OK) {
        sqlite3_close(self.telRegionDatabase);
        NSAssert(0, @"打开固话数据库失败！");
    }
    
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [self getAddressBookAddCoreData];
        [self getDataToCoreData];
        dispatch_async(dispatch_get_main_queue(), ^{
            //关闭数据库z
            sqlite3_close(self.database);
            
            sqlite3_close(self.telRegionDatabase);
            [self.tableView reloadData];
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            
            self.contactsLabel.text = [NSString stringWithFormat:@"%d 位联系人",self.contacts.count];
        });
    });

}

- (NSString*)checkCarriers:(NSString*)string {
    NSString * carriers = nil;
    if ([[string substringToIndex:3] isEqualToString:@"130"] || [[string substringToIndex:3] isEqualToString:@"131"]) {
        carriers = @"MOBILE130131";
    }else if ([[string substringToIndex:3] isEqualToString:@"132"] || [[string substringToIndex:3] isEqualToString:@"133"]) {
        carriers = @"MOBILE132133";
    }else if ([[string substringToIndex:3] isEqualToString:@"134"] || [[string substringToIndex:3] isEqualToString:@"135"]) {
        carriers = @"MOBILE134135";
    }else if ([[string substringToIndex:3] isEqualToString:@"136"] || [[string substringToIndex:3] isEqualToString:@"137"]) {
        carriers = @"MOBILE136137";
    }else if ([[string substringToIndex:3] isEqualToString:@"138"] || [[string substringToIndex:3] isEqualToString:@"139"]) {
        carriers = @"MOBILE138139";
    }else if ([[string substringToIndex:3] isEqualToString:@"145"] || [[string substringToIndex:3] isEqualToString:@"147"]) {
        carriers = @"MOBILE145147";
    }else if ([[string substringToIndex:3] isEqualToString:@"150"] || [[string substringToIndex:3] isEqualToString:@"151"]) {
        carriers = @"MOBILE150151";
    }else if ([[string substringToIndex:3] isEqualToString:@"152"] || [[string substringToIndex:3] isEqualToString:@"153"]) {
        carriers = @"MOBILE152153";
    }else if ([[string substringToIndex:3] isEqualToString:@"155"] || [[string substringToIndex:3] isEqualToString:@"156"]) {
        carriers = @"MOBILE155156";
    }else if ([[string substringToIndex:3] isEqualToString:@"157"] || [[string substringToIndex:3] isEqualToString:@"158"]) {
        carriers = @"MOBILE157158";
    }else if ([[string substringToIndex:3] isEqualToString:@"159"] || [[string substringToIndex:3] isEqualToString:@"180"]) {
        carriers = @"MOBILE159180";
    }else if ([[string substringToIndex:3] isEqualToString:@"181"] || [[string substringToIndex:3] isEqualToString:@"182"]) {
        carriers = @"MOBILE181182";
    }else if ([[string substringToIndex:3] isEqualToString:@"183"] || [[string substringToIndex:3] isEqualToString:@"184"]) {
        carriers = @"MOBILE183184";
    }else if ([[string substringToIndex:3] isEqualToString:@"185"] || [[string substringToIndex:3] isEqualToString:@"186"]) {
        carriers = @"MOBILE185186";
    }else if ([[string substringToIndex:3] isEqualToString:@"187"] || [[string substringToIndex:3] isEqualToString:@"188"]|| [[string substringToIndex:3] isEqualToString:@"189"]) {
        carriers = @"MOBILE187188189";
    }
    return carriers;
}

- (void)attributionToInquiries:(KECoreDataContact *)contact {
        NSString * testString = nil;
//        testString = [contact.contactPhoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    testString=contact.contactPhoneNumber;
    
    if (![testString hasPrefix:@"0"]) {
       testString = [testString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    
    
    
        testString = [testString stringByReplacingOccurrencesOfString:@"(" withString:@""];
        testString = [testString stringByReplacingOccurrencesOfString:@")" withString:@""];
        testString = [testString stringByReplacingOccurrencesOfString:@" " withString:@""];
        testString = [testString stringByReplacingOccurrencesOfString:@"+86" withString:@""];
        testString = [[testString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
        testString = [testString stringByReplacingOccurrencesOfString:@"+" withString:@""];
//        if (testString.length>0&&[[testString substringToIndex:2] isEqualToString:@"86"]) {
//            testString = [testString stringByReplacingOccurrencesOfString:@"86" withString:@""];
//        }
    
    
//    if ([testString hasPrefix:@"1863351"]) {
//        
//        
//        
//        
//    }
    
    
        if (testString.length >= 7) {
            //打开数据库
            NSString * string = [testString substringToIndex:7];
            //执行查询
            if ([[self checkCarriers:string] isEqualToString:@"MOBILE130131"]) {
                self.query = @"SELECT * FROM MOBILE130131 WHERE phoneNmber=?";
            }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE132133"]) {
                self.query = @"SELECT * FROM MOBILE132133 WHERE phoneNmber=?";
            }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE134135"]) {
                self.query = @"SELECT * FROM MOBILE134135 WHERE phoneNmber=?";
            }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE136137"]) {
                self.query = @"SELECT * FROM MOBILE136137 WHERE phoneNmber=?";
            }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE138139"]) {
                self.query = @"SELECT * FROM MOBILE138139 WHERE phoneNmber=?";
            }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE145147"]) {
                self.query = @"SELECT * FROM MOBILE145147 WHERE phoneNmber=?";
            }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE150151"]) {
                self.query = @"SELECT * FROM MOBILE150151 WHERE phoneNmber=?";
            }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE152153"]) {
                self.query = @"SELECT * FROM MOBILE152153 WHERE phoneNmber=?";
            }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE155156"]) {
                self.query = @"SELECT * FROM MOBILE155156 WHERE phoneNmber=?";
            }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE157158"]) {
                self.query = @"SELECT * FROM MOBILE157158 WHERE phoneNmber=?";
            }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE159180"]) {
                self.query = @"SELECT * FROM MOBILE159180 WHERE phoneNmber=?";
            }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE181182"]) {
                self.query = @"SELECT * FROM MOBILE181182 WHERE phoneNmber=?";
            }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE183184"]) {
                self.query = @"SELECT * FROM MOBILE183184 WHERE phoneNmber=?";
            }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE185186"]) {
                self.query = @"SELECT * FROM MOBILE185186 WHERE phoneNmber=?";
            }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE187188189"]) {
                self.query = @"SELECT * FROM MOBILE187188189 WHERE phoneNmber=?";
            }else if ([string hasPrefix:@"0"])
            {
            //固定电话
            
                testString = [contact.contactPhoneNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
             
                testString = [testString stringByReplacingOccurrencesOfString:@")" withString:@""];
                testString = [testString stringByReplacingOccurrencesOfString:@" " withString:@""];
                testString = [testString stringByReplacingOccurrencesOfString:@"+" withString:@""];
                
                testString = [testString stringByReplacingOccurrencesOfString:@"+86" withString:@""];
                testString = [[testString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
                
               // string=[[testString componentsSeparatedByString:@"-"] objectAtIndex:0];
                
                NSString *str3=[testString substringToIndex:3];
                
                NSString *str4=[testString substringToIndex:4];
                
                
                
                self.query = @"SELECT * FROM Region WHERE Number=? OR Number=?";

            
                sqlite3_stmt *statement;
                
                if (sqlite3_prepare_v2(self.telRegionDatabase, [self.query UTF8String], -1, &statement,nil) == SQLITE_OK) {
                    sqlite3_bind_text(statement, 1, [str3 UTF8String], -1, NULL);
                    sqlite3_bind_text(statement, 2, [str4 UTF8String], -1, NULL);
                    //依次读取数据库表格FIELDS中每行的内容
                    while (sqlite3_step(statement) == SQLITE_ROW) {
                        //获得数据
                        char *carriersName = (char *)sqlite3_column_text(statement, 4);
                        char *city = (char *)sqlite3_column_text(statement, 3);
                        char *province = (char *)sqlite3_column_text(statement, 2);
                        char *number = (char *)sqlite3_column_text(statement, 1);
                        NSString * provinceString = [[NSString alloc] initWithUTF8String:province];
                        NSString * cityString = [[NSString alloc] initWithUTF8String:city];
                        NSString * phoneNumber = [[NSString alloc] initWithUTF8String:number];
                        if ([str3 isEqualToString:phoneNumber]||[str4 isEqualToString:phoneNumber]) {
                          contact.carrierName = [[NSString stringWithUTF8String:carriersName]stringByReplacingOccurrencesOfString:@"固定电话" withString:@"固话"];
                            if([provinceString isEqualToString:cityString]){
                                contact.contactAreaName = provinceString;
                            }else{
                                contact.contactAreaName = [NSString stringWithFormat:@"%@%@",provinceString,cityString];
                            }
                            contact.showCallerID = [NSString stringWithFormat:@"%@%@",contact.contactAreaName,contact.carrierName];
                            
                            
                            
                            if (contact.contactName) {
                                
                                
                                
                                
                                [self changeLocalizedPhoneLabel:contact];

                                
                                
                            }
                            
                            
                            
                            return;
                        }
                    }
                    sqlite3_finalize(statement);
                }

            
            
            
            
            }
            else{
                contact.contactAreaName = @"未知号码";
                return;
            }
            sqlite3_stmt *statement;
            
            if (sqlite3_prepare_v2(self.database, [self.query UTF8String], -1, &statement,nil) == SQLITE_OK) {
                sqlite3_bind_text(statement, 1, [string UTF8String], -1, NULL);
                //依次读取数据库表格FIELDS中每行的内容
                while (sqlite3_step(statement) == SQLITE_ROW) {
                    //获得数据
                    char *carriersName = (char *)sqlite3_column_text(statement, 3);
                    char *city = (char *)sqlite3_column_text(statement, 2);
                    char *province = (char *)sqlite3_column_text(statement, 1);
                    char *number = (char *)sqlite3_column_text(statement, 0);
                    NSString * provinceString = [[NSString alloc] initWithUTF8String:province];
                    NSString * cityString = [[NSString alloc] initWithUTF8String:city];
                    NSString * phoneNumber = [[NSString alloc] initWithUTF8String:number];
                    if ([string isEqualToString:phoneNumber]) {
                         contact.carrierName = [[NSString stringWithUTF8String:carriersName] stringByReplacingOccurrencesOfString:@"中国" withString:@""];
                        if([provinceString isEqualToString:cityString]){
                            contact.contactAreaName = provinceString;
                        }else{
                            contact.contactAreaName = [NSString stringWithFormat:@"%@%@",provinceString,cityString];
                        }
                        contact.showCallerID = [NSString stringWithFormat:@"%@%@",contact.contactAreaName,contact.carrierName];
                        
                        
                        
                        if (contact.contactName) {
                            
                          
                            
                            
                             [self changeLocalizedPhoneLabel:contact];
                            
                           
                        }
                        
                        
                       
                        return;
                    }
                }
                sqlite3_finalize(statement);
            }
//            //关闭数据库
//            sqlite3_close(self.database);
        }
}
- (void)changeLocalizedPhoneLabel:(KECoreDataContact*)contact{
    // 初始化并创建通讯录对象，记得释放内存
    ABAddressBookRef addressBook;
    addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    // 获取通讯录中所有的联系人
//    NSArray *array = (__bridge NSArray*)ABAddressBookCopyArrayOfAllPeople(addressBook);
//    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        ABRecordRef record = (__bridge ABRecordRef)[array objectAtIndex:idx];
//        if ([contact.recordID integerValue] == (int)ABRecordGetRecordID(record)) {
//            ABMultiValueRef phone = ABRecordCopyValue(record, kABPersonPhoneProperty);
//            //NSLog(@"-------------------%ld",ABMultiValueGetCount(phone));
//            if (ABMultiValueGetCount(phone) == 1) {
//                ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABMultiStringPropertyType);//原来为kABPersonPhoneProperty，有log出错误信息，后修改为这个，错误信息消失。
//                ABMultiValueAddValueAndLabel(multi, (__bridge CFTypeRef)contact.contactPhoneNumber, (__bridge CFTypeRef)contact.showCallerID, NULL);
//                ABRecordSetValue(record, kABPersonPhoneProperty, multi, NULL);
//
//            }      }
//    }];
//    
   
    
    ABRecordRef record=ABAddressBookGetPersonWithRecordID(addressBook, [contact.recordID intValue]);
    
    ABMultiValueRef phone = ABRecordCopyValue(record, kABPersonPhoneProperty);
    //NSLog(@"-------------------%ld",ABMultiValueGetCount(phone));
    
    ABMutableMultiValueRef multi = ABMultiValueCreateMutableCopy(phone);
    
    ABMultiValueRef  phones = ABRecordCopyValue(record, kABPersonPhoneProperty);

        
    for(int i = 0; i < ABMultiValueGetCount(phones); i++) {
        
        CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(phones, i);
        
        NSString * testString=(__bridge NSString *)(phoneNumberRef);
        
        if ([contact.contactPhoneNumber isEqualToString:testString]) {
            
            int index=i;
            
            ABMultiValueReplaceLabelAtIndex(multi, (__bridge CFStringRef)(contact.showCallerID), index);
            
            ABRecordSetValue(record, kABPersonPhoneProperty, multi, NULL);
            
            break;
            
        }
        
        
    }

    //提升效率
    
//    int index= (int)ABMultiValueGetFirstIndexOfValue(phones, (__bridge CFTypeRef)(contact.contactPhoneNumber));
//    
//    
//    ABMultiValueReplaceLabelAtIndex(multi, (__bridge CFStringRef)(contact.showCallerID), index);
//    
//    ABRecordSetValue(record, kABPersonPhoneProperty, multi, NULL);

    
    // 保存修改的通讯录对象
    ABAddressBookSave(addressBook, NULL);
    // 释放通讯录对象的内存
    if (addressBook) {
        CFRelease(addressBook);
    }
}
- (void)deleteAllObjectsWithEntityName:(NSString *)entityName
                             inContext:(NSManagedObjectContext *)context {
    NSFetchRequest *fetchRequest =
    [NSFetchRequest fetchRequestWithEntityName:entityName];
    fetchRequest.includesPropertyValues = NO;
    fetchRequest.includesSubentities = NO;
    
    NSError *error;
    NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *managedObject in items) {
        [context deleteObject:managedObject];
    }
    [self.dataArray removeAllObjects];
    [self.keyArray removeAllObjects];
}




#pragma mark 恢复通讯录

- (IBAction)recoverAddressBook:(UIButton *)sender {
    
    self.progressHUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    self.progressHUD.labelText = @"正在恢复...";
    self.databaseFilePath = [[NSBundle mainBundle] pathForResource:@"database"
                                                            ofType:@"sqlite3"];
    if (sqlite3_open([self.databaseFilePath UTF8String], &_database)
        != SQLITE_OK) {
        sqlite3_close(self.database);
        NSAssert(0, @"打开数据库失败！");
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [self getAddressBookAddCoreDataRecovery];
        [self getDataToCoreData];
        dispatch_async(dispatch_get_main_queue(), ^{
            //关闭数据库z
            sqlite3_close(self.database);
            [self.tableView reloadData];
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        });
    });

    
}


- (void)getAddressBookAddCoreDataRecovery {
    // 1.  获取MOC
    KBAppDelegate * appDelegate =
    [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext * context = appDelegate.managedObjectContext;
    
    [self deleteAllObjectsWithEntityName:@"KECoreDataContact" inContext:context];
    
    KEContactAddressBook * contactAddressBook = [[KEContactAddressBook alloc] init];
    NSMutableArray * array = [contactAddressBook allContacts];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        
        self.progressHUD.labelText=[NSString stringWithFormat:@"正在恢复:%d/共:%d",idx+1,(int)array.count];
        
        
        KEContactAddressBook * contactAddressBook = obj;
        NSArray * phoneArray =[contactAddressBook.phoneInfo allValues];
        
        
        // 2. 创建对象
        KECoreDataContact * coreDataContact =
        [NSEntityDescription insertNewObjectForEntityForName:@"KECoreDataContact"
                                      inManagedObjectContext:context];
        
        // 3. 修改属性
        if (phoneArray.count) {
            coreDataContact.contactPhoneNumber = phoneArray[0];
        }
        coreDataContact.contactName = contactAddressBook.compositeName;
        coreDataContact.imageData = contactAddressBook.imageData;
        coreDataContact.firstName = contactAddressBook.firstName;
        coreDataContact.lastName = contactAddressBook.lastName;
        coreDataContact.recordID = [NSNumber numberWithInt:contactAddressBook.recordID];
        
        NSString * stringToCheckGroup = nil;
        if([[self currentLanguage] compare:@"zh-Hans" options:NSCaseInsensitiveSearch]==NSOrderedSame || [[self currentLanguage] compare:@"zh-Hant" options:NSCaseInsensitiveSearch]==NSOrderedSame) {
            stringToCheckGroup = contactAddressBook.lastName;
            //NSLog(@"current Language == Chinese");
        }else {
            stringToCheckGroup = contactAddressBook.firstName;
            // NSLog(@"current Language == English");
        }
        char str = [ChineseToPinyin sortSectionTitle:stringToCheckGroup];
        coreDataContact.contactType = [NSString stringWithFormat:@"%c",str];
        [self attributionToInquiriesRecovery:coreDataContact];
    }];
}

- (void)attributionToInquiriesRecovery:(KECoreDataContact *)contact {
    
    contact.showCallerID=@"住宅";
    [self changeLocalizedPhoneLabel:contact];
    
}

- (void)initSearch {


    UISearchBar *searchbar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    
    searchbar.placeholder=@"搜索联系人";
    
    [searchbar setTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"daohang_bg"]]];
    
    searchbar.delegate = self;
    
    
    _mySearchDisplayController = [[UISearchDisplayController  alloc] initWithSearchBar:searchbar contentsController:self];
    
    //searchdispalyCtrl.active = NO;
    
    _mySearchDisplayController.searchResultsDelegate=self;
    
    _mySearchDisplayController.searchResultsDataSource = self;
    
    _mySearchDisplayController.delegate=self;
    
    
    self.tableView.tableHeaderView=searchbar;
    
    [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:@"KEContactCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"result"];
    
    self.searchDisplayController.searchResultsTableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    
    _searchResultArray = [NSMutableArray arrayWithCapacity:10];




}
//搜索
#pragma mark - searchBar

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    NSMutableArray * testArray = [NSMutableArray array];
    [self.contacts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        KECoreDataContact * contact = obj;
        
        if ([self isPureInt:searchText]) {
            
            
            if ([contact.contactPhoneNumber rangeOfString:searchText].location != NSNotFound ) {
                [testArray addObject:contact];
            }
            
            
            
            
        }else if ([contact.contactName rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            
            [testArray addObject:contact];
            
        }
        
    }];
    self.searchResultArray = [NSMutableArray arrayWithArray:testArray];
}
- (BOOL)searchDisplayController:(UISearchDisplayController*)controller shouldReloadTableForSearchString:(NSString *)searchString {
    NSString * string = [self.searchDisplayController.searchBar scopeButtonTitles][self.searchDisplayController.searchBar.selectedScopeButtonIndex];
    [self filterContentForSearchText:searchString scope:string];
    return YES;
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    NSString * string = self.searchDisplayController.searchBar.scopeButtonTitles[searchOption];
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:string];
    return YES;
}
//判断纯数字
- (BOOL)isPureInt:(NSString*)string {
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}


@end
