//
//  CLLocation+CLLocation_Addons.m
//  OverlayTechDemo
//
//  Created by Samuel Westrich on 9/21/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import "CLLocation+Addons.h"
#import "MathTools.h"

@implementation CLLocation (Addons)

#define DEGREES_TO_RADIANS (M_PI/180.0)
#pragma mark -
#pragma mark Geodetic utilities definition



// References to ECEF and ECEF to ENU conversion may be found on the web.

// Converts latitude, longitude to ECEF coordinate system
void latLonToEcef(double lat, double lon, double alt, double *x, double *y, double *z)
{   
	double clat = cos(lat);
	double slat = sin(lat);
	double clon = cos(lon);
	double slon = sin(lon);
	
	double N = WGS84_A / sqrt(1.0 - WGS84_E * WGS84_E * slat * slat);
	
	*x = (N + alt) * clat * clon;
	*y = (N + alt) * clat * slon;
	*z = (N * (1.0 - WGS84_E * WGS84_E) + alt) * slat;
}

// Converts ECEF coordinate system to LLA
void ecefToLatLon(double *lat, double *lon, double *alt, double x, double y, double z)
{   
    *lon = atan2(y,x);
    double p = sqrt(x*x + y*y);
    double oldphi;
	double phi = atan2(z,(p*(1 - (WGS84_E * WGS84_E))));
    double slat;
    double N;
    
    do {
        oldphi = phi;
        slat = sin(oldphi);
        
        N = WGS84_A / sqrt(1.0 - WGS84_E * WGS84_E * slat * slat);
        
        phi = atan2(z + (WGS84_E * WGS84_E * N * sin(oldphi)),p);
        //NSLog(@"oldlat %f newlat %f",oldphi,phi);
    } while (fabs(oldphi - phi) > 0.001);
    
    *lat = phi;
    
	*alt = p/cos(phi) - N;
}


// Coverts ECEF to ENU coordinates centered at given lat, lon
void ecefToEnu(double lat, double lon, double x, double y, double z, double xr, double yr, double zr, double *e, double *n, double *u)
{
	double clat = cos(lat);
	double slat = sin(lat);
	double clon = cos(lon);
	double slon = sin(lon);
	double dx = x - xr;
	double dy = y - yr;
	double dz = z - zr;
	
	*e = -slon*dx  + clon*dy;
	*n = -slat*clon*dx - slat*slon*dy + clat*dz;
	*u = clat*clon*dx + clat*slon*dy + slat*dz;
}

// Coverts ENU to ECEF coordinates centered at given lat, lon
void enuToEcef(double lat, double lon, double *x, double *y, double *z, double xr, double yr, double zr, double e, double n, double u)
{
    double clat = cos(lat);
	double slat = sin(lat);
	double clon = cos(lon);
	double slon = sin(lon);
    
    *x = -slon*e -slat*clon*n + clat*clon*u + xr;
    *y = clon*e -slat*slon*n + clat*slon*u + yr;
    *z = clat*n + slat*u + zr;
}


-(Point3D)cartesianDistanceToLocation:(CLLocation*)secondLocation {
    
    double lat1R = DegreesToRadians(self.coordinate.latitude);
    double lon1R = DegreesToRadians(self.coordinate.longitude);
    double lat2R = DegreesToRadians(secondLocation.coordinate.latitude);
    double lon2R = DegreesToRadians(secondLocation.coordinate.longitude);
    Point3D p1;
    Point3D p2;
    latLonToEcef(lat1R, lon1R, 0.0, &p1.x, &p1.y, &p1.z);
    latLonToEcef(lat2R, lon2R, 0.0, &p2.x, &p2.y, &p2.z);
    Point3D p; // enu
    ecefToEnu(lat1R, lon1R, p2.x, p2.y, p2.z, p1.x, p1.y, p1.z, &p.x, &p.y, &p.z);
    return p;
    }

-(Point3D)cartesianDistanceFromLocation:(CLLocation*)secondLocation {
    return [secondLocation cartesianDistanceToLocation:self];
}

-(CLLocation *)locationAfterTime:(NSTimeInterval)time usingFuntion:(NSString*)function withRadius:(float)radius withSpeed:(float)speed rotateBy:(float)angle oldCoordinate:(CLLocationCoordinate2D)oldCoordinate returnTrajectoryAngle:(float*)rAngle {
    if ([function isEqualToString:@"figure8"]) {
        double lat1R = DegreesToRadians(self.coordinate.latitude);
        double lon1R = DegreesToRadians(self.coordinate.longitude);
        double lat2R;
        double lon2R;
        //double lat3R = DegreesToRadians(oldCoordinate.latitude);
        //double lon3R = DegreesToRadians(oldCoordinate.longitude);
        double alt2;
        CGPoint point = [MathTools lemniscateBernoulliWithRadius:radius parameter:time];
        //point = CGPointApplyAffineTransform(point, CGAffineTransformMakeRotation(angle));
        NSLog(@"lemniscateBernoulliWithRadius %f %f",point.x,point.y);
        Point3D p1;
        Point3D p2;
        //Point3D p3;
        latLonToEcef(lat1R, lon1R, 0.0, &p1.x, &p1.y, &p1.z);
        //latLonToEcef(lat3R, lon3R, 0.0, &p3.x, &p3.y, &p3.z);
        enuToEcef(lat1R, lon1R, &p2.x, &p2.y, &p2.z, p1.x, p1.y, p1.z, point.x, point.y, 0);
        ecefToLatLon(&lat2R, &lon2R, &alt2, p2.x, p2.y, p2.z);
        
        //Point3D p4;
        //ecefToEnu(lat2R, lon2R, p3.x, p3.y, p3.z, p2.x, p2.y, p2.z, &p4.x, &p4.y, &p4.z);
        
        //*rAngle = coshf(p4.x/(p4.x*p4.x + p4.y*p4.y));
        

        CGPoint derivative = [MathTools lemniscateBernoulliDerivativeWithRadius:radius parameter:time];
        
        *rAngle = atan2f(derivative.x, derivative.y);

        
        
        return [[[CLLocation alloc] initWithLatitude:RadianToDegree(lat2R) longitude:RadianToDegree(lon2R)] autorelease];
     } else return self;
}


@end
