//
//  IBNavigationController.m
//  iBirds
//
//  Created by Samuel Westrich on 9/24/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import "IBNavigationController.h"
#import <QuartzCore/QuartzCore.h>

@implementation IBNavigationController

- (void)viewWillAppear:(BOOL)animated
{
    CGFloat navigationBarBottom;
    navigationBarBottom = self.navigationBar.frame.origin.y + self.navigationBar.frame.size.height;
    
    CALayer *newShadow = [[[CALayer alloc] init] autorelease];
    [newShadow setContents:(id)[UIImage imageNamed:@"NavBarShadow.png"].CGImage];
    newShadow.frame = CGRectMake(0,navigationBarBottom, self.view.frame.size.width, 5);
    //newShadow.colors = [NSArray arrayWithObjects:(id)darkestShade, (id)darkerShade, (id)clearShade , nil];

    
    [self.view.layer addSublayer:newShadow];
    [super viewWillAppear:animated];
}


@end
