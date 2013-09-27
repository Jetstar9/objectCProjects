//
//  RadarView.h
//  OverlayTechDemo
//
//  Created by Samuel Westrich on 9/20/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadarViewProtocol.h"


@interface RadarView : UIView <RadarViewProtocol> {
    CALayer * rotatingLayer;
    
    NSMutableDictionary * layersForBirdsInRadar;
     NSMutableSet * oldBirdsInRadar;
    CGFloat heading;
}

-(void)updateRadar:(id)bird;

@end
