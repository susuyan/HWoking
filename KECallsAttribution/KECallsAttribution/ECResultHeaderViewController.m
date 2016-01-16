//
//  ECResultHeaderViewController.m
//  Utilities
//
//  Created by 赵 进喜 on 14-7-23.
//  Copyright (c) 2014年 everzones. All rights reserved.
//

#import "ECResultHeaderViewController.h"
#import "UIImageView+WebCache.h"
@interface ECResultHeaderViewController ()

@end

@implementation ECResultHeaderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)setInfo:(NSDictionary *)item
{


    self.nameLbl.text=[item objectForKey:@"name"];
    
    self.manuLbl.text=[item objectForKey:@"manu"];
    
    
    self.brandLbl.text=[item objectForKey:@"brand"];
    
    self.specLbl.text=[item objectForKey:@"spec"];
    
    self.priceLbl.text=[NSString stringWithFormat:@"%@元",[item objectForKey:@"price"]];
    
    self.gtinLbl.text=[item objectForKey:@"gtin"];

    NSString *url=[item objectForKey:@"image"];
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:url ] placeholderImage:nil];




}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
