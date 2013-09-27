//
//  ControlsView.h
//  OverlayTechDemo
//
//  Created by Samuel Westrich on 8/19/11.
//  Copyright 2011 ADYLITICA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaptureControlView.h"
#import "BirdCatchingProtocol.h"
#import "RadarView.h"
#import "RadarViewProtocol.h"

@interface ControlsView : UIView <CaptureControlViewDelegate,BirdCatchingProtocol,RadarViewProtocol> {
    CaptureControlView * ccV;
    UIButton * birdButton;
    NSMutableSet * oldBirdsInReticule;
    NSMutableSet * oldBirdsFarAway;
    id catchableBird;
    UIImagePickerController * imagePickerController;
    NSMutableDictionary * birdsFarAwayTriangles;
    RadarView * radarView;
}

@property(nonatomic,retain) RadarView * radarView;
@property(nonatomic,retain) NSMutableSet * oldBirdsInReticule;
@property(nonatomic,retain) NSMutableSet * oldBirdsFarAway;
@property(nonatomic,retain) UIButton * birdButton;
@property(nonatomic,retain) CaptureControlView * ccV;
@property(nonatomic,retain) id catchableBird;
@property(nonatomic,retain) UIImagePickerController * imagePickerController;
@property(nonatomic,retain) NSMutableDictionary * birdsFarAwayTriangles;

@end
