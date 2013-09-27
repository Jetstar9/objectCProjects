//
//  ControlsView.m
//  OverlayTechDemo
//
//  Created by Samuel Westrich on 8/19/11.
//  Copyright 2011 ADYLITICA. All rights reserved.
//

#import "ControlsView.h"
#import "Constants.h"
#import "BirdObject.h"

@implementation ControlsView
@synthesize ccV;
@synthesize oldBirdsInReticule;
@synthesize birdButton;
@synthesize catchableBird;
@synthesize imagePickerController;
@synthesize birdsFarAwayTriangles;
@synthesize oldBirdsFarAway;
@synthesize radarView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.birdsFarAwayTriangles = [NSMutableDictionary dictionary];
        catchableBird = nil;
        self.oldBirdsInReticule = [NSMutableSet set];
        [self setBackgroundColor:[UIColor clearColor]];
        UIImage * image = [[UIImage imageNamed:@"TextBox.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:15];
        self.birdButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [birdButton setBackgroundImage:image forState:UIControlStateNormal];
        birdButton.frame= CGRectMake(10.0, 10.0, 200, image.size.height);
        [birdButton setTitleColor:[UIColor colorWithWhite:0.2 alpha:1.0] forState:UIControlStateNormal];
        //[button addTarget:self action:@selector(loveme:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:birdButton];
        
        UIImageView * reticuleView = [[UIImageView alloc] initWithFrame:RETICULE];
        [reticuleView setImage:[UIImage imageNamed:@"Reticule.png"]];
        [self addSubview:reticuleView];
        [reticuleView release];
        
        CaptureControlView * lCCV = [[CaptureControlView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 58, self.frame.size.width, 58)];
        self.ccV = lCCV;
        lCCV.delegate = self;
        [self addSubview:lCCV];
        [lCCV release];
        
        RadarView * lRadarView = [[RadarView alloc] initWithFrame:CGRectMake(220, 0, 100, 100)];
        self.radarView = lRadarView;
        [self addSubview:lRadarView];
        [lRadarView release];


    }
    return self;
}

-(void)capture:(id)sender 
{
    [imagePickerController takePicture];
}


-(void)dealloc {
    [catchableBird release];
    [birdButton release];
    [ccV release];
    [oldBirdsInReticule release];
    [super dealloc];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}
*/

-(void)birdsAreInReticule:(NSSet *)birds {
    [oldBirdsInReticule minusSet:birds];
    for (BirdObject * bird in oldBirdsInReticule) {
        [bird setIsTargeted:FALSE];
        if ([bird isEqual:self.catchableBird]) {
            self.catchableBird = nil;
            [ccV disallowCapture:self];
            bird.delegate = nil;
        }
    }
    if (birds.count == 0) {
        if (![birdButton isHidden]) [UIView animateWithDuration:1.0 delay:0.5 options:UIViewAnimationOptionBeginFromCurrentState
                                     |UIViewAnimationOptionCurveEaseInOut
                                     |UIViewAnimationOptionTransitionNone 
                                                     animations:^{
            birdButton.alpha = 0.0f;
        } completion:^(BOOL finished) {
            
        }];
    } else {
        [birdButton setAlpha:1.0];
    }
    for (BirdObject * bird in birds) {
        [bird setIsTargeted:TRUE];
        bird.delegate = self;
        [birdButton setTitle:[NSString stringWithFormat:@"%.1fm - %@ (%.1fm/s)",[bird distance],bird.name,bird.speed] forState:UIControlStateNormal];
    }
    self.oldBirdsInReticule = [NSMutableSet setWithSet:birds];
}

-(void)birdsAreFarAway:(NSSet *)birds {
    NSMutableSet * newBirds = [NSMutableSet setWithSet:birds];
    [newBirds minusSet:oldBirdsFarAway];
    
    //for all new birds;
    for (BirdObject * bird in newBirds) {
        UIImageView * newTriangle = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 26, 23)];
        [newTriangle setImage:[UIImage imageNamed:@"Triangle.png"]];
        [birdsFarAwayTriangles setObject:newTriangle forKey:[bird.identifier stringValue]];
        [self addSubview:newTriangle];
        [newTriangle release];
    }
    
    [oldBirdsFarAway minusSet:birds];
    //for all deleted birds
    for (BirdObject * bird in oldBirdsFarAway) {
        UIImageView * oldTriangle = [birdsFarAwayTriangles objectForKey:[bird.identifier stringValue]];
        [oldTriangle removeFromSuperview];
        [birdsFarAwayTriangles removeObjectForKey:[bird.identifier stringValue]];
    }
    
    for (BirdObject * bird in birds) {
        UIImageView * triangle = [birdsFarAwayTriangles objectForKey:[bird.identifier stringValue]];
        [triangle setCenter:CGPointMake(bird.screenX,bird.screenY)];
    }
    self.oldBirdsFarAway = [NSMutableSet setWithSet:birds];
}

-(void)birdIsCatchable:(id)lBird {
    BirdObject * bird = lBird;
    if (![bird isEqual:catchableBird]) {
        self.catchableBird = bird;
        [ccV allowCapture:self];
    }
}

-(void)setBirdsShowingUpInRadar:(NSSet *)birds {
    [self.radarView setBirdsShowingUpInRadar:birds];
}

-(void)updateRadarDirectionWithHeading:(CGFloat)yaw {
    [self.radarView updateRadarDirectionWithHeading:yaw];
}

@end
