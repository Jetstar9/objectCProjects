//
//  JSONParser+Protected.h
//  iBirds
//
//  Created by Samuel Westrich on 10/11/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import "JSONParser.h"

@interface JSONParser (Protected)

- (NSArray*)getTopKeys;
- (NSInteger)topKeyCount;

-(NSSet*)getDateFields;
-(NSSet*)getBoolFields;
-(NSSet*)getNumberFields;
-(NSArray*)getLocationFields;
-(void)addItemsToTranslator;

@end