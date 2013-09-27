//
//  BirdSendOnTripViewController.h
//  iBirds
//
//  Created by Samuel Westrich on 9/30/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CenteredPopupView.h"

@interface BirdSendOnTripViewController : UIViewController <CenteredPopupView> {
    UILabel * birdsFoodLabel;

}

@property(nonatomic,retain) IBOutlet UILabel * birdsFoodLabel;

-(IBAction)cancelTrip:(id)sender;

-(IBAction)startTrip:(id)sender;

@end
