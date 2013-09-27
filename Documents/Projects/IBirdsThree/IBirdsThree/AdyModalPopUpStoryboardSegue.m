//
//  AdyModalPopUpStoryboardSegue.m
//  Adylitica
//
//  Created by Samuel Westrich on 9/10/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import "AdyModalPopUpStoryboardSegue.h"
#import "CenteredPopupView.h"

@implementation AdyModalPopUpStoryboardSegue


-(void)perform {
    UIViewController * destination = ((UIViewController*)self.destinationViewController);
    UIViewController * source = ((UIViewController*)self.sourceViewController);
    [destination.view setBackgroundColor:[UIColor clearColor]];
    destination.view.alpha = 0.0;
    [source.view addSubview:destination.view];
    NSLog(@"%@",NSStringFromCGRect(destination.view.frame));
    destination.view.frame = [((id<CenteredPopupView>)destination) popUpSize];
    [UIView animateWithDuration:0.5 animations:^() {
        destination.view.alpha = 1.0;
    }
                     completion:^(BOOL completed) {
                         
                         //[destination.view removeFromSuperview];
                         //[source presentModalViewController:destination animated:FALSE];
                     }];
    
    [destination retain]; // the popup should release it's view controller;
    
}

@end
