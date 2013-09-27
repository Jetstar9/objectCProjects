//
//  BirdParser.m
//  iBirds
//
//  Created by Samuel Westrich on 10/12/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import "BirdParser.h"
#import "CJSONDeserializer.h"
#import "AppDelegate.h"
#import "DateUtils.h"
#import "JSONParser+Protected.h"
#define logParser 1

@implementation BirdParser

@synthesize user;
@synthesize bird;
@synthesize baseLocation_lat;
@synthesize baseLocation_lon;
@synthesize topKeysToAdd;

-(void)dealloc {
    [user release];
    [bird release];
    [baseLocation_lat release];
    [baseLocation_lon release];
    [topKeysToAdd release];
    [super dealloc];
}

-(User*)getUserWithId:(NSString*)userId {
	NSManagedObjectContext *context = [((AppDelegate*)[UIApplication sharedApplication].delegate) managedObjectContext];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" 
											  inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	[fetchRequest setFetchLimit:1];
	[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"userId == %@",userId]];
	
	NSError *error;
	
	NSArray *users = [context executeFetchRequest:fetchRequest error:&error];
	[fetchRequest release];
	if ([users count] < 1) {
		return nil;
	} else  {
		return [users objectAtIndex:0];
	}
}

-(NSSet*)getDateFields {
	NSSet * set = [NSSet setWithObjects:@"creationDate",@"lastModificationDate",@"gatheringStartTime",nil];
	return set;
}

-(NSSet*)getBoolFields {
	NSSet * set = [NSSet setWithObjects:@"beingCaptured",nil];
	return set;
}
-(NSSet*)getNumberFields {
	NSSet * set = [NSSet setWithObjects:@"goldCoins",@"level",@"status",@"currentFood",@"base_location_lat",@"base_location_lon",@"gatheringParam4",@"gatheringParam1",@"gatheringParam2",@"gatheringParam3",@"foodLimitForLevel",@"foodGatherRate",@"foodGatheringTimeRemaining",nil];
	return set;	
}

-(NSArray*)getLocationFields {
	NSArray * array = [NSArray arrayWithObjects:@"baseLocation",@"base_location_lat",@"base_location_lon",nil]; //format is client name serverLat serverLon
	return array;	
}



-(void)addItemsToTranslator {
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:@"birdId",@"birdid",@"name",@"bird_name",@"ownerId",@"owner_userid",@"beingCaptured",@"capturing",@"currentFood",@"current_food",@"creationDate",@"created_date",@"goldCoins",@"gold_coins",@"lastModificationDate",@"last_modified_date",@"gatheringFn",@"gathering_fn",@"gatheringStartTime",@"gathering_start_time",@"gatheringParam1",@"gathering_param1",@"gatheringParam2",@"gathering_param2",@"gatheringParam3",@"gathering_param3",@"gatheringParam4",@"gathering_param4",@"foodGatheringTimeRemaining",@"food_gather_time_remaining",@"foodGatherRate",@"food_gather_rate",@"foodLimitForLevel",@"food_limit_for_level",nil];
	[translator addEntriesFromDictionary:dict];	
}


- (NSArray*)getTopKeys {
    if (topKeysToAdd)
        return  [[NSArray arrayWithObject:@"data"] arrayByAddingObjectsFromArray:topKeysToAdd];
    else
        return [NSArray arrayWithObject:@"data"];
}

- (NSInteger)topKeyCount {  //top keys are in case everything is incapsulated at the top in a dictionary with only one key/value pair
	return 1 + [topKeysToAdd count];
}

- (void)setValue:(id)value forKey:(NSString*)key forManagedObject:(NSManagedObject*)managedObject {
    if ([key isEqualToString:@"ownerId"]) {
            User * lUser = [self getUserWithId:value];
        [managedObject setValue:lUser forKey:@"owner"];
    } else if ([[self getLocationFields] containsObject:key]) {
        if ([key isEqualToString:@"base_location_lat"])
            self.baseLocation_lat = value;
        else if ([key isEqualToString:@"base_location_lon"])
            self.baseLocation_lon = value;
        if (self.baseLocation_lat && self.baseLocation_lon) { 
            CLLocation * location = [[CLLocation alloc] initWithLatitude:[self.baseLocation_lat floatValue] longitude:[self.baseLocation_lon floatValue]];
            [super setValue:location forKey:@"baseLocation" forManagedObject:managedObject];
            [location release];
            self.baseLocation_lat = nil;
            self.baseLocation_lon = nil;
        }
    } else {
         [super setValue:value forKey:key forManagedObject:managedObject];
     }
}

-(NSString*)testReturnedBirdIsCorrect:(NSDictionary*)birdDictionary withinManagedObjectContext:(NSManagedObject*)managedObject { //will return nil if there are no problems
	Boolean hasProblem = FALSE;
	NSMutableString * mString = [[NSMutableString alloc] init];	
	for(id keyT in birdDictionary) {
        NSString * key;
        if ([translator objectForKey:keyT]) {
            key = [translator objectForKey:keyT];
        } else {
            key = keyT;
        }
		if (![[[managedObject entity] attributesByName] objectForKey:key]) {
			if ([key isEqualToString:@"ownerId"]) continue;
            if ([key isEqualToString:@"base_location_lat"]) continue;
            if ([key isEqualToString:@"base_location_lon"]) continue;
			if (!hasProblem) {
				[mString appendString:@"Bird returned has properties that are not in our model :\n"];
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
		NSLog(@"%@",@"No Birds found");
#endif
		return nil;
	} else  {
		return [birds objectAtIndex:0];
	}
}


- (NSManagedObject*)managedObjectFromStructure:(NSDictionary*)structureDictionary withManagedObjectContext:(NSManagedObjectContext*)moc
{
#ifdef logParser
	NSLog(@"%@",@"atBirdParser");
	NSLog(@"%@",structureDictionary);
#endif
    Bird * lBird = self.bird;
    if (!lBird)
         lBird = [self birdWithId:[structureDictionary objectForKey:@"birdid"]];
	if (!lBird) 
        lBird = (Bird*)[NSEntityDescription insertNewObjectForEntityForName:@"Bird" inManagedObjectContext:moc];
	NSString * log = [self testReturnedBirdIsCorrect:structureDictionary withinManagedObjectContext:(NSManagedObject*)lBird];
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
		[self setValue:[self switchTypesFromString:[structureDictionary valueForKey:keyT] forKey:key] forKey:key forManagedObject:(NSManagedObject*)lBird];
	}
	//NSManagedObjectContext *context = [((AppDelegate*)[UIApplication sharedApplication].delegate) managedObjectContext];
	/*if ( [user currentToken]) {
     [context deleteObject:[tempUser currentToken]];
     }
     [tempUser setCurrentToken:(Session*)managedObject];*/
	return (NSManagedObject*)lBird;
}


@end
