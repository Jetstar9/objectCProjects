//
//  BirdTravelViewController.m
//  iBirds
//
//  Created by Samuel Westrich on 9/29/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import "BirdTravelViewController.h"
#import "Environment.h"
#import "MapShadowOverlayView.h"
#import "MapShadowOverlay.h"
#import "MapBird.h"
#import "MapDestination.h"
#import "DDAnnotationView.h"

@interface BirdTravelViewController()
@property(nonatomic,retain) Bird * bird;
@property(nonatomic,retain) NSString * currentCountry;
@property(nonatomic,retain) NSString * currentCity;
@property(nonatomic,retain) NSString * currentSubAdministrativeArea;
@end

@implementation BirdTravelViewController

@synthesize mapView;
@synthesize bird;
@synthesize currentCity;
@synthesize currentCountry;
@synthesize currentSubAdministrativeArea;
@synthesize distanceNoteLabel;
@synthesize speedNoteLabel;
@synthesize distanceLabel;
@synthesize speedLabel;

-(void)dealloc {
    [bird release];
    [mapView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    MapShadowOverlayView *view = [[MapShadowOverlayView alloc] initWithOverlay:overlay];
    return [view autorelease];
}


#pragma mark -
#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
	
	if (oldState == MKAnnotationViewDragStateDragging) {
		DDAnnotation *annotation = (DDAnnotation *)annotationView.annotation;
        CLGeocoder * geocoder = [[CLGeocoder alloc] init];
        CLLocation * loc = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
        [geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
            for (CLPlacemark * placemark in placemarks) {
                NSDictionary * placemarkDictionary = [placemark addressDictionary];
                for (NSString * key in placemarkDictionary)
                    NSLog(@"%@ %@",key,[placemarkDictionary objectForKey:key]);
            }
        }];
		annotation.subtitle = [NSString	stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude];		
	}
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;		
	}
	
	static NSString * const kPinAnnotationIdentifier = @"PinIdentifier";
	MKAnnotationView *draggablePinView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:kPinAnnotationIdentifier];
	
	if (draggablePinView) {
		draggablePinView.annotation = annotation;
	} else {
		// Use class method to create DDAnnotationView (on iOS 3) or built-in draggble MKPinAnnotationView (on iOS 4).
		draggablePinView = [DDAnnotationView annotationViewWithAnnotation:annotation reuseIdentifier:kPinAnnotationIdentifier mapView:self.mapView];
        
		if ([draggablePinView isKindOfClass:[DDAnnotationView class]]) {
			// draggablePinView is DDAnnotationView on iOS 3.
		} else {
			// draggablePinView instance will be built-in draggable MKPinAnnotationView when running on iOS 4.
		}
	}		
	
	return draggablePinView;
}
#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    //distanceNoteLabel.font = [UIFont fontWithName:@"Montez-Regular" size:14];
    //speedNoteLabel.font = [UIFont fontWithName:@"Montez-Regular" size:14];
    self.bird = [[Environment sharedInstance] currentBird];
    MapShadowOverlay * overlay = [[MapShadowOverlay alloc] initWithBird:self.bird];
    //[mapView addOverlay:overlay]
    
    CLLocationCoordinate2D theCoordinate;
	theCoordinate.latitude = 37.810000;
    theCoordinate.longitude = -122.477989;
	
	DDAnnotation *annotation = [[[DDAnnotation alloc] initWithCoordinate:theCoordinate addressDictionary:nil] autorelease];
	annotation.title = @"Drag to Move Pin";
	annotation.subtitle = [NSString	stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude];
    
    [mapView addAnnotation:annotation];
	
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
