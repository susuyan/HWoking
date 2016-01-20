//
//  ECCheaterCell.m
//  KECallsAttribution
//
//  Created by 赵 进喜 on 14/12/18.
//  Copyright (c) 2014年 K.BLOCK. All rights reserved.
//

#import "ECCheaterCell.h"

@implementation ECCheaterCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)appealLbl:(UIButton *)sender {
    
    [self showMailPicker:nil];
    
}

//-(void)layoutSubviews
//{
//    
//    
//    
//    
//    
//    
//    
//
//    [self.contentView setNeedsLayout];
//    [self.contentView layoutIfNeeded];
//    
//    CGFloat height = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//    
//    
//    self.frame=CGRectMake( self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height+1);
//    
//    
//    
//    
//
//
//
//}


+ (int)getCellHeightWith:(NSString *)detail font:(UIFont *)font width:(float)width {

    int height;
    
    CGSize size= [detail sizeWithFont:font constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];

    
    height=87+size.height;
    
    
    return height;


}


-(void)setInfo:(NSDictionary *)info {


    self.telText.text=info[@"number"];
    
    
    NSString *time=info[@"create_time"];
    
    
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:[time intValue]];
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    
    
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    time=[formatter stringFromDate:date];
    
    
    self.timeLbl.text=time;
    
    self.detailLbl.numberOfLines = 0;
    self.detailLbl.text=info[@"detail"];
    
    
    
    self.sourceLbl.text=[NSString stringWithFormat:@"来源：%@",info[@"ip"]];
    
}



- (void)showMailPicker:(id)sender
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil){
        // We must always check whether the current device is configured for sending emails
        if ([mailClass canSendMail]){
            [self displayComposerSheet];
        }else{
            [self launchMailAppOnDevice];
        }
    }else{
        [self launchMailAppOnDevice];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

-(void)launchMailAppOnDevice
{
    
}
-(void)displayComposerSheet
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    [picker setToRecipients:[NSArray arrayWithObject:@"support@93app.com"]];
    [picker setSubject:@"号码申诉-手机归属地"];
    picker.title = @"号码申诉";
    [picker setMessageBody:self.telText.text isHTML:NO];
    
    
    
    UIViewController *vc= [[UIApplication sharedApplication]keyWindow].rootViewController;
    if (vc.presentedViewController.presentedViewController==nil) {
        [vc.presentedViewController presentViewController:picker animated:YES completion:nil];
    }else
    {
    
         [vc.presentedViewController.presentedViewController presentViewController:picker animated:YES completion:nil];
    
    }
    
    
   
    
    //[self.contentView.window.rootViewController presentViewController:picker animated:YES completion:nil];
}


@end
