//
//  ECBrandViewController.h
//  KECallsAttribution
//
//  Created by 赵 进喜 on 14/12/16.
//  Copyright (c) 2014年 K.BLOCK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessagePhotoView.h"
@interface ECBrandViewController : UITableViewController<MessagePhotoViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet MessagePhotoView *brandImagesView;
- (IBAction)getLogoImage:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *logoButton;
@property(strong,nonatomic)UIImage *logoImage;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *telText;
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UITextField *webText;
@property (weak, nonatomic) IBOutlet UITextView *noInfo;
@property (weak, nonatomic) IBOutlet UITextView *infoText;

@property(strong,nonatomic)NSString *logoUrl;
@property(strong,nonatomic)NSString *attachments;


- (IBAction)submitInfo:(UIButton *)sender;
- (IBAction)hideKeyboard:(UITapGestureRecognizer *)sender;
- (IBAction)backButtonPrssed:(UIButton *)sender;
@end
