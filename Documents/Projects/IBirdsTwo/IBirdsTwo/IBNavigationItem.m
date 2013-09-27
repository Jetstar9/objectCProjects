//
//  IBNavigationItem.m
//  iBirds
//
//  Created by Samuel Westrich on 9/23/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import "IBNavigationItem.h"

@implementation IBNavigationItem

-(id)initWithTitle:(NSString *)title {
    IBNavigationItem * r = [super initWithTitle:title];
    
    
    return r;
}
-(id)initWithCoder:(NSCoder *)aDecoder {
    IBNavigationItem * r = [super initWithCoder:aDecoder];
    if (r) {
        UIFont * font = [UIFont fontWithName:@"Montez-Regular" size:34];
        CGSize size = [r.title sizeWithFont:font];
        UILabel * tView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, 44)];
        
        [tView setFont:font];
        [tView setTextAlignment:UITextAlignmentCenter];
        [tView setBackgroundColor:[UIColor clearColor]];
        [tView setTextColor:[UIColor whiteColor]];
        [tView setShadowColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
        tView.text = r.title;
        r.titleView = tView;

    }
    return r;
}

@end
