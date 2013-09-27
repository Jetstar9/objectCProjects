//
//  ClosestBirdsWorker.h
//  iBirds
//
//  Created by Samuel Westrich on 10/18/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import "BasicWorker.h"
#import <CoreLocation/CoreLocation.h>

@interface ClosestBirdsWorker : BasicWorker{
    CLLocationCoordinate2D place;
}

@property(nonatomic,assign) CLLocationCoordinate2D place;


@end
