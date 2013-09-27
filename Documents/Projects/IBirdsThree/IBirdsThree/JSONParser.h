//
//  JSONParser.h
//  Adylitica
//
//  Created by Samuel Westrich on 10/11/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONParser : NSObject {
	NSData * toParseJSONData;
    NSMutableDictionary * translator;
    BOOL multiple;
}

@property(nonatomic,retain) NSDictionary * translator;
@property(nonatomic,getter = isMultiple,assign) BOOL multiple;

-(id)initWithJSONData:(NSData *)data;

- (NSArray*)managedObjectsFromJSONStructure:(NSData*)json withManagedObjectContext:(NSManagedObjectContext*)moc;
- (NSManagedObject*)managedObjectFromStructure:(NSDictionary*)structureDictionary withManagedObjectContext:(NSManagedObjectContext*)moc;
-(id)switchTypesFromString:(id)possibilityToSwitch forKey:(NSString*)key;

- (void)setValue:(id)value forKey:(NSString*)key forManagedObject:(NSManagedObject*)managedObject;
-(NSArray*) parse;
-(NSArray*) parseWithoutSaving;

-(Boolean)string:(NSString*)string isInSet:(NSSet*)set;


@end
