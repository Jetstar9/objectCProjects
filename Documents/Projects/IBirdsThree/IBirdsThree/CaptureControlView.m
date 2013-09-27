//
//  CaptureControlView.m
//  OverlayTechDemo
//
//  Created by Samuel Westrich on 8/19/11.
//  Copyright 2011 ADYLITICA. All rights reserved.
//

#import "CaptureControlView.h"
#import <QuartzCore/QuartzCore.h>
@implementation CaptureControlView

@synthesize delegate;
@synthesize button;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        self.button =[UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.cornerRadius=48;
        [button setFrame:CGRectMake(0, 0, 98, 108)];
        [button setCenter:CGPointMake(frame.size.width / 2,frame.size.height)];
        [button setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.6]];
        [button addTarget:self action:@selector(capture:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [[UIImage imageNamed:@"BottomCapturer.png"] drawInRect:rect];

}

-(void)dealloc {
    [button release];
    [super dealloc];
}

-(void)capture:(id)sender 
{
    [delegate capture:self];
}

-(void)allowCapture:(id)sender {
    [button setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.0]];
    [button addTarget:self action:@selector(capture:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)disallowCapture:(id)sender {
    [button setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.6]];
    [button removeTarget:self action:@selector(capture:) forControlEvents:UIControlEventTouchUpInside];
}


@end
