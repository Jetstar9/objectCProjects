//
//  MapShadowOverlay.h
//  iBirds
//
//  Created by Samuel Westrich on 9/29/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Bird.h"

@interface MapShadowOverlay : NSObject <MKOverlay> {
    CLLocationCoordinate2D origin; // position of upper left hazard
    CGFloat radius;
}
- (id)initWithBird:(Bird *)bird;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (MKMapRect)boundingMapRect;

@end
