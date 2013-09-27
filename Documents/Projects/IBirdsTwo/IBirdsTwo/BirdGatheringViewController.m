//
//  BirdGatheringViewController.m
//  iBirds
//
//  Created by Samuel Westrich on 9/26/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import "BirdGatheringViewController.h"


#import "IBNavigationBarButtonItem.h"
#import "AnimatedAnnotation.h"
#import "BirdAnnotation.h"
#import "Environment.h"
#import <AVFoundation/AVFoundation.h>
#import "CLLocation+Addons.h"
#import "BirdCaptureViewController.h"

#import "BirdPhotosViewController.h"


@implementation BirdGatheringViewController

@synthesize mapView;
@synthesize birdAnnotation;
@synthesize birdTopView;
@synthesize gold;
@synthesize food;
@synthesize progress;

-(void)dealloc {
    [gold release];
    [mapView release];
    [super dealloc];
}

- (id)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
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

- (void)startDisplayLink
{
    
	displayLink = [[CADisplayLink displayLinkWithTarget:self selector:@selector(onDisplayLink:)] retain];
    oldTimeStamp = [NSDate timeIntervalSinceReferenceDate];
	[displayLink setFrameInterval:1];
	[displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)stopDisplayLink
{
	[displayLink invalidate];
	[displayLink release];
	displayLink = nil;		
}


- (void)onDisplayLink:(id)sender
{

        
    CFTimeInterval timestamp = [NSDate timeIntervalSinceReferenceDate];
    CGFloat timeElapsed = timestamp - oldTimeStamp;
    Bird * bird = [[Environment sharedInstance] currentBird];
    
    
    //bid movement on screen
    //param1: bird velocity (m/s)
    //param2: radius of circle in m
    //param3: starting angle in radians (server generates this randomly for the bird)
    //param4: don't need it now, but perhaps for future fn?
    
    CLLocation * loc = [bird baseLocation]; 
    float angle;
    CLLocationCoordinate2D oldCoordinate = self.birdAnnotation.coordinate;
    float cAngle = [[bird gatheringParam3] floatValue] + timeElapsed/10.0;
    float speed = [[bird gatheringParam1] floatValue];
    float radius = [[bird gatheringParam2] floatValue];
    CLLocation * loc2 = [loc locationAfterTime:timeElapsed usingFuntion:@"figure8" withRadius:radius withSpeed:speed rotateBy:cAngle oldCoordinate:(CLLocationCoordinate2D)oldCoordinate returnTrajectoryAngle:&angle];
    CLLocationCoordinate2D theCoordinate = loc2.coordinate;
    //theCoordinate.latitude = self.birdAnnotation.coordinate.latitude + 0.1;
    //theCoordinate.longitude = self.birdAnnotation.coordinate.longitude + 0.01;
    [self.birdAnnotation setCoordinate:theCoordinate];
    
    AnimatedAnnotation * aa = (AnimatedAnnotation *)self.birdTopView;
    [aa.imageView setTransform:CGAffineTransformMakeRotation(angle)];
    
    
    //gathering food progress bar
    
    float gatherRate = [bird.foodGatherRate floatValue];
    float amountNeededToLevel = [bird.foodLimitForLevel floatValue] - initialFoodAmount;
    float timeNeeded = amountNeededToLevel/(gatherRate/3600); //in seconds
    NSLog(@"%f =? %f",timeNeeded,[bird.foodGatheringTimeRemaining floatValue]*3600);
    float percentComplete = initialPercentageComplete + ((gatherRate * timeElapsed / 3600)/amountNeededToLevel);
    if (percentComplete > 100.0) percentComplete = 100.0;
    if (lastPercentageComplete != percentComplete)
        [self.progress setProgress:percentComplete  animated:FALSE];
    lastPercentageComplete = percentComplete;
    
    //food counter
    
    float foodAmount = initialFoodAmount + (gatherRate * timeElapsed / 3600);
    self.food.text = [NSString stringWithFormat:@"%d",[[NSNumber numberWithFloat:foodAmount] intValue]];
    
    //time remaining counter
    
    int timeLeft = [[NSNumber numberWithFloat:([bird.foodLimitForLevel floatValue] - foodAmount)/(gatherRate/3600)] intValue]; //in seconds;
    IBNavigationBarButtonItem * rightButton = (IBNavigationBarButtonItem *)self.navigationItem.rightBarButtonItem;
    [rightButton.mainButton setTitle:[NSString stringWithFormat:@"%dh , %dm ",timeLeft/3600,(timeLeft %3600)/60] forState:UIControlStateDisabled];
}


#pragma mark - View lifecycle


-(void)loadView {
    [super loadView];
    Bird * bird = [[Environment sharedInstance] currentBird];
    CLLocation * location = (CLLocation *)[bird baseLocation];
    CLLocationCoordinate2D theCoordinate = location.coordinate;
	//theCoordinate.latitude = 37.810000;
    //theCoordinate.longitude = -122.477989;
	
	BirdAnnotation *annotation = [[[BirdAnnotation alloc] initWithCoordinate:theCoordinate] autorelease];
    [mapView addAnnotation:annotation];
    self.birdAnnotation = annotation; 
    [self startDisplayLink];
    self.food.text = [bird.currentFood stringValue];
    self.gold.text = [[[Environment sharedInstance] currentUser].goldCoins stringValue];
    //[self.progress setProgress:0.0 animated:FALSE];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[IBNavigationBarButtonItem alloc] initAsJourneyButtonWithTitle:@"3h , 3m" enabled:FALSE];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    Bird * bird = [[Environment sharedInstance] currentBird];
    float progressPercentage = [bird.currentFood floatValue] /  [bird.foodLimitForLevel floatValue];
    [self.progress setProgress:progressPercentage  animated:FALSE];
    initialPercentageComplete = progressPercentage;
    initialFoodAmount = [bird.currentFood floatValue];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;		
	}
	static NSString * const kBirdAnnotationIdentifier = @"BirdIdentifier";
	self.birdTopView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:kBirdAnnotationIdentifier];
	
	if (birdTopView) {
		birdTopView.annotation = annotation;
	} else {
		// Use class method to create DDAnnotationView (on iOS 3) or built-in draggble MKPinAnnotationView (on iOS 4).
		self.birdTopView = [[[AnimatedAnnotation alloc] initWithAnnotation:annotation reuseIdentifier:kBirdAnnotationIdentifier imageName:@"WhiteBirdTop" imageExtension:@"png" imageCount:5 animationDuration:1.0] autorelease];
	}		
	
	return birdTopView;
}

- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    [super performSegueWithIdentifier:identifier sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
}


-(IBAction)goToCaptureScreen:(id)sender {
    [self stopDisplayLink];
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    BirdCaptureViewController * dController = [storyboard instantiateViewControllerWithIdentifier:@"BirdCaptureViewController"];
    dController.navigationItem.hidesBackButton = YES;
    [self.navigationController presentModalViewController:dController animated:TRUE];
    

}

-(IBAction)goToImages:(id)sender {
    [self stopDisplayLink];
    BirdPhotosViewController * dController = [[BirdPhotosViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController presentModalViewController:dController animated:TRUE];
    
}


@end
