//
//  BirdCreationViewController.h
//  iBirds
//
//  Created by Samuel Westrich on 9/19/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "User.h"
#import "Bird.h"
#import "BirdViewControllerProtocol.h"
typedef enum {
	eLoginSwitchingTypeUndefined,
	eLoginSwitchingTypeRealToReal,
	eLoginSwitchingTypeRealToNone,
	eLoginSwitchingTypeNoneToNone,
} eLoginSwitchingType; //switching between keyboards


@interface BirdCreationViewController : UITableViewController <UITextFieldDelegate,BirdViewControllerProtocol> {
    eLoginSwitchingType transientSwitchType;
	int position;
    User * currentUser;
    Bird * currentBird;
    BOOL needsCreation;
    UIBarButtonItem * rightButton;
    UIBarButtonItem * tempRightButton;
}


@property(nonatomic,retain) UIBarButtonItem * tempRightButton;
-(IBAction)createBird:(id)sender;

@end
