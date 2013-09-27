//
//  InteractiveObject.m
//  OverlayTechDemo
//
//  Created by Samuel Westrich on 8/7/11.
//  Copyright 2011 ADYLITICA. All rights reserved.
//

#import "InteractiveObject.h"

@implementation InteractiveObject

@synthesize scaleValue;
@synthesize alpha;
@synthesize size;
@synthesize x;
@synthesize y;
@synthesize z;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void) draw
{
    
}

-(void) fireAction
{
	NSLog(@"Touched");
	self.alpha = 0.5f;
}

-(void)drawWithFrameCount:(NSInteger)frame {
    
}

@end
