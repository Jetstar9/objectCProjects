//
//  UserLocationManager.m
//  OverlayTechDemo
//
//  Created by Samuel Westrich on 9/22/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import "UserLocationManager.h"

static UserLocationManager *sharedInstance = nil;

@implementation UserLocationManager

@synthesize currentLocation;

- (id)init
{
    self = [super init];
    if (self) {
        currentLocation = [[CLLocation alloc] initWithLatitude:0.0 longitude:0.0];


        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDelegate:self];
        //[locationManager startUpdatingHeading];
        [locationManager startUpdatingLocation];
        
    }
    
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    //self.heading = newHeading;
    //magneticDirection = [newHeading magneticHeading];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    self.currentLocation = newLocation;
    //NSLog(@"%f,%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
}


#pragma mark -
#pragma mark Singleton methods

+ (UserLocationManager*)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
			sharedInstance = [[UserLocationManager alloc] init];
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
