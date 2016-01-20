//
//  HLocaleSettingsController.m
//  Harassment
//
//  Created by EverZones on 15/11/9.
//  Copyright (c) 2015年 EverZones. All rights reserved.
//

#import "HLocaleSettingsController.h"
#import <sqlite3.h>
@interface HLocaleSettingsController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *localeMessageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *localeMessageViewToBottomConstranint;

@end

@implementation HLocaleSettingsController

#pragma mark Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_button"] style:UIBarButtonItemStyleDone target:self action:@selector(backAction:)];
    backItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = backItem;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.localeLabel.text = [defaults stringForKey:@"localeString"];
    [defaults synchronize];
    
    [self addKeyboardNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    [self removeKeyboardNotification];
}
#pragma mark - IBAction
- (void)backAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)affirmAction:(UIButton *)sender {

    [self.queryTextField resignFirstResponder];
    [[NSUserDefaults standardUserDefaults] setObject:self.localeLabel.text forKey:@"localeString"];
    [self popControllerAndPostNotification];
}
- (IBAction)localeButtonAction:(RadioButton *)sender {
    [[NSUserDefaults standardUserDefaults] setObject:sender.titleLabel.text forKey:@"localeString"];
    [self popControllerAndPostNotification];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Private 
- (void)popControllerAndPostNotification {
    [self backAction:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateNumberPlate" object:nil];
}

- (void)addKeyboardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

}
- (void)removeKeyboardNotification {

    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardWillShow:(NSNotification *)noti {
    [UIView animateWithDuration:0.3 animations:^{
        self.localeMessageViewToBottomConstranint.constant = 216;
        self.localeMessageView.hidden = NO;
        [self.localeMessageView setNeedsUpdateConstraints];
    }];
    

}
- (void)keyboardWillHide:(NSNotification *)noti {
    [UIView animateWithDuration:0.3 animations:^{
        self.localeMessageViewToBottomConstranint.constant = 0;
        [self.localeMessageView setNeedsUpdateConstraints];
        self.localeMessageView.hidden = YES;
    }];
    
}
#pragma mark - UITextField delegate 
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *str;
    str = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"(" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@")" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    str = [[str componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
    str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (str.length == 7) {
        [self inquiryWithNumber:str];
    }
    
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    self.localeLabel.text = @"";
    return YES;
}
#pragma mark - QueryNumber
- (void)inquiryWithNumber:(NSString *)phoneNumber{
    
    //打开数据库
    NSString *databaseFilePath = [[NSBundle mainBundle] pathForResource:@"database"
                                                                 ofType:@"sqlite3"];
    NSString * string = [phoneNumber substringToIndex:7];
    NSString *query;
    if ([[self checkCarriers:string] isEqualToString:@"MOBILE130131"]) {
        query = @"SELECT * FROM MOBILE130131 WHERE phoneNmber=?";
    }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE132133"]) {
        query = @"SELECT * FROM MOBILE132133 WHERE phoneNmber=?";
    }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE134135"]) {
        query = @"SELECT * FROM MOBILE134135 WHERE phoneNmber=?";
    }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE136137"]) {
        query = @"SELECT * FROM MOBILE136137 WHERE phoneNmber=?";
    }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE138139"]) {
        query = @"SELECT * FROM MOBILE138139 WHERE phoneNmber=?";
    }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE145147"]) {
        query = @"SELECT * FROM MOBILE145147 WHERE phoneNmber=?";
    }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE150151"]) {
        query = @"SELECT * FROM MOBILE150151 WHERE phoneNmber=?";
    }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE152153"]) {
        query = @"SELECT * FROM MOBILE152153 WHERE phoneNmber=?";
    }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE155156"]) {
        query = @"SELECT * FROM MOBILE155156 WHERE phoneNmber=?";
    }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE157158"]) {
        query = @"SELECT * FROM MOBILE157158 WHERE phoneNmber=?";
    }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE159180"]) {
        query = @"SELECT * FROM MOBILE159180 WHERE phoneNmber=?";
    }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE181182"]) {
        query = @"SELECT * FROM MOBILE181182 WHERE phoneNmber=?";
    }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE183184"]) {
        query = @"SELECT * FROM MOBILE183184 WHERE phoneNmber=?";
    }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE185186"]) {
        query = @"SELECT * FROM MOBILE185186 WHERE phoneNmber=?";
    }else if ([[self checkCarriers:string] isEqualToString:@"MOBILE187188189"]) {
        query = @"SELECT * FROM MOBILE187188189 WHERE phoneNmber=?";
    }else{
        
        return;
    }
    sqlite3 *database;
    if (sqlite3_open([databaseFilePath UTF8String], &database)
        != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"打开数据库失败！");
    }
    //执行查询
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement,nil) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [string UTF8String], -1, NULL);
        //依次读取数据库表格FIELDS中每行的内容，并显示在对应的TextField
        while (sqlite3_step(statement) == SQLITE_ROW) {
            //获得数据
            char *city = (char *)sqlite3_column_text(statement, 2);
           // char *province = (char *)sqlite3_column_text(statement, 1);
            
            //更新View
           // NSString * provinceString = [[NSString alloc] initWithUTF8String:province];
            NSString * cityString = [[NSString alloc] initWithUTF8String:city];
            
        
            [UIView animateWithDuration:0.33 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
            } completion:^(BOOL finished) {
                self.localeMessageView.hidden = NO;
                self.localeLabel.text = [NSString stringWithFormat:@"%@",cityString];
                
                
            }];
        }
        sqlite3_finalize(statement);
    }    //关闭数据库
    sqlite3_close(database);
}
- (NSString*)checkCarriers:(NSString*)string{
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


@end