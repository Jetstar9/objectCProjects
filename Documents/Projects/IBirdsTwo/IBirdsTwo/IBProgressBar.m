//
//  IBProgressBar.m
//  iBirds
//
//  Created by Samuel Westrich on 9/28/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import "IBProgressBar.h"
#import "drawing.m"

@implementation IBProgressBar

@synthesize tintColor;

-(void)dealloc {
    [tintColor release];
    [super dealloc];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        self.tintColor = [UIColor colorWithRed:59.0f/256.0f green:37.0f/256.0f blue:2.0f/256.0f alpha:1.0];
        self.progress = 0.5;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame tintColor:(UIColor*)color
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.tintColor = color;
    }
    return self;
}

-(void)setProgress:(CGFloat)lProgress {
    [self setProgress:lProgress animated:FALSE];
}

-(CGFloat)progress {
    return progress;
}

- (void) moveProgress
{
    if (self.progress < targetProgress)
	{
        self.progress = MIN(self.progress + 0.01, targetProgress);
    }
    else if(self.progress > targetProgress)
    {
        self.progress = MAX(self.progress - 0.01, targetProgress);
    }
    else
	{
        [progressTimer invalidate];
        progressTimer = nil;
    }
}

- (void) setProgress:(CGFloat)newProgress animated:(BOOL)animated
{
    if (animated)
	{
        targetProgress = newProgress;
        if (progressTimer == nil)
		{
            progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(moveProgress) userInfo:nil repeats:YES];
        }
    }
	else
	{
        progress = newProgress;
        [self setNeedsDisplay];
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //draw first white layer

    float alpha = 1.0;
    float frontAlpha = 1.0;
    const CGFloat * tintComponents = CGColorGetComponents([tintColor CGColor]);
    CGRect smallerRect = rect;
    smallerRect.origin.x += 1;
    smallerRect.origin.y += 1;
    smallerRect.size.width -= 2;
    smallerRect.size.height -= 2;
    float cornerRadius = smallerRect.size.height / 2.0;
    addRoundedRectToPath(ctx, rect, cornerRadius, cornerRadius);
    CGContextClip(ctx);
    CGContextSetLineWidth(ctx, 1);
    //CGContextSetRGBFillColor(ctx, 1, 1, 1, 1);
    //CGContextFillRect(ctx, rect);
    addRoundedRectToPath(ctx, smallerRect, cornerRadius, cornerRadius);
    CGContextClip(ctx);
    
    /// BACKGROUND
    CGGradientRef myGradient;
    
    CGColorSpaceRef myColorspace;
    
    size_t num_locations = 3;
    
    CGFloat locations[3] = { 0.0, 0.3, 1.0 };
    
    CGFloat components[12] = {   // Start color
        
        100.0/255.0, 100.0/255.0, 100.0/255.0, 1.0 * alpha,
        170.0/255.0, 170.0/255.0, 170.0/255.0, 1.0 * alpha,
        
        1.0, 1.0, 1.0, alpha}; // End color
    
    
    
    myColorspace = CGColorSpaceCreateDeviceRGB();
    
    myGradient = CGGradientCreateWithColorComponents (myColorspace, components,
                                                      
                                                      locations, num_locations);
    
    CGPoint myStartPoint, myEndPoint;
    
    myStartPoint.x = 0.0;
    
    myStartPoint.y = 0.0;
    
    myEndPoint.x = 0.0;
    
    myEndPoint.y = smallerRect.size.height / 1.2;
    
    //CGContextDrawLinearGradient (ctx, myGradient, myStartPoint, myEndPoint, 0);
    
    ///END BACKGROUND
    
    CGRect progressRect = smallerRect;
    progressRect.size.width *= [self progress];
    
    CGContextSaveGState(ctx);
    CGContextClipToRect(ctx, progressRect);
    
    CGFloat locations3[3] = { 0.1, 0.38, 0.9 };
    float darker = 0.5;
    CGFloat components3[12] = {   // Start color
        
        tintComponents[0], tintComponents[1], tintComponents[2], tintComponents[3] * frontAlpha,
        tintComponents[0], tintComponents[1], tintComponents[2], tintComponents[3] * frontAlpha,
        tintComponents[0]*darker, tintComponents[1]*darker, tintComponents[2]*darker, tintComponents[3] * frontAlpha
    }; // End color
    
    
    CGGradientRelease(myGradient);
    
    myGradient = CGGradientCreateWithColorComponents (myColorspace, components3,
                                                      
                                                      locations3, 3);
    
    myStartPoint.x = 0.0;
    
    myStartPoint.y = 0.0;
    
    myEndPoint.x = 0.0;
    
    myEndPoint.y = rect.size.height;
    
    CGContextDrawLinearGradient (ctx, myGradient, myStartPoint, myEndPoint, 0);
    CGContextRestoreGState(ctx);
    
    
    CGGradientRelease(myGradient);}



@end
