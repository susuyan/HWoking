//
//  KEContactCell.m
//  KECallsAttribution
//
//  Created by lichenWang on 14-1-6.
//  Copyright (c) 2014年 KERNEL. All rights reserved.
//

#import "KEContactCell.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <sqlite3.h>
#import "Singel.h"
@interface KEContactCell()
@property (nonatomic, copy)NSString *databaseFilePath;
@end
@implementation KEContactCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)setContact:(KECoreDataContact *)contact{
    _contact = contact;
    
    
    self.contactNameLabel.text = contact.contactName;
    self.phoneNumberLabel.text = contact.contactPhoneNumber;
    self.phoneNmberAreaNameLabel.text = contact.showCallerID;
    if (contact.imageData.length) {
        self.headPortrait.image = [UIImage imageWithData:contact.imageData];
    }else{
        self.headPortrait.image = [UIImage imageNamed:[[Singel sharedData]getHeadImageName]];
    }
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
//        UIImage * imageBcak = [UIImage imageNamed:@"liebiao_tiao"];
//        //UIImage * resizableImageBcak = [imageBcak resizableImageWithCapInsets:UIEdgeInsetsMake(5, 49, 5, 5)];
//        UIImageView * imageViewBcak = [[UIImageView alloc] initWithImage:imageBcak];
//        self.backgroundView = imageViewBcak;
//        
//        UIImage * imageSelected = [UIImage imageNamed:@"liebiao_tiao"];
//        //UIImage * resizableImageSelected = [imageSelected resizableImageWithCapInsets:UIEdgeInsetsMake(1, 55, 1, 1)];
//        UIImageView * imageViewSelected = [[UIImageView alloc] initWithImage:imageSelected];
//        self.selectedBackgroundView = imageViewSelected;
//        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
