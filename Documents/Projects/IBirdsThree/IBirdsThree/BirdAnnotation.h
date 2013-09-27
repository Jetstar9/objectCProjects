//
//  BirdAnnotation.h
//  iBirds
//
//  Created by Samuel Westrich on 10/17/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BirdAnnotation :  MKPointAnnotation <MKAnnotation> {
    CLLocationCoordinate2D coordinate_;
}

// Re-declare MKAnnotation's readonly property 'coordinate' to readwrite. 
@property (nonatomic, readwrite, assign) CLLocationCoordinate2D coordinate;


@end
