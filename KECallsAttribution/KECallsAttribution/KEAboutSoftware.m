//
//  KEAboutSoftware.m
//  KETrain
//
//  Created by Kernel on 13-9-26.
//  Copyright (c) 2013年 Kernel. All rights reserved.
//

#import "KEAboutSoftware.h"

@interface KEAboutSoftware ()

@end

@implementation KEAboutSoftware

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.versionLbl.text=[NSString stringWithFormat:@"当前版本：%@",VERSION];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
