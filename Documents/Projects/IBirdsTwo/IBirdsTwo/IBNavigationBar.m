//
//  IBNavigationItem.m
//  iBirds
//
//  Created by Samuel Westrich on 9/23/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import "IBNavigationBar.h"

@implementation IBNavigationBar

-(id)initWithCoder:(NSCoder *)aDecoder {
    id r = [super initWithCoder:aDecoder];
    if (r) {
        [self setBackgroundImage:[UIImage imageNamed:@"NavigationBarBlueGradient.png"] forBarMetrics:UIBarMetricsDefault];
        [self setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIFont fontWithName:@"Montez-Regular" size:26],UITextAttributeFont,
                                      nil]];
    }
    return r;
}
-(id)initWithFrame:(CGRect)frame {
    id r = [super initWithFrame:frame];
    if (r) {
        [self setBackgroundImage:[UIImage imageNamed:@"NavigationBarBlueGradient.png"] forBarMetrics:UIBarMetricsDefault];
    }
    return r;
}

@end
