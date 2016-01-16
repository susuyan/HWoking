//
//  EZFeedBackViewController.m
//  KECallsAttribution
//
//  Created by 赵 进喜 on 15/3/12.
//  Copyright (c) 2015年 K.BLOCK. All rights reserved.
//

#import "EZFeedBackViewController.h"

@interface EZFeedBackViewController ()<JSMessagesViewDelegate, JSMessagesViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) NSMutableArray *messageArray;
@property (nonatomic,strong) UIImage *willSendImage;
@property (strong, nonatomic) NSMutableArray *timestamps;
@end

@implementation EZFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.delegate = self;
    self.dataSource = self;
    
    self.title = @"意见反馈";
    
    self.messageArray = [NSMutableArray array];
    self.timestamps = [NSMutableArray array];
    [self initNav];
    
    
    self.feedback = [UMFeedback sharedInstance];
    self.feedback.delegate = self;
    [self.feedback get];
    // Do any additional setup after loading the view.
}
-(void)initNav
{



    UIButton *back =[UIButton buttonWithType:UIButtonTypeCustom];
    
    back.frame=CGRectMake(0,0,32, 32);
    
    
    [back setImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(dismisView) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]initWithCustomView:back];
    
    
    self.navigationItem.leftBarButtonItem=backItem;





}
-(void)dismisView
{


    [self dismissViewControllerAnimated:YES completion:nil];


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageArray.count;
}

#pragma mark - Messages view delegate
- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{
    [self.messageArray addObject:[NSDictionary dictionaryWithObject:text forKey:@"content"]];
    
//    [self.timestamps addObject:[NSDate date]];

    
    [self.feedback post:@{@"content":text}];
    
    if((self.messageArray.count - 1) % 2)
        [JSMessageSoundEffect playMessageSentSound];
    else
        [JSMessageSoundEffect playMessageReceivedSound];
    
    [self finishSend];
}


- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *reply=self.messageArray[indexPath.row];
    
    
    if ([reply[@"type"] isEqualToString:@"dev_reply"]){
        return JSBubbleMessageTypeIncoming;
    }else{
        return JSBubbleMessageTypeOutgoing;
    }
//    return (indexPath.row % 2) ? JSBubbleMessageTypeIncoming : JSBubbleMessageTypeOutgoing;
}

- (JSBubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return JSBubbleMessageStyleFlat;
}

- (JSBubbleMediaType)messageMediaTypeForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if([[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"Text"]){
//        return JSBubbleMediaTypeText;
//    }else if ([[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"Image"]){
//        return JSBubbleMediaTypeImage;
//    }
//    
//    return -1;
    
    return JSBubbleMediaTypeText;
}

- (UIButton *)sendButton
{
    return [UIButton defaultSendButton];
}

- (JSMessagesViewTimestampPolicy)timestampPolicy
{
    /*
     JSMessagesViewTimestampPolicyAll = 0,
     JSMessagesViewTimestampPolicyAlternating,
     JSMessagesViewTimestampPolicyEveryThree,
     JSMessagesViewTimestampPolicyEveryFive,
     JSMessagesViewTimestampPolicyCustom
     */
    return JSMessagesViewTimestampPolicyCustom;
}

- (JSMessagesViewAvatarPolicy)avatarPolicy
{
    /*
     JSMessagesViewAvatarPolicyIncomingOnly = 0,
     JSMessagesViewAvatarPolicyBoth,
     JSMessagesViewAvatarPolicyNone
     */
    return JSMessagesViewAvatarPolicyBoth;
}

- (JSAvatarStyle)avatarStyle
{
    /*
     JSAvatarStyleCircle = 0,
     JSAvatarStyleSquare,
     JSAvatarStyleNone
     */
    return JSAvatarStyleSquare;
}

- (JSInputBarStyle)inputBarStyle
{
    /*
     JSInputBarStyleDefault,
     JSInputBarStyleFlat
     
     */
    return JSInputBarStyleFlat;
}

//  Optional delegate method
//  Required if using `JSMessagesViewTimestampPolicyCustom`
//
//  - (BOOL)hasTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
//

#pragma mark - Messages view data source
- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"content"]){
        return [[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"content"];
    }
    return nil;
}

- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *time=[self.messageArray[indexPath.row][@"created_at"]stringValue];
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm"];
    
    NSDate *date=[formatter dateFromString:time];
    
    
    return date;
    
    //return [self.timestamps objectAtIndex:indexPath.row];
}

- (UIImage *)avatarImageForIncomingMessage
{
    return [UIImage imageNamed:@"fb_default_dev_portrait"];
}

- (UIImage *)avatarImageForOutgoingMessage
{
    return [UIImage imageNamed:@"fb_default_user_portrait"];
}

- (id)dataForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"Image"]){
        return [[self.messageArray objectAtIndex:indexPath.row] objectForKey:@"Image"];
    }
    return nil;
    
}



- (void)getFinishedWithError: (NSError *)error
{

    NSLog(@"%@",self.feedback.topicAndReplies);
    
    
    
    if (error==nil) {
        
        
        self.messageArray=self.feedback.topicAndReplies;
        
        
        
        
        [self.tableView reloadData];
        
        
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
    }else
    {
    
        
        if (self.messageArray.count==0) {
            
            [self.messageArray insertObject:@{@"content":@"您好，我是产品经理，欢迎您给我们提产品的使用感受和建议！",@"created_at":@"0",@"is_failed":@"0",@"reply_id":@"553de9c7ec12c68aaffef408",@"type":@"dev_reply"} atIndex:0];
            
            
            
        }

    
    
    }


}
- (void)postFinishedWithError:(NSError *)error
{


   NSLog(@"%@",self.feedback.topicAndReplies);
    if (error==nil) {
        [self.tableView reloadData];

    }

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
