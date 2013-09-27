//
//  MapDestination.h
//  iBirds
//
//  Created by Samuel Westrich on 9/29/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "DDAnnotation.h"
@interface MapDestination : DDAnnotation {

}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c;

@end
