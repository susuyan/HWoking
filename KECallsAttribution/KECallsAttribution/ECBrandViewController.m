//
//  ECBrandViewController.m
//  KECallsAttribution
//
//  Created by 赵 进喜 on 14/12/16.
//  Copyright (c) 2014年 K.BLOCK. All rights reserved.
//

#import "ECBrandViewController.h"
#import "KEProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFURLRequestSerialization.h"
#import "MessagePhotoMenuItem.h"
#import "SVProgressHUD.h"
#import "MBProgressHUD.h"
@interface ECBrandViewController ()
@property(strong,nonatomic)MBProgressHUD *progressView;
@end

@implementation ECBrandViewController
- (void)dealloc
{
    [_progressView hide:YES];
    
    _progressView=nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.brandImagesView.delegate=self;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void)addPicker:(ZYQAssetPickerController *)picker
{

    [self presentViewController:picker animated:YES completion:nil];

}
-(void)addUIImagePicker:(UIImagePickerController *)picker
{

    [self presentViewController:picker animated:YES completion:nil];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
//{
//    [self.view endEditing:YES];
//
//
//
//}
//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark 得到logo
- (IBAction)getLogoImage:(UIButton *)sender {
    
    
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"选择企业Logo"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"打开照相机", @"从手机相册获取",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];

    
    
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *image=[[UIImagePickerController alloc]init];
    image.allowsEditing=YES;
    
    
    
    
    
    
    
    
    switch (buttonIndex) {
        case 0:
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                image.sourceType=UIImagePickerControllerSourceTypeCamera;
                image.delegate=self;
                [self presentViewController:image animated:YES completion:nil];

            }
            
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
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    
   
    _logoImage= [info objectForKey:UIImagePickerControllerEditedImage];
    
    
    
    
    [self.logoButton setBackgroundImage:_logoImage forState:UIControlStateNormal];
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

- (IBAction)submitInfo:(UIButton *)sender {
    
    
    NSMutableArray *pics=[NSMutableArray array];
    
    
    for (MessagePhotoMenuItem *item in self.brandImagesView.itemArray) {
        
        
        [pics addObject:item.contentImage];
        
        
    }
    
    
    
    
    
   
    
    
   
    
    
     if([self checkValidityTextField])
     {
     
     
     
         
         
         
         
         
        [self uploadMutipartPicsWithPics:pics];
         
         
         
         
         
     
     
     }
    
    
    
    
    
}

- (IBAction)hideKeyboard:(UITapGestureRecognizer *)sender {
    
    
    
    [self.view endEditing:YES];
    
    
}

- (IBAction)backButtonPrssed:(UIButton *)sender {
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}



#pragma mark checkValidityTextField Null
- (BOOL)checkValidityTextField
{
    
    if (self.emailText.text==nil||[self.emailText.text isEqualToString:@""]) {
        
        
        [KEProgressHUD mBProgressHUD:self.view :@"邮箱不能为空" ];
        
        
        
        return NO;
    }
    if (self.nameText.text==nil||[self.nameText.text isEqualToString:@""]) {
        
        
        
         [KEProgressHUD mBProgressHUD:self.view :@"企业名不能为空" ];
        
        return NO;
    }
    if (self.telText.text==nil||[self.telText.text isEqualToString:@""]) {
        
       [KEProgressHUD mBProgressHUD:self.view :@"联系电话不能为空" ];
        
        return NO;
    }
    if (self.noInfo.text==nil||[self.noInfo.text isEqualToString:@""]) {
        
        [KEProgressHUD mBProgressHUD:self.view :@"电话信息不能为空" ];
        
        return NO;
    }
    if (self.infoText.text==nil||[self.infoText.text isEqualToString:@""]) {
        
        [KEProgressHUD mBProgressHUD:self.view :@"公司信息不能为空" ];
        
        return NO;
    }
    if (self.logoImage==nil) {
        
        [KEProgressHUD mBProgressHUD:self.view :@"公司logo不能为空" ];
        
        return NO;
    }

    if (self.brandImagesView.photoMenuItems==nil||self.brandImagesView.photoMenuItems.count==0) {
        
        [KEProgressHUD mBProgressHUD:self.view :@"营业执照不能为空" ];
        
        return NO;
    }


    
    return YES;
    
}





- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    
    
    if (textField==self.emailText) {
        
        
        if ([textField text] != nil && [[textField text] length]!= 0) {
            
            if (![self isValidateEmail:textField.text]) {
                
                [KEProgressHUD mBProgressHUD:self.view :@"邮箱格式不正确"];
            }
        }

        
    }


}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    if (textField==self.nameText) {
        
        [self.telText becomeFirstResponder];
        
        
    } else if (textField==self.telText) {
        
        [self.emailText becomeFirstResponder];
        
        
    }else if (textField==self.emailText) {
        
        [self.webText becomeFirstResponder];
        
        
    }



    
    
   
    
    return YES;
}






//利用正则表达式验证邮箱的合法性
-(BOOL)isValidateEmail:(NSString *)email {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
    
}




-(void)submitBrandInfoWithName:(NSString *)name tel:(NSString *)tel email:(NSString *)email website:(NSString *)web
                       telInfo:(NSString *)telInfo detail:(NSString *)detail logo:(NSString *)logo pics:(NSString *)pics
{

    
    self.progressView= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    self.progressView.labelText=@"正在上传企业信息...";

    
    if (telInfo==nil) {
        telInfo=@"";
    }
    
    if (detail==nil) {
       detail=@"";
    }
    
    if (web==nil) {
        web=@"";
    }

    if (logo==nil) {
        logo=@"";
    }
    
    if (pics==nil) {
        pics=@"";
    }
    
    
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithObjectsAndKeys:name,@"brand_name",tel,@"telephone",email,@"email",telInfo,@"numbers",detail,@"detail",web,@"website",logo,@"logo",pics,@"attachments", nil];
    
    
    NSDictionary *info=[NSDictionary dictionaryWithObjectsAndKeys:dic,@"info", nil];
    
    
    

    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    
    [manager setRequestSerializer:[AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers]];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html", nil];
    
   [manager POST:[NSString stringWithFormat:@"http://www.93app.com/laidianguishu/register_a_new_brand.php?ucode=%@&version=%@",UID,VERSION] parameters:info success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
       
       if ([[responseObject objectForKey:@"status"]intValue]==1) {
           
           
           [self.progressView hide:YES];
           
           [SVProgressHUD showSuccessWithStatus:@"企业信息提交成功！"];
       }else
       {
        [self.progressView hide:YES];
       
        [SVProgressHUD showErrorWithStatus:@"提交失败，企业信息已存在或服务故障，稍后再试！"];
       }
       
       
       
       
   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
       
       
        [self.progressView hide:YES];
       
       
       
       [SVProgressHUD showErrorWithStatus:@"提交失败，企业信息已存在或服务故障，稍后再试！"];
       
       
       
   }];







}
//- (NSMutableURLRequest *)multipartFormRequestWithMethod:(NSString *)method
//                                              URLString:(NSString *)URLString
//                                             parameters:(NSDictionary *)parameters
//                              constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
//                                                  error:(NSError * __autoreleasing *)error;









-(void)uploadMutipartPicsWithPics:(NSArray *)pics
{

   self.progressView= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    self.progressView.labelText=@"正在上传企业执照...";
    
  
    AFHTTPRequestSerializer *seializer=[[AFHTTPRequestSerializer alloc]init];
    
    NSMutableURLRequest *request=[seializer multipartFormRequestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"http://www.93app.com/laidianguishu/proc/upload_image.php?ucode=%@&version=%@&type=multi",UID,VERSION] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
        
        for (int i=0;i<pics.count; i++ ) {
            
            
            UIImage *image=[pics objectAtIndex:i];
            
            
            
            NSData *data=UIImageJPEGRepresentation(image, 1.0);
            
            if (data.length>1024*1024*2) {
                data=UIImageJPEGRepresentation(image,0.8);

            }
            
            
            
            NSString *name=[NSString stringWithFormat:@"pic%d",i+1];
            
            [formData appendPartWithFileData:data name:name fileName:[NSString stringWithFormat:@"%@.jpg",name] mimeType:@"image/jpeg"];
            
            
            
            
            
            
            
        }
        
        
       
        
        
        
        
    } error:nil];
    
    
    
    
    
    AFHTTPRequestOperation *op=[[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    op.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html", nil];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        

        
        
        if ([[responseObject objectForKey:@"pic1"][@"status"]intValue]==1) {
            
            
            
            
            
            _attachments=[responseObject objectForKey:@"pic1"][@"img_url"];
            
            
            
        }else
        {
        
            
            
            
            [SVProgressHUD showErrorWithStatus:@"企业执照1上传失败！"];

        
        
        }
        
        
        if ([[responseObject objectForKey:@"pic2"][@"status"]intValue]==1) {
            
            
           
            
            
            _attachments=[NSString stringWithFormat:@"%@,%@",_attachments,[responseObject objectForKey:@"pic2"][@"img_url"]];
            
            
        }else
        {
            
           
            
            
            [SVProgressHUD showErrorWithStatus:@"企业执照2上传失败！"];
            
            
            
        }
        
        
        if ([[responseObject objectForKey:@"pic3"][@"status"]intValue]==1) {
            
            
           
            
             _attachments=[NSString stringWithFormat:@"%@,%@",_attachments,[responseObject objectForKey:@"pic3"][@"img_url"]];
            
            
        }else
        {
            
            
            
            [SVProgressHUD showErrorWithStatus:@"企业执照3上传失败！"];
            
            
            
        }

        
        
        [self.progressView hide:YES];

        
        
         [self uploadLogoWithImage:self.logoImage];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        NSLog(@"%@",error);
        
        
        [self.progressView hide:YES];
        
        
        [SVProgressHUD showErrorWithStatus:@"企业执照上传失败！"];
        
        
    }];
    
    

    [op start];







}



-(void)uploadLogoWithImage:(UIImage *)logo
{

    
  //  http://93app.com/laidianguishu/uploads/201412/23/pic.945.jpg
    
    
    

    self.progressView= [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    self.progressView.labelText=@"正在上传logo...";
    
    
    AFHTTPRequestSerializer *seializer=[[AFHTTPRequestSerializer alloc]init];
    
    NSMutableURLRequest *request=[seializer multipartFormRequestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"http://www.93app.com/laidianguishu/proc/upload_image.php?ucode=%@&version=%@&type=single",UID,VERSION] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
        
        
            
            NSData *data=UIImageJPEGRepresentation(logo, 1.0);
            
            if (data.length>1024*1024*2) {
                data=UIImageJPEGRepresentation(logo,0.8);
                
            }
            
            
            
            NSString *name=[NSString stringWithFormat:@"pic"];
            
            [formData appendPartWithFileData:data name:name fileName:[NSString stringWithFormat:@"%@.jpg",name] mimeType:@"image/jpeg"];
            
            
            
            
            
            
            
        
        
        
        
        
        
        
        
    } error:nil];
    
    
    
    
    
    AFHTTPRequestOperation *op=[[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    op.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html", nil];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        if ([[responseObject objectForKey:@"status"]intValue]==1) {
            
            
            [self.progressView hide:YES];
            
            
            _logoUrl=[responseObject objectForKey:@"img_path"];
            
            
            [self submitBrandInfoWithName:_nameText.text tel:_telText.text email:_emailText.text website:_webText.text telInfo:_noInfo.text detail:_infoText.text logo:_logoUrl pics:_attachments];
            
            
        }else
        {
            
            [self.progressView hide:YES];
            
            
            [SVProgressHUD showErrorWithStatus:@"企业logo上传失败！"];
            
            
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        NSLog(@"%@",error);
        
        
        [self.progressView hide:YES];
        
        
        [SVProgressHUD showErrorWithStatus:@"企业logo上传失败！"];
        
        
    }];
    
    
    
    [op start];
    
    




}





@end
