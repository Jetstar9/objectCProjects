//
//  LoginParser.m
//  iBirds
//
//  Created by Samuel Westrich on 10/11/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import "UserInfoParser.h"
#import "CJSONDeserializer.h"
#import "AppDelegate.h"
#import "DateUtils.h"
#import "JSONParser+Protected.h"

@implementation UserInfoParser

@synthesize user;




-(NSSet*)getDateFields {
	NSSet * set = [NSSet setWithObjects:@"lastModificationDate",@"registrationDate",nil];
	return set;
}

-(NSSet*)getBoolFields {
	NSSet * set = [NSSet setWithObjects:nil];
	return set;
}
-(NSSet*)getNumberFields {
	NSSet * set = [NSSet setWithObjects:@"goldCoins",nil];
	return set;	
}

-(NSArray*)getLocationFields {
    NSArray * array = [NSArray arrayWithObjects:nil]; //format is client name serverLat serverLon
	return array;	
}

-(void)addItemsToTranslator {
    //server side is key -> client side is object
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:@"userId",@"userid",@"cloudPassword",@"unique_identifier",@"avatarLocation",@"picture",@"firstName",@"first_name",@"lastName",@"last_name",@"email",@"email_address",@"registrationDate",@"register_date",@"goldCoins",@"gold_coins",@"lastModificationDate",@"last_modified_date",nil];
	[translator addEntriesFromDictionary:dict];	
}

- (void)setValue:(id)value forKey:(NSString*)key forManagedObject:(NSManagedObject*)managedObject {

     [super setValue:value forKey:key forManagedObject:managedObject];
     
}

-(NSString*)testReturnedUserIsCorrect:(NSDictionary*)userDictionary withinManagedObjectContext:(NSManagedObject*)managedObject { //will return nil if there are no problems
	Boolean hasProblem = FALSE;
	NSMutableString * mString = [[NSMutableString alloc] init];	
	for(id keyT in userDictionary) {
        NSString * key;
        if ([translator objectForKey:keyT]) {
            key = [translator objectForKey:keyT];
        } else {
            key = keyT;
        }
		if (![[[managedObject entity] attributesByName] objectForKey:key]) {
			if ([key isEqualToString:@"birds"]) continue;
			if (!hasProblem) {
				[mString appendString:@"User returned has properties that are not in our model :\n"];
			}
			hasProblem = TRUE;
			[mString appendString:key];
		}
	}
	NSString * string = [NSString stringWithString:mString];
	[mString release];
	if (!hasProblem) {
		return nil;
	}
	return string;
}

-(User*)userWithUserId:(NSString*)userId {
	NSManagedObjectContext *context = [((AppDelegate*)[UIApplication sharedApplication].delegate) managedObjectContext];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" 
											  inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	[fetchRequest setFetchLimit:1];
	[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"userId == %@", userId]];
	
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


- (NSManagedObject*)managedObjectFromStructure:(NSDictionary*)structureDictionary withManagedObjectContext:(NSManagedObjectContext*)moc
{
#ifdef logParser
	NSLog(@"%@",@"atUserInfoParser");
	NSLog(@"%@",structureDictionary);
#endif
	//this will return null if there is already a User with an iD equal to an iD of a User that we are trying to insert
	//NSLog(@"%@",structureDictionary);
    User * lUser = self.user;
    if (!lUser)
        lUser = [self userWithUserId:[structureDictionary objectForKey:@"userid"]];
	if (!lUser) 
        lUser = (User*)[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:moc];
	NSString * log = [self testReturnedUserIsCorrect:structureDictionary withinManagedObjectContext:lUser];
	if (log) {
		NSLog(@"%@",log);
	}
	for(id keyT in structureDictionary) {
        NSString * key;
        if ([translator objectForKey:keyT]) {
            key = [translator objectForKey:keyT];
        } else {
            key = keyT;
        }
		[self setValue:[self switchTypesFromString:[structureDictionary valueForKey:keyT] forKey:key] forKey:key forManagedObject:lUser];
	}
	//NSManagedObjectContext *context = [((AppDelegate*)[UIApplication sharedApplication].delegate) managedObjectContext];
	/*if ( [user currentToken]) {
     [context deleteObject:[tempUser currentToken]];
     }
     [tempUser setCurrentToken:(Session*)managedObject];*/
	return lUser;
}

-(void)dealloc {
    //[user release];
	[super dealloc];
	
}


@end
