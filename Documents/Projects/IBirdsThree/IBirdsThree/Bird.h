//
//  Bird.h
//  iBirds
//
//  Created by Samuel Westrich on 10/20/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Bird : NSManagedObject

@property (nonatomic, retain) id baseLocation;
@property (nonatomic, retain) NSNumber * beingCaptured;
@property (nonatomic, retain) NSString * birdId;
@property (nonatomic, retain) NSNumber * captureCount;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSNumber * currentFood;
@property (nonatomic, retain) NSNumber * foodGatheringTimeRemaining;
@property (nonatomic, retain) NSNumber * foodGatherRate;
@property (nonatomic, retain) NSNumber * foodLimitForLevel;
@property (nonatomic, retain) NSString * gatheringFn;
@property (nonatomic, retain) NSNumber * gatheringParam1;
@property (nonatomic, retain) NSNumber * gatheringParam2;
@property (nonatomic, retain) NSNumber * gatheringParam3;
@property (nonatomic, retain) NSNumber * gatheringParam4;
@property (nonatomic, retain) NSDate * gatheringStartTime;
@property (nonatomic, retain) NSDate * lastModificationDate;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) id location;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) User *owner;

@end
