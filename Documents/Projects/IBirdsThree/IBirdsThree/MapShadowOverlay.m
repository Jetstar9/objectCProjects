//
//  MapShadowOverlay.m
//  iBirds
//
//  Created by Samuel Westrich on 9/29/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import "MapShadowOverlay.h"



@implementation MapShadowOverlay


- (id)initWithBird:(Bird *)bird
{
    if (self = [super init]) {
        origin = ((CLLocation*)bird.location).coordinate;
        radius = 150; //todo
    }
    return self;
}

-(CLLocationCoordinate2D) coordinate {
    return origin;
}

- (MKMapRect)boundingMapRect
{
    // Compute the boundingMapRect given the origin, the gridSize and the grid width and height
    
    CLLocationCoordinate2D upperLeftCoord = 
    CLLocationCoordinate2DMake(origin.latitude - 10,
                               origin.longitude - 10);
    
    MKMapPoint upperLeft = MKMapPointForCoordinate(upperLeftCoord);
    
    CLLocationCoordinate2D lowerRightCoord = 
    CLLocationCoordinate2DMake(origin.latitude + 10,
                               origin.longitude + 10);
    
    MKMapPoint lowerRight = MKMapPointForCoordinate(lowerRightCoord);
    
    double width = lowerRight.x - upperLeft.x;
    double height = lowerRight.y - upperLeft.y;
    
    MKMapRect bounds = MKMapRectMake(upperLeft.x, upperLeft.y, width, height);
    return bounds;
}

@end
