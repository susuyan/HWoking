//
//  KBAppDelegate.h
//  KECallsAttribution
//
//  Created by lichenWang on 14-4-2.
//  Copyright (c) 2014年 K.BLOCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KBAppDelegate : UIResponder <UIApplicationDelegate>
{
     NSTimer *checkTime;
   UIBackgroundTaskIdentifier backgroundTask;
}
@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
