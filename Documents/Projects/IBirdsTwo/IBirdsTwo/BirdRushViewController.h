//
//  BirdRushViewController.h
//  iBirds
//
//  Created by Samuel Westrich on 9/27/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CenteredPopupView.h"

@interface BirdRushViewController : UIViewController <CenteredPopupView> {
    UILabel * goldLabel;
    UIButton * rushButton;
}

@property(nonatomic,retain) IBOutlet UILabel * goldLabel;
@property(nonatomic,retain) IBOutlet UIButton * rushButton;

-(IBAction)buyGold:(id)sender;

-(IBAction)rushBird:(id)sender;

-(IBAction)cancelHurry:(id)sender;

@end
