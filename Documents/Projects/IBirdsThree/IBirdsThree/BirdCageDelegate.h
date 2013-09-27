//
//  BirdCageDelegate.h
//  OverlayTechDemo
//
//  Created by Samuel Westrich on 7/28/11.
//  Copyright 2011 ADYLITICA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>

@protocol BirdCageDelegate <NSObject>

-(void)setAttitude:(CMAttitude *)attitude;

@optional

-(void)setHeading:(CLHeading*)heading withAttitude:(CMAttitude *)attitude;

@end
