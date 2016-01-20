//
//  HMacro.h
//  Harassment
//
//  Created by EverZones on 15/11/9.
//  Copyright (c) 2015年 EverZones. All rights reserved.
//
#import <UIKit/UIKit.h>
#ifndef Harassment_HMacro_h
#define Harassment_HMacro_h



#pragma mark -
#pragma mark ID Message

#define VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define BUNDLEID [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]
#define UID [[NSUserDefaults standardUserDefaults]valueForKey:@"uid"]

#pragma mark -
#pragma mark iOS Version

#define IOS_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define IOS_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IOS_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define IOS_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define IS_IOS7 (BOOL)([[[UIDevice currentDevice] systemVersion]floatValue]>=7.0 ? YES : NO)//系统
#define IS_IOS8 (BOOL)([[[UIDevice currentDevice] systemVersion]floatValue]>=8.0 ? YES : NO)//系统

#pragma mark -
#pragma mark Frame Geometry

#define CENTER_VERTICALLY(parent,child) floor((parent.frame.size.height - child.frame.size.height) / 2)
#define CENTER_HORIZONTALLY(parent,child) floor((parent.frame.size.width - child.frame.size.width) / 2)

// example: [[UIView alloc] initWithFrame:(CGRect){CENTER_IN_PARENT(parentView,500,500),CGSizeMake(500,500)}];
#define CENTER_IN_PARENT(parent,childWidth,childHeight) CGPointMake(floor((parent.frame.size.width - childWidth) / 2),floor((parent.frame.size.height - childHeight) / 2))
#define CENTER_IN_PARENT_X(parent,childWidth) floor((parent.frame.size.width - childWidth) / 2)
#define CENTER_IN_PARENT_Y(parent,childHeight) floor((parent.frame.size.height - childHeight) / 2)

#define WIDTH(view) view.frame.size.width
#define HEIGHT(view) view.frame.size.height
#define X(view) view.frame.origin.x
#define Y(view) view.frame.origin.y
#define LEFT(view) view.frame.origin.x
#define TOP(view) view.frame.origin.y
#define BOTTOM(view) (view.frame.origin.y + view.frame.size.height)
#define RIGHT(view) (view.frame.origin.x + view.frame.size.width)

#pragma mark -
#pragma mark Screen size




#endif




