//
//  ECQuickContractController.m
//  KECallsAttribution
//
//  Created by 赵 进喜 on 14-9-9.
//  Copyright (c) 2014年 K.BLOCK. All rights reserved.
//

#import "ECQuickContractController.h"
#import "Singel.h"
#import "SVProgressHUD.h"

@interface ECQuickContractController ()

@end

@implementation ECQuickContractController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        
        
    }
    return self;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [MobClick beginLogPageView:@"quickdail"];


}
-(void)viewWillDisappear:(BOOL)animated
{

    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"quickdail"];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    UIImageView *bg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_page_bg"]];
//    
//    [self.tableView setBackgroundView:bg];
    
    
    __block   id bself=(id)self;
    
    self.avatarView.touchBlock=^{
        
    
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@"选择联系人头像"
                                      delegate:bself
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"拍照", @"从相册选",nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showInView:self.view];
        
                               
    
        
    };
    
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//    
// 
//   
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
//
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//
////    [self.view endEditing:YES];
//}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *image=[[UIImagePickerController alloc]init];
    image.allowsEditing=YES;
    
    
    switch (buttonIndex) {
        case 0:
            image.sourceType=UIImagePickerControllerSourceTypeCamera;
            image.delegate=self;
            [self presentViewController:image animated:YES completion:nil];
            break;
        case 1:
            
             image.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            image.delegate=self;
            [self presentViewController:image animated:YES completion:nil];
            break;
//        case 2:
//              [actionSheet dismissWithClickedButtonIndex:2 animated:YES];
//            
//            return;
//            break;

        default:
            break;
    }
    
}
//- (void)actionSheetCancel:(UIActionSheet *)actionSheet
//{
//
//    [actionSheet dismissWithClickedButtonIndex:2 animated:YES];
//
//
//
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return 3;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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

//#pragma mark -
//#pragma mark Responding to keyboard events
//- (void)keyboardWillShow:(NSNotification *)notification {
//    
//    /*
//     Reduce the size of the text view so that it's not obscured by the keyboard.
//     Animate the resize so that it's in sync with the appearance of the keyboard.
//     */
//    
//    NSDictionary *userInfo = [notification userInfo];
//    
//    // Get the origin of the keyboard when it's displayed.
//    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    
//    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
//    CGRect keyboardRect = [aValue CGRectValue];
//    
//    // Get the duration of the animation.
//    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSTimeInterval animationDuration;
//    [animationDurationValue getValue:&animationDuration];
//    
//    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
//    //[self moveInputBarWithKeyboardHeight:keyboardRect.size.height withDuration:animationDuration];
//    
//    
//  
//    
//    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//   
//}
//
//
//- (void)keyboardWillHide:(NSNotification *)notification {
//    
////    NSDictionary* userInfo = [notification userInfo];
////    
////    /*
////     Restore the size of the text view (fill self's view).
////     Animate the resize so that it's in sync with the disappearance of the keyboard.
////     */
////    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
////    NSTimeInterval animationDuration;
////    [animationDurationValue getValue:&animationDuration];
////    
//   // [self moveInputBarWithKeyboardHeight:0.0 withDuration:animationDuration];
//}



-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    
    Singel *singel =  [Singel sharedData];
    singel.image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    
    
    
    self.avatarView.image =singel.image;
    //    NSString *str = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    //    NSString *path = [str stringByAppendingPathComponent:@"/images"];
    //    [self ensurePathAt:path];
    ////    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    ////    [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    //    NSString *imagePath = [NSString stringWithFormat:@"/%@/thumb.png",path];
    //    NSData *jpg = UIImagePNGRepresentation(self.image);
    //    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    //        [[NSFileManager defaultManager] createFileAtPath:imagePath contents:jpg attributes:nil];
    //    });
    
    
    
    
    
    [picker dismissViewControllerAnimated:YES completion:^{
        NULL;
    }];
    
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        NULL;
    }];
}


- (IBAction)hideKeyboard:(UITapGestureRecognizer *)sender {
    
    
    [self.view endEditing:YES];
    
}

- (IBAction)backButtonPressed:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)getContact:(UIButton *)sender {
    
    ABPeoplePickerNavigationController *people=[[ABPeoplePickerNavigationController alloc]init];
    
    people.peoplePickerDelegate=self;
    
    
    [self presentViewController:people animated:YES completion:nil];
    
    
    
}

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    return YES;
}
-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    self.nameText.text = (__bridge NSString*)ABRecordCopyCompositeName(person);
    // ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonAddressProperty);
    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    int index = ABMultiValueGetIndexForIdentifier(phoneMulti, identifier);
    self.phoneText.text = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneMulti, index);
    
    
    NSData *imageData=(__bridge NSData *)(ABPersonCopyImageData(person));
    
    if (imageData) {
        
          Singel *singel =  [Singel sharedData];
        
        singel.image=[UIImage imageWithData:imageData];
        
        
        self.avatarView.image=singel.image;
        
    }
    
    
    
    
    
    [[NSUserDefaults standardUserDefaults] setObject:self.nameText.text forKey:@"name"];
    [[NSUserDefaults standardUserDefaults] setObject:self.phoneText.text forKey:@"phone"];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [peoplePicker dismissViewControllerAnimated:YES completion:^{
        NULL;
    }];
    
    return NO;
    
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
-(void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{

    self.nameText.text = (__bridge NSString*)ABRecordCopyCompositeName(person);
    // ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonAddressProperty);
    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    int index = ABMultiValueGetIndexForIdentifier(phoneMulti, identifier);
    self.phoneText.text = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneMulti, index);
    
    
    
    
    NSData *imageData=(__bridge NSData *)(ABPersonCopyImageData(person));
    
    if (imageData) {
        
        Singel *singel =  [Singel sharedData];
        
        singel.image=[UIImage imageWithData:imageData];
        
        
        self.avatarView.image=singel.image;
        
    }

    
    
    
    [[NSUserDefaults standardUserDefaults] setObject:self.nameText.text forKey:@"name"];
    [[NSUserDefaults standardUserDefaults] setObject:self.phoneText.text forKey:@"phone"];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [peoplePicker dismissViewControllerAnimated:YES completion:^{
        NULL;
    }];



}
#endif



-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [peoplePicker dismissViewControllerAnimated:YES completion:^{
        NULL;
    }];
}




- (IBAction)addToScreen:(UIButton *)sender {
    
    
    
    [[NSUserDefaults standardUserDefaults] setObject:self.nameText.text forKey:@"name"];
    [[NSUserDefaults standardUserDefaults] setObject:self.phoneText.text forKey:@"phone"];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
    
    if ([[Singel sharedData] image]==nil) {
        [SVProgressHUD showErrorWithStatus:@"头像不能为空！"];
        
        return;
    }
    
    if ([self.nameText.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"名字不能为空！"];
        return;
    }
    
    
    if ([self.phoneText.text isEqualToString:@""]) {
        
        [SVProgressHUD showErrorWithStatus:@"号码不能为空！"];
        return;
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://127.0.0.1:8080/index.html"]];
    
    
}
@end
