//
//  BirdGatheringViewController.h
//  iBirds
//
//  Created by Samuel Westrich on 9/26/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Bird.h"
#import "BirdAnnotation.h"
#import "IBProgressBar.h"
@interface BirdGatheringViewController : UIViewController <MKMapViewDelegate> {
    MKMapView * mapView;
    CADisplayLink *displayLink;
    CFTimeInterval oldTimeStamp;
    BirdAnnotation * birdAnnotation;
    MKAnnotationView *birdTopView;
    UILabel * gold;
    UILabel * food;
    IBProgressBar * progress;
    float initialPercentageComplete;
    float lastPercentageComplete;
    float initialFoodAmount;
}


@property(nonatomic,retain) IBOutlet MKMapView * mapView;
@property(nonatomic,retain) IBOutlet UILabel * gold;
@property(nonatomic,retain) IBOutlet UILabel * food;
@property(nonatomic,retain) BirdAnnotation * birdAnnotation;
@property(nonatomic,retain) MKAnnotationView *birdTopView;
@property(nonatomic,retain) IBOutlet IBProgressBar * progress;
-(IBAction)goToCaptureScreen:(id)sender;

-(IBAction)goToImages:(id)sender;

@end
