//
//  IBNavigationItem.h
//  iBirds
//
//  Created by Samuel Westrich on 9/23/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BirdViewControllerProtocol.h"

@interface IBNavigationBarButtonItem : UIBarButtonItem {
    NSString * destinationControllerName;
    UIViewController<BirdViewControllerProtocol> * parentController;
    NSString * uniqueIdentifier;
    UIButton * mainButton;
}

@property (nonatomic,retain) NSString * uniqueIdentifier;
@property (nonatomic,retain) NSString * destinationControllerName;
@property (nonatomic,assign) IBOutlet UIViewController<BirdViewControllerProtocol> * parentController;
@property (nonatomic,retain) UIButton * mainButton;

-(id)initWithCustomView:(UIView *)customView backgroundImageForNormalState:(UIImage*)imageForNormalState backgroundImageForDisabledState:(UIImage*)imageForDisabledState;

-(id)initAsJourneyButtonWithTitle:(NSString*)title enabled:(BOOL)isEnabled;

@end
