//
//  IBDataStore.h
//  iBirds
//
//  Created by Samuel Westrich on 10/16/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "User.h"

@interface IBDataStore : NSObject

+(IBDataStore*)sharedInstance;

-(User*)userWithEmail:(NSString*)email;

-(Bird*)birdWithId:(NSString*)birdId;

-(void)saveContext;

@end
