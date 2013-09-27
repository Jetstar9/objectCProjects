//
//  IBDataStore.m
//  iBirds
//
//  Created by Samuel Westrich on 10/16/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import "IBDataStore.h"
#import "AppDelegate.h"

static IBDataStore *sharedInstance = nil;

@implementation IBDataStore

-(User*)userWithEmail:(NSString*)email {
	NSManagedObjectContext *context = [((AppDelegate*)[UIApplication sharedApplication].delegate) managedObjectContext];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" 
											  inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	[fetchRequest setFetchLimit:1];
	[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"email == %@", email]];
	
	NSError *error;
	
	NSArray *users = [context executeFetchRequest:fetchRequest error:&error];
	[fetchRequest release];
	if ([users count] < 1) {
#ifdef logParser
		NSLog(@"%@",@"No Users found");
#endif
		return nil;
	} else  {
		return [users objectAtIndex:0];
	}
}

-(Bird*)birdWithId:(NSString*)birdId {
    NSManagedObjectContext *context = [((AppDelegate*)[UIApplication sharedApplication].delegate) managedObjectContext];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Bird" 
											  inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	[fetchRequest setFetchLimit:1];
	[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"birdId == %@", birdId]];
	
	NSError *error;
	
	NSArray *birds = [context executeFetchRequest:fetchRequest error:&error];
	[fetchRequest release];
	if ([birds count] < 1) {
#ifdef logParser
		NSLog(@"%@",@"No Users found");
#endif
		return nil;
	} else  {
		return [birds objectAtIndex:0];
	}
}


-(void)saveContext2 {
    NSManagedObjectContext *context = [((AppDelegate*)[UIApplication sharedApplication].delegate) managedObjectContext];
    NSError * error = nil;
	if (![context save:&error]) {
		
		NSLog(@"Failed to save to data store: %@", [error localizedDescription]);
		NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
		if(detailedErrors != nil && [detailedErrors count] > 0) {
			for(NSError* detailedError in detailedErrors) {
				NSLog(@"  DetailedError: %@", [detailedError localizedDescription]);
			}
		}
		else {
			NSLog(@"  %@", [error userInfo]);
		}
		
	}
}

- (void)saveContext {
    NSManagedObjectContext *context = [((AppDelegate*)[UIApplication sharedApplication].delegate) managedObjectContext];
    NSError * error = nil;
	if (![context save:&error]) {
        // If Cocoa generated the error...
        if ([[error domain] isEqualToString:@"NSCocoaErrorDomain"]) {
            // ...check whether there's an NSDetailedErrors array            
            NSDictionary *userInfo = [error userInfo];
            if ([userInfo valueForKey:@"NSDetailedErrors"] != nil) {
                // ...and loop through the array, if so.
                NSArray *errors = [userInfo valueForKey:@"NSDetailedErrors"];
                for (NSError *anError in errors) {
                    
                    NSDictionary *subUserInfo = [anError userInfo];
                    subUserInfo = [anError userInfo];
                    // Granted, this indents the NSValidation keys rather a lot
                    // ...but it's a small loss to keep the code more readable.
                    NSLog(@"Core Data Save Error\n\n \
                          NSValidationErrorKey\n%@\n\n \
                          NSValidationErrorPredicate\n%@\n\n \
                          NSValidationErrorObject\n%@\n\n \
                          NSLocalizedDescription\n%@", 
                          [subUserInfo valueForKey:@"NSValidationErrorKey"], 
                          [subUserInfo valueForKey:@"NSValidationErrorPredicate"], 
                          [subUserInfo valueForKey:@"NSValidationErrorObject"], 
                          [subUserInfo valueForKey:@"NSLocalizedDescription"]);
                }
            }
            // If there was no NSDetailedErrors array, print values directly
            // from the top-level userInfo object. (Hint: all of these keys
            // will have null values when you've got multiple errors sitting
            // behind the NSDetailedErrors key.
            else {
                NSLog(@"Core Data Save Error\n\n \
                      NSValidationErrorKey\n%@\n\n \
                      NSValidationErrorPredicate\n%@\n\n \
                      NSValidationErrorObject\n%@\n\n \
                      NSLocalizedDescription\n%@", 
                      [userInfo valueForKey:@"NSValidationErrorKey"], 
                      [userInfo valueForKey:@"NSValidationErrorPredicate"], 
                      [userInfo valueForKey:@"NSValidationErrorObject"], 
                      [userInfo valueForKey:@"NSLocalizedDescription"]);
                
            }
        } 
        // Handle mine--or 3rd party-generated--errors
        else {
            NSLog(@"Custom Error: %@", [error localizedDescription]);
        }
    }
}


#pragma mark -
#pragma mark Singleton methods

+ (IBDataStore*)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
			sharedInstance = [[IBDataStore alloc] init];
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (oneway void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}




@end
