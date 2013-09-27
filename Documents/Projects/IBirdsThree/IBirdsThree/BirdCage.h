//
//  BirdCage.h
//  OverlayTechDemo
//
//  Created by Samuel Westrich on 7/28/11.
//  Copyright 2011 ADYLITICA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>
#import "BirdCageDelegate.h"
#import "Constants.h"
#import "Bird.h"

#define VISIBLE_RANGE 50.0f

@interface BirdCage : NSObject <UIAccelerometerDelegate> {

    CADisplayLink *displayLink;
    NSMutableDictionary * birds;
    
    CMMotionManager *motionManager;
    CMAttitude *referenceAttitude;

    id<BirdCageDelegate> delegate;
    CGFloat gyroCompassOffset;
    CLLocationDirection magneticDirection;
    CLHeading * heading;
    UIAccelerationValue accel[3];
    CFTimeInterval oldTimeStamp;
    CLLocationCoordinate2D currentLocation;
}

+(BirdCage*)sharedInstance;

-(void) addFakeBirdAtBearing:(CGFloat)bearing atDistance:(CGFloat)distance;

-(void) addFakeBirdAtBearing:(CGFloat)bearing atDistance:(CGFloat)distance withAltitude:(CGFloat)altitude;

-(void) addBird:(Bird*)bird;

-(void) addBirds:(NSArray*)birds;

-(void) drawBirdsWithFrameCount:(NSInteger)frame;

-(NSSet*) birdsInReticule:(CGRect)rect model:(const GLfloat*)__modelview projection:(const GLfloat*)__projection viewport:(const GLint*)__viewport;
-(NSSet*) birdsOutOfVisibleRangeInRect:(CGRect)rect model:(const GLfloat*)__modelview projection:(const GLfloat*)__projection viewport:(const GLint*)__viewport;
//-(NSSet*) birdsWithinDistance:(CGFloat)distance fromLatLongPosition:(CGPoint)latlong;
-(NSSet*) birdsWithinDistance:(CGFloat)maxDistance fromPosition:(CGPoint)pos height:(CGFloat)height;


@property (retain,nonatomic) NSMutableDictionary * birds;
@property (retain,nonatomic) CLHeading * heading;
@property (assign,nonatomic) id<BirdCageDelegate> delegate;

@end
