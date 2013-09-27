//
//  UserLocationManager.h
//  OverlayTechDemo
//
//  Created by Samuel Westrich on 9/22/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>

@interface UserLocationManager : NSObject <CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    CLLocation * currentLocation;
}


@property (retain,nonatomic) CLLocation * currentLocation;
+(UserLocationManager*)sharedInstance;

@end
