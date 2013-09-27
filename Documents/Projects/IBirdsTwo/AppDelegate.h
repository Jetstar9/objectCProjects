//
//  AppDelegate.h
//  iBirds
//
//  Created by Samuel Westrich on 9/19/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
@private
NSManagedObjectContext *managedObjectContext_;
NSManagedObjectModel *managedObjectModel_;
NSPersistentStoreCoordinator *persistentStoreCoordinator_;
    
}

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) UIWindow *window;

@end
