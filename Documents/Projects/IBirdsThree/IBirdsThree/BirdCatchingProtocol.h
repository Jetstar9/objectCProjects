//
//  BirdCatchingProtocol.h
//  OverlayTechDemo
//
//  Created by Samuel Westrich on 8/20/11.
//  Copyright 2011 ADYLITICA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RadarViewProtocol.h"

@protocol BirdCatchingProtocol <NSObject,RadarViewProtocol>

@optional

-(void) birdsAreInReticule:(NSSet*)birds;

-(void) birdsAreFarAway:(NSSet*)birds;

-(void)birdIsCatchable:(id)bird;

@end
