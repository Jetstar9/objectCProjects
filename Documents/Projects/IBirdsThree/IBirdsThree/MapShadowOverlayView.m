//
//  MapShadowOverlayView.m
//  iBirds
//
//  Created by Samuel Westrich on 9/29/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import "MapShadowOverlayView.h"

@implementation MapShadowOverlayView

- (id)initWithOverlay:(id <MKOverlay>)overlay
{
    if (self = [super initWithOverlay:overlay]) {
       // [self initColors];
    }
    return self;
}

- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context {
    [super drawMapRect:mapRect zoomScale:zoomScale inContext:context];
    CGRect circleRect = [self rectForMapRect:mapRect];
    
    CGMutablePathRef circlePath = CGPathCreateMutable();
    CGPathAddRect(circlePath, NULL, circleRect);
    CGPathAddArc(circlePath, NULL, circleRect.size.width/2, circleRect.size.height/2, circleRect.size.width / 2, 0, M_PI * 2, FALSE);
    CGContextAddPath(context, circlePath);
    CGContextSetFillColorWithColor(context, [[UIColor blackColor] colorWithAlphaComponent:0.3].CGColor);
    CGContextEOFillPath(context);
    NSLog(@"%f %f",circleRect.origin.x, circleRect.origin.y);
}


@end
