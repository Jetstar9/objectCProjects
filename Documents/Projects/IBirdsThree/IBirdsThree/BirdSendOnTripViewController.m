//
//  BirdSendOnTripViewController.m
//  iBirds
//
//  Created by Samuel Westrich on 9/30/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import "BirdSendOnTripViewController.h"

@implementation BirdSendOnTripViewController

@synthesize birdsFoodLabel;

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

-(IBAction)cancelTrip:(id)sender {
    [UIView animateWithDuration:0.25 animations:^() {
        self.view.alpha = 0.0;
    }
                     completion:^(BOOL completed) {
                        [self.view removeFromSuperview];
                         [self release];
                     }];
    
}

-(IBAction)startTrip:(id)sender {
    
}


-(CGRect)popUpSize {
    return CGRectMake(25, 63, 269, 194);
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

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
