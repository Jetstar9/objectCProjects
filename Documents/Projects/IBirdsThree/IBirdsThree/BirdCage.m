//
//  BirdCage.m
//  OverlayTechDemo
//
//  Created by Samuel Westrich on 7/28/11.
//  Copyright 2011 ADYLITICA. All rights reserved.
//

#import "BirdCage.h"
#import "BirdObject.h"
#import "glues.h"
#import "MathTools.h"
#import "Constants.h"
#import "UserLocationManager.h"
#import <AVFoundation/AVFoundation.h>

#define kAccelerometerFrequency		100.0 // Hz
#define kFilteringFactor			0.1


static BirdCage *sharedInstance = nil;

@implementation BirdCage



@synthesize birds;
@synthesize heading;
@synthesize delegate;





-(void) addFakeBirdAtBearing:(CGFloat)bearing atDistance:(CGFloat)distance {
    //for the fake birds using a sphere as the earth aint too bad, so lets make our lives easier and do that
    CLLocation * lCurrentLocation = [[UserLocationManager sharedInstance] currentLocation];
    CLLocationDegrees lat1 = lCurrentLocation.coordinate.latitude;
    CLLocationDegrees lon1 = lCurrentLocation.coordinate.longitude;
    double lat1R = DegreesToRadians(lat1);
    double lon1R = DegreesToRadians(lon1);
    double lat2R = asin((sin(lat1R)*cos(distance/EarthRadius)) + (cos(lat1R)*sin(distance/EarthRadius)*cos(bearing)));
    CLLocationDegrees lat2 = RadiansToDegrees(lat2R);
    CLLocationDegrees lon2 = RadiansToDegrees(lon1R + atan2(sin(bearing)*sin(distance/EarthRadius)*cos(lat1R), cos(distance/EarthRadius)-(sin(lat1R)*sin(lat2R))));
    NSLog(@"placing bird at lat %f lon %f ",lat2,lon2);
    CLLocation * location = [[CLLocation alloc] initWithLatitude:lat2 longitude:lon2];
    BirdObject * bird = [[BirdObject alloc] initWithIdentifier:[NSNumber numberWithInt:birds.count + 1] location:location name:@"Birdie"];
    //[bird setX:distance*cos(bearing)];
    //[bird setY:distance*sin(bearing)];
    //[bird setZ:0];
    [bird setupForViewingWithTextures:[NSArray arrayWithObjects:@"WhiteBirdFront0.png",@"WhiteBirdFront1.png",@"WhiteBirdFront2.png",@"WhiteBirdFront3.png",@"WhiteBirdFront4.png",nil]];
    //[bird setupForViewingWithTextures:[NSArray arrayWithObjects:@"Owl0.png",@"Owl1.png",@"Owl2.png",nil]];
    [location release];
    [birds setObject:bird forKey:bird.identifier];
    [bird release];
    //[[self delegate] addBird:bird.identifier centerAtX:[b Y: Z:10.0 sizeMultiplier:1.0];
}

-(void) addFakeBirdAtBearing:(CGFloat)bearing atDistance:(CGFloat)distance withAltitude:(CGFloat)altitude {
    CLLocation * lCurrentLocation = [[UserLocationManager sharedInstance] currentLocation];
    CLLocationDegrees lat1 = lCurrentLocation.coordinate.latitude;
    CLLocationDegrees lon1 = lCurrentLocation.coordinate.longitude;
    double lat1R = DegreesToRadians(lat1);
    double lon1R = DegreesToRadians(lon1);
    double lat2R = asin((sin(lat1R)*cos(distance/EarthRadius)) + (cos(lat1R)*sin(distance/EarthRadius)*cos(bearing)));
    CLLocationDegrees lat2 = RadiansToDegrees(lat2R);
    CLLocationDegrees lon2 = RadiansToDegrees(lon1R + atan2(sin(bearing)*sin(distance/EarthRadius)*cos(lat1R), cos(distance/EarthRadius)-(sin(lat1R)*sin(lat2R))));
    CLLocation * location = [[CLLocation alloc] initWithLatitude:lat2 longitude:lon2];
    //location.altitude = altitude;
    BirdObject * bird = [[BirdObject alloc] initWithIdentifier:[NSNumber numberWithInt:birds.count + 1] location:location name:@"Birdie"];
    //[bird setX:distance*cos(bearing)];
    //[bird setY:distance*sin(bearing)];
    //[bird setZ:altitude-AVERAGE_USER_HEIGHT];
    [bird setupForViewingWithTextures:[NSArray arrayWithObjects:@"WhiteBirdFront0.png",@"WhiteBirdFront1.png",@"WhiteBirdFront2.png",@"WhiteBirdFront3.png",@"WhiteBirdFront4.png",nil]];
    //[bird setupForViewingWithTextures:[NSArray arrayWithObjects:@"Owl0.png",@"Owl1.png",@"Owl2.png",nil]];
    [location release];
    [birds setObject:bird forKey:bird.identifier];
    [bird release];
    
}

-(void) addBird:(Bird*)lBird {
    NSLog(@"AddingBird %@ at %@",lBird.name,lBird.baseLocation);
    BirdObject * bird = [[BirdObject alloc] initWithIdentifier:[NSNumber numberWithInt:birds.count + 1] location:lBird.baseLocation name:lBird.name];
    [bird setupForViewingWithTextures:[NSArray arrayWithObjects:@"WhiteBirdFront0.png",@"WhiteBirdFront1.png",@"WhiteBirdFront2.png",@"WhiteBirdFront3.png",@"WhiteBirdFront4.png",nil]];
    [birds setObject:bird forKey:bird.identifier];
    [bird release];
}

-(void) addBirds:(NSArray*)lBirds {
    for (Bird * bird in lBirds) {
        [self addBird:bird];
    }
}

-(void) startDeviceMotion{
    if (motionManager.gyroAvailable) {
        CMDeviceMotion *deviceMotion = motionManager.deviceMotion;      
        CMAttitude *attitude = deviceMotion.attitude;
        referenceAttitude = [attitude retain];
        
        // Tell CoreMotion to show the compass calibration HUD when required to provide true north-referenced attitude
        motionManager.showsDeviceMovementDisplay = YES;
        
        
        motionManager.deviceMotionUpdateInterval = 1.0 / 10.0;
        
        // New in iOS 5.0: Attitude that is referenced to true north
        //[motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXTrueNorthZVertical];
        
        NSString *os_version = [[UIDevice currentDevice] systemVersion]; //NSLog(os_verion); 
        if([[NSNumber numberWithChar:[os_version characterAtIndex:0]] intValue]>=5) {
            [motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXTrueNorthZVertical toQueue:[NSOperationQueue currentQueue] withHandler:^ (CMDeviceMotion *devMotion, NSError *error)
              {
                  //if ([[NSOperationQueue currentQueue] operationCount] < 5)
                      //[self.delegate setAttitude:devMotion.attitude];
                  [self.delegate setAttitude:motionManager.deviceMotion.attitude];

                  }];
             }
             else 
        [motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^ (CMDeviceMotion *devMotion, NSError *error)
         {   
             CMAttitude *currentAttitude = devMotion.attitude;
             //CGFloat roll = currentAttitude.roll*180/M_PI;
             //CGFloat pitch = currentAttitude.pitch*180/M_PI;
             //CGFloat yaw = -currentAttitude.yaw*180/M_PI + 180;
             //devMotion.userAcceleration;
             //if ((pitch < 60) && (pitch > 60)) {
             //    gyroCompassOffset = magneticDirection - yaw;
             //    if (gyroCompassOffset < 0) gyroCompassOffset += 360.0;
             //}
             //[[self delegate] setZRotation:DegreesToRadians(magneticDirection) withPitch:pitch];
            // NSLog(@"roll %f pitch %f yaw %f", roll,pitch,magneticDirection);//gyroCompassOffset + yaw);
             [[self delegate] setHeading:heading withAttitude:currentAttitude];
             //for (NSNumber * birdIdentifier in self.birds) {
                 //[[self delegate] shouldUpdateBird:birdIdentifier centerAtX:yaw Y:200 Z:0 sizeMultiplier:1.0];
                 //[[self delegate] updatePositionCenterAtX:0.0 Y:0.0 Z:0.0 eyeX:1.0 eyeY:0.0 eyeZ:0.0];
             //}
         }];
        //motionManager.magnetometerUpdateInterval = 5.0/1.0;
        //motionManager.gyroUpdateInterval = 5.0/1.0;
        //motionManager.deviceMotionUpdateInterval = 0.05;
		
    } else {
        NSLog(@"No gyroscope on device.");
        [motionManager release];
    }
    
}

- (void)startDisplayLink
{
    
	displayLink = [[CADisplayLink displayLinkWithTarget:self selector:@selector(onDisplayLink:)] retain];
    oldTimeStamp = [NSDate timeIntervalSinceReferenceDate];
	[displayLink setFrameInterval:1];
	[displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)stopDisplayLink
{
	[displayLink invalidate];
	[displayLink release];
	displayLink = nil;		
}


- (void)onDisplayLink:(id)sender
{
	CMDeviceMotion *d = motionManager.deviceMotion;
	if (d != nil) {

        CFTimeInterval timestamp = [(CADisplayLink*)sender timestamp];
        CGFloat refreshTime = timestamp - oldTimeStamp;
        if (refreshTime>0.2) refreshTime = 0.2;
        //NSLog(@"%f",refreshTime);
        //motionManager.deviceMotionUpdateInterval = refreshTime;
        oldTimeStamp = timestamp;
	}
}



- (id)init
{
    self = [super init];
    if (self) {
        //self.currentLocation = [[CLLocation alloc] initWithLatitude:0.0 longitude:0.0];
        NSMutableDictionary * lBirds = [[NSMutableDictionary alloc] init];
        self.birds = lBirds;
        [lBirds release];
        
        
        //motions
        motionManager = [[CMMotionManager alloc] init];
        referenceAttitude = nil; 
        [self startDeviceMotion];
        [self startDisplayLink];
        //[UIAccelerometer sharedAccelerometer].delegate = self;
    }
    
    return self;
}


- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{
	//Use a basic low-pass filter to only keep the gravity in the accelerometer values
	accel[0] = acceleration.x * kFilteringFactor + accel[0] * (1.0 - kFilteringFactor);
	accel[1] = acceleration.y * kFilteringFactor + accel[1] * (1.0 - kFilteringFactor);
	accel[2] = acceleration.z * kFilteringFactor + accel[2] * (1.0 - kFilteringFactor);
	
	//Update the accelerometer values for the view
	//[self.delegate setAccel:accel];
}

-(NSSet*) birdsInReticule:(CGRect)rect model:(const GLfloat*)__modelview projection:(const GLfloat*)__projection viewport:(const GLint*)__viewport {
    NSMutableSet * objects = [[NSMutableSet alloc] init];
    for (NSString * birdId in self.birds) {
        InteractiveObject * bird = [self.birds objectForKey:birdId];
        GLPoint3D projectedPoint;
        gluProject(bird.x, bird.y, bird.z, __modelview, __projection, __viewport, &projectedPoint.x, &projectedPoint.y, &projectedPoint.z);
        CGPoint centerOfObject = CGPointMake(projectedPoint.x, projectedPoint.y);
        //NSLog(@"birdie projectedAt: {%f %f %f }",projectedPoint.x, projectedPoint.y, projectedPoint.z);
        if ((CGRectContainsPoint(rect, centerOfObject)) && (projectedPoint.z < 1.0)) {
            [objects addObject:bird];
        }
    }
    NSSet * rSet = [NSSet setWithSet:objects];
    [objects release];
    return rSet;
}

-(NSSet*) birdsWithinDistance:(CGFloat)maxDistance fromPosition:(CGPoint)pos height:(CGFloat)height {
    NSMutableSet * objects = [[NSMutableSet alloc] init];
    for (NSString * birdId in [self birds]) {
        BirdObject * bird = [[self birds] objectForKey:birdId];
        CGFloat birdDistance = [bird getDistanceFromX:pos.x Y:pos.y Z:height];
        if (birdDistance < maxDistance) 
            [objects addObject:bird];
    }
    NSSet * rSet = [NSSet setWithSet:objects];
    [objects release];
    return rSet;
}

-(NSSet*) birdsWithinDistance:(CGFloat)distance fromLatLongPosition:(CGPoint)latlong {
    NSMutableSet * objects = [[NSMutableSet alloc] init];
    NSSet * rSet = [NSSet setWithSet:objects];
    [objects release];
    return rSet;
}

-(NSSet*) birdsOutOfVisibleRangeInRect:(CGRect)rect model:(const GLfloat*)__modelview projection:(const GLfloat*)__projection viewport:(const GLint*)__viewport {
    NSMutableSet * objects = [[NSMutableSet alloc] init];
    for (NSString * birdId in [self birds]) {
        BirdObject * bird = [[self birds] objectForKey:birdId];
        CGFloat birdDistance = [bird getDistanceFromX:0.0f Y:0.0f Z:0.0f];
        if (birdDistance < VISIBLE_RANGE) continue;
        GLPoint3D projectedPoint;
        gluProject(bird.x, bird.y, bird.z, __modelview, __projection, __viewport, &projectedPoint.x, &projectedPoint.y, &projectedPoint.z);
        CGPoint centerOfObject = CGPointMake(projectedPoint.x, projectedPoint.y);
        bird.screenX = projectedPoint.x;
        bird.screenY = 480 - projectedPoint.y;
        //NSLog(@"birdie projectedAt: {%f %f %f }",projectedPoint.x, projectedPoint.y, projectedPoint.z);
        if ((CGRectContainsPoint(rect, centerOfObject)) && (projectedPoint.z > 1.0)) {
            [objects addObject:bird];
        }
    }
    NSSet * rSet = [NSSet setWithSet:objects];
    [objects release];
    return rSet;
}



#pragma mark -
#pragma mark OpenGLES Drawing

-(void) drawBirdsWithFrameCount:(NSInteger)frame
{
	for(NSNumber * num in self.birds) {
        [[self.birds objectForKey:num] drawWithFrameCount:frame];
    }
	
}

#pragma mark -
#pragma mark Singleton methods

+ (BirdCage*)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
			sharedInstance = [[BirdCage alloc] init];
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

