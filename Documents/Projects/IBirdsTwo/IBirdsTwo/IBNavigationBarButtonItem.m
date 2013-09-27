//
//  IBNavigationBarButtonItem.m
//  iBirds
//
//  Created by Samuel Westrich on 9/23/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import "IBNavigationBarButtonItem.h"

@implementation IBNavigationBarButtonItem

@synthesize destinationControllerName;
@synthesize parentController;
@synthesize uniqueIdentifier;
@synthesize mainButton;

-(id)initWithCoder:(NSCoder *)aDecoder {
    IBNavigationBarButtonItem * r = [super initWithCoder:aDecoder];
    if (r) {
        //[self setTitlePositionAdjustment:UIOffsetMake(15, 0) forBarMetrics:UIBarMetricsDefault];
        UIFont * font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [customButton setFrame:CGRectMake(0, 0, [r.title sizeWithFont:font].width + 20, 31)];
        customButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [customButton setTitle:r.title forState:UIControlStateNormal];
        [customButton setBackgroundImage:[UIImage imageNamed:@"NavigationItemBlueGradient.png"] forState:UIControlStateNormal];
        [customButton addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
        self.mainButton = customButton;
        return [self initWithCustomView:customButton backgroundImageForNormalState:[UIImage imageNamed:@"NavigationItemBlueGradient.png"] backgroundImageForDisabledState:nil];
    }
    return nil;
}
-(id)initWithCustomView:(UIView *)customView backgroundImageForNormalState:(UIImage*)imageForNormalState backgroundImageForDisabledState:(UIImage*)imageForDisabledState {
    id r = [super initWithCustomView:customView];
    if (r) {
        [self setBackgroundImage:imageForNormalState forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        if (imageForDisabledState)
            [self setBackgroundImage:[UIImage imageNamed:@"NavigationItemBlueGradient.png"] forState:UIControlStateDisabled barMetrics:UIBarMetricsDefault];
    }
    return r;
}

-(void)clicked:(id)sender {
    NSAssert(self.destinationControllerName != nil, @"destination Controller is not nil");
    if ([self.parentController needsNetworkValidation]) {
        [self.parentController hasBeenValidatedByButtonWithIdentifier:self.uniqueIdentifier];
    } else {
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
        UIViewController * dController = [storyboard instantiateViewControllerWithIdentifier:destinationControllerName];
        [parentController.navigationController pushViewController:dController animated:TRUE];
    }
    
}

- (id)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem target:(id)target action:(SEL)action {
    IBNavigationBarButtonItem * r = [super initWithBarButtonSystemItem:systemItem target:target action:action];
    if (r) {
        [r setBackgroundImage:[UIImage imageNamed:@"NavigationItemBlueGradient.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    }
    return r;
}

-(id)initAsJourneyButtonWithTitle:(NSString*)title enabled:(BOOL)isEnabled {
    UIFont * font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [customButton setFrame:CGRectMake(0, 0, [title sizeWithFont:font].width + 20, 31)];
    customButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    [customButton setTitle:title forState:UIControlStateNormal];
    [customButton setBackgroundImage:[UIImage imageNamed:@"TimeRemainingBarButton.png"] forState:UIControlStateNormal];
    [customButton addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    self.mainButton = customButton;
    IBNavigationBarButtonItem * r = [self initWithCustomView:customButton];
    [r setEnabled:isEnabled];
    return r;
}


@end
