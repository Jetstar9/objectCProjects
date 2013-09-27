//
//  CLLocation+CLLocation_Addons.h
//  OverlayTechDemo
//
//  Created by Samuel Westrich on 9/21/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "MathTools.h"
#import "Constants.h"

@interface CLLocation (Addons)


-(Point3D)cartesianDistanceToLocation:(CLLocation*)secondLocation;
-(Point3D)cartesianDistanceFromLocation:(CLLocation*)secondLocation;
void latLonToEcef(double lat, double lon, double alt, double *x, double *y, double *z);
void ecefToLatLon(double *lat, double *lon, double *alt, double x, double y, double z);
void ecefToEnu(double lat, double lon, double x, double y, double z, double xr, double yr, double zr, double *e, double *n, double *u);
void enuToEcef(double lat, double lon, double *x, double *y, double *z, double xr, double yr, double zr, double e, double n, double u);

-(CLLocation *)locationAfterTime:(NSTimeInterval)time usingFuntion:(NSString*)function withRadius:(float)radius withSpeed:(float)speed rotateBy:(float)angle oldCoordinate:(CLLocationCoordinate2D)oldCoordinate returnTrajectoryAngle:(float*)rAngle;

@end
