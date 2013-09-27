//
//  Bird.h
//  OverlayTechDemo
//
//  Created by Samuel Westrich on 7/28/11.
//  Copyright 2011 ADYLITICA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "EAGLView.h"
#import "InteractiveObject.h"
#import "BirdCatchingProtocol.h"
@interface BirdObject : InteractiveObject {
    NSNumber * identifier;
    CLLocation * location;
    int frames;
    int offset;
    float color[3];
    float v[3];
    float a[3];
    float mass;
    NSTimer * movement;
    NSDate * lastUpdate;
    float maxspeed;
    NSString * name;
    float distance;
    float speed;
    Boolean targeted;
    id <BirdCatchingProtocol> delegate;
    float screenX;
    float screenY;
}

- (id)initWithIdentifier:(NSNumber*)lIdentifier location:(CLLocation*)lLocation;
- (id)initWithIdentifier:(NSNumber*)lIdentifier location:(CLLocation*)lLocation name:(NSString*)lName;
-(void)setupForViewingWithTextures:(NSArray*)textures;


@property(nonatomic,assign) id <BirdCatchingProtocol> delegate;
@property(nonatomic,retain) NSNumber * identifier;
@property(nonatomic,retain) CLLocation * location;
@property(nonatomic,retain) NSString * name;

@property(nonatomic,assign) float distance;
@property(nonatomic,assign) float speed;
@property(nonatomic,assign) float screenX;
@property(nonatomic,assign) float screenY;

-(CGFloat)getXDistanceFromLocation:(CLLocation*)location;
-(CGFloat)getYDistanceFromLocation:(CLLocation*)location;

-(CGFloat)getDistanceFromX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z;

-(void)setIsTargeted:(Boolean)targeted;


@end
