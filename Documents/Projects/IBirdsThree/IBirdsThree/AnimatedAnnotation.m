//
//  AnimatedAnnotation.m
//  iBirds
//
//  Created by Samuel Westrich on 10/17/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import "AnimatedAnnotation.h"

@implementation AnimatedAnnotation
@synthesize imageView = _imageView;
@synthesize imageName, imageCount, imageExtension,animationDuration;

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier imageName:(NSString *)name imageExtension:(NSString *)extension imageCount:(int)count animationDuration:(float)duration
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    self.imageCount = count;
    self.imageName = name;
    self.imageExtension = extension;
    self.animationDuration = duration;
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@0.%@",name,extension]];
    self.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    self.backgroundColor = [UIColor clearColor];
    
    
    _imageView = [[UIImageView alloc] initWithFrame:self.frame];
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for(int i = 0; i < count; i++ ){
        [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@%d.%@", name, i, extension]]];
    }
    
    
    _imageView.animationDuration = duration;
    _imageView.animationImages = images;
    _imageView.animationRepeatCount = 0;
    [_imageView startAnimating];
    
    [self addSubview:_imageView];
    
    return self;
}

-(void) dealloc
{
    [_imageView release];
    [imageName release];
    [imageExtension release];
    [super dealloc];
}


@end
