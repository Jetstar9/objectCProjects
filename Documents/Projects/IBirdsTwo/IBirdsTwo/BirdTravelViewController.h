//
//  BirdTravelViewController.h
//  iBirds
//
//  Created by Samuel Westrich on 9/29/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Bird.h"

@interface BirdTravelViewController : UIViewController <MKMapViewDelegate> {
    Bird * bird;
    MKMapView * mapView;
    NSString * currentCountry;
    NSString * currentCity;
    NSString * currentSubAdministrativeArea;
    UILabel * distanceNoteLabel;
    UILabel * speedNoteLabel;
    UILabel * distanceLabel;
    UILabel * speedLabel;
}


@property(nonatomic,retain) IBOutlet MKMapView * mapView;
@property(nonatomic,retain) IBOutlet UILabel * distanceNoteLabel;
@property(nonatomic,retain) IBOutlet UILabel * speedNoteLabel;
@property(nonatomic,retain) IBOutlet UILabel * distanceLabel;
@property(nonatomic,retain) IBOutlet UILabel * speedLabel;

@end
