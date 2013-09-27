//
//  RadarViewDataSource.h
//  OverlayTechDemo
//
//  Created by Samuel Westrich on 9/21/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RadarViewProtocol <NSObject>

-(void)setBirdsShowingUpInRadar:(NSSet *)birds;

-(void)updateRadarDirectionWithHeading:(CGFloat)yaw; //radians
                    
@end
