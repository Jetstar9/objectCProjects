//
//  InteractiveObject.h
//  OverlayTechDemo
//
//  Created by Samuel Westrich on 8/7/11.
//  Copyright 2011 ADYLITICA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <OpenGLES/ES1/gl.h>
#import "EAGLView.h"

@interface InteractiveObject : NSObject {
    
    EAGLView * eaglView;
    GLuint textureId;
    GLfloat scaleValue;
	GLfloat alpha;
    float x;
	float y;
	float z;
    CGPoint size;
    /* OpenGL name for the sprite texture */
	GLuint * spriteTexture;
}


@property GLfloat	scaleValue;
@property GLfloat	alpha;
@property CGPoint   size;
@property(readonly) float		x;
@property(readonly) float		y;
@property(readonly) float		z;


-(void) drawWithFrameCount:(NSInteger)frame;
-(void) fireAction;

@end
