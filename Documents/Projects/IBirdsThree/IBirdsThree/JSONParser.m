//
//  JSONParser.m
//  Adylitica
//
//  Created by Samuel Westrich on 10/11/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import "JSONParser+Protected.h"
#import "CJSONDeserializer.h"
#import "AppDelegate.h"
#import "DateUtils.h"
#import <CoreLocation/CoreLocation.h>

@interface JSONParser()
@property(nonatomic,retain)NSData * toParseJSONData;

- (NSArray*)getTopKeys;
- (NSInteger)topKeyCount;

-(NSSet*)getDateFields;
-(NSSet*)getBoolFields;
-(NSSet*)getNumberFields;
-(NSArray*)getLocationFields;

@end


@implementation JSONParser

@synthesize toParseJSONData;
@synthesize multiple;
@synthesize translator;

-(void)dealloc {
    [toParseJSONData release];
    [translator release];
    [super dealloc];
}

-(Boolean)string:(NSString*)string isInSet:(NSSet*)set {
	for	(NSString * item in set) {
		if ([item isEqualToString:string]) return TRUE;
	}
	return FALSE;
}

-(NSSet*)getDateFields {
	NSSet * set = [NSSet setWithObjects:nil];
	return set;
}

-(NSSet*)getBoolFields {
	NSSet * set = [NSSet setWithObjects:nil];
	return set;
}
-(NSSet*)getNumberFields {
	NSSet * set = [NSSet setWithObjects:nil];
	return set;	
}

-(NSArray*)getLocationFields {
    NSArray * array = [NSArray arrayWithObjects:nil]; //format is client name serverLat serverLon
	return array;	
}

-(id)switchTypesFromString:(id)possibilityToSwitch forKey:(NSString*)key {
	
	if ([possibilityToSwitch isKindOfClass:[NSString class]]) {
		if ([self string:key isInSet:[self getBoolFields]]) {
			if ([[possibilityToSwitch lowercaseString] isEqualToString:@"true"]) {
				return [NSNumber numberWithBool:TRUE];
			} else if ([[possibilityToSwitch lowercaseString] isEqualToString:@"false"]) {
				return [NSNumber numberWithBool:FALSE];
			}
		} else if ([self string:key isInSet:[self getNumberFields]]) {
			NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];
			NSNumber * num = [numberFormatter numberFromString:possibilityToSwitch];
			[numberFormatter release];
			if (num) {
				return num;
			}
			else return possibilityToSwitch;
		} else if ([self string:key isInSet:[self getDateFields]]) {
			return [DateUtils getDateFromTimeStamp:possibilityToSwitch];
		} else if ([self string:key isInSet:[NSSet setWithArray:[self getLocationFields]]]) {
            /*NSUInteger index = [[self getLocationFields] indexOfObject:key];
            if ((index % 3) == 2) { // we are at lon
                NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];
                NSNumber * lon = [numberFormatter numberFromString:possibilityToSwitch];
                [numberFormatter release];
                if (num) {
                    return num;
                }
                else return possibilityToSwitch;
                CLLocation * location = [[CLLocation alloc] initWithLatitude:<#(CLLocationDegrees)#> longitude:<#(CLLocationDegrees)#>]
            }*/
			return nil;
		}
		return possibilityToSwitch; //it is really a string
        
	} else if ([possibilityToSwitch isKindOfClass:[NSNumber class]]) {
		if ([self string:key isInSet:[self getBoolFields]]) {
			return possibilityToSwitch;
		} else if ([self string:key isInSet:[self getNumberFields]]) {
			return possibilityToSwitch;
		} else if ([self string:key isInSet:[self getDateFields]]) {
			return [DateUtils getDateFromTimeStamp:possibilityToSwitch];
		}
		return possibilityToSwitch; //it is really a string
		
	} else return possibilityToSwitch;
}


-(id)initWithJSONData:(NSData *)data {
    self = [super init];
    if (self) {
        self.toParseJSONData = data;
        self.translator = [NSMutableDictionary dictionary];
        [self addItemsToTranslator];
        multiple = FALSE;
    }
	
	return self;
}

-(NSArray*) parse {
	NSManagedObjectContext *context = [((AppDelegate*)[UIApplication sharedApplication].delegate) managedObjectContext];
	NSArray * array = [self managedObjectsFromJSONStructure:toParseJSONData withManagedObjectContext:context];
	
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
	return array;
}

-(NSArray*) parseWithoutSaving {
    NSManagedObjectContext *context = [((AppDelegate*)[UIApplication sharedApplication].delegate) managedObjectContext];
	NSArray * array = [self managedObjectsFromJSONStructure:toParseJSONData withManagedObjectContext:context];
	return array;

}

- (NSManagedObject*)managedObjectFromStructure:(NSDictionary*)structureDictionary withManagedObjectContext:(NSManagedObjectContext*)moc {
	return nil;
}

- (NSArray*)getTopKeys {
	return  [NSArray arrayWithObject:@"data"];
}

- (NSInteger)topKeyCount {  //top keys are in case everything is incapsulated at the top in a dictionary with only one key/value pair
	return 1;
}

- (void)setValue:(id)value forKey:(NSString*)key forManagedObject:(NSManagedObject*)managedObject {
    if ([value isEqual:[NSNull null]]) {
        //[managedObject setValue:nil forKey:key];
    } else if ([[[managedObject entity] attributesByName] objectForKey:key]) {
		[managedObject setValue:value forKey:key];
        NSLog(@"setting value %@ for key %@",value,key);
	} else {
		NSLog(@"ERROR -> new key %@",key);
	}
}


- (NSArray*)managedObjectsFromJSONStructure:(NSData*)json withManagedObjectContext:(NSManagedObjectContext*)moc
{
	
    
	NSError *error = nil;
	NSDictionary *structureDictionary = [[CJSONDeserializer deserializer] deserialize:json error:&error];
	//NSLog(@"dict %@",structureDictionary);
	if ((error) || [structureDictionary isKindOfClass:[NSNull class]]) 
	{
		NSString * jsonString = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
		if ([jsonString isEqualToString:@"null"]) {
			[jsonString release];
			return nil;
		}
		else if (error) NSLog(@"%@",error);
	}
    int numKeys = [self topKeyCount];
    int i = 0;
    while (i<numKeys) {
        structureDictionary = [structureDictionary objectForKey:[[self getTopKeys] objectAtIndex:i]];
        i++;
    }
	//if ([self hasTopKey]) structureDictionary = [structureDictionary objectForKey:[self getTopKey]];
	NSAssert2(error == nil, @"Failed to deserialize\n%@\n%@", [error localizedDescription], json);
	NSMutableArray *objectArray = [[NSMutableArray alloc] init];
	if ([structureDictionary isKindOfClass:[NSArray class]]) {
		for (NSDictionary *managedObjectDictionary in structureDictionary) {
			NSManagedObject * obj = [self managedObjectFromStructure:managedObjectDictionary withManagedObjectContext:moc];
			if (obj != nil) {
				[objectArray addObject:obj];
			}
		}
	} else {
		NSManagedObject * obj = [self managedObjectFromStructure:structureDictionary withManagedObjectContext:moc];
		if (obj != nil) {
			[objectArray addObject:obj];
		}
	}
	return [objectArray autorelease];
}



@end