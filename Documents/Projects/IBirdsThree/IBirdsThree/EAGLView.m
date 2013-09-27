/*
     File: EAGLView.m
 Abstract: This class wraps the CAEAGLLayer from CoreAnimation into a convenient
 UIView subclass. The view content is basically an EAGL surface you render your
 OpenGL scene into.  Note that setting the view non-opaque will only work if the
 EAGL surface has an alpha channel.
 
  Version: 1.9
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2010 Apple Inc. All Rights Reserved.
 
*/

#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>

#import "EAGLView.h"
#import "BirdCage.h"
#import "glues.h"
#import "MathTools.h"
#import "InteractiveObject.h"
#import "Bird.h"


@interface EAGLView (EAGLViewPrivate)

- (BOOL)createFramebuffer;
- (void)destroyFramebuffer;
-(Boolean) checkCollission:(CGPoint)winPos object:(InteractiveObject*) _object;


@end

@interface EAGLView (EAGLViewSprite)

- (void)setupView;

@end

@implementation EAGLView

@synthesize animating;
@dynamic animationFrameInterval;
@synthesize delegate;

// You must implement this
+ (Class) layerClass
{
	return [CAEAGLLayer class];
}


//The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id)initWithCoder:(NSCoder*)coder
{
	if((self = [super initWithCoder:coder])) {
		// Get the layer
		CAEAGLLayer *eaglLayer = (CAEAGLLayer*) self.layer;
		
		eaglLayer.opaque = NO;
		eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
										[NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
		
		context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
		
		if(!context || ![EAGLContext setCurrentContext:context] || ![self createFramebuffer]) {
			[self release];
			return nil;
		}
		
		animating = FALSE;
		displayLinkSupported = FALSE;
		animationFrameInterval = 1;
		displayLink = nil;
		animationTimer = nil;
		
		// A system version of 3.1 or greater is required to use CADisplayLink. The NSTimer
		// class is used as fallback when it isn't available.
		NSString *reqSysVer = @"3.1";
		NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
		if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending)
			displayLinkSupported = TRUE;
		
		[self setupView];
		[self drawView];
        
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        
        CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
        const CGFloat myColor[] = {0.0, 0.0, 0.0, 0.0};
        eaglLayer.backgroundColor = CGColorCreate(rgb, myColor);
        CGColorSpaceRelease(rgb);
        
        [[BirdCage sharedInstance] setDelegate:self];
        //[[BirdCage sharedInstance] addFakeBirdAtBearing:0.0 atDistance:5.0];
        
        
	}
	
	return self;
}

//The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id)initWithFrame:(CGRect)lFrame {
    
    if ((self = [super initWithFrame:lFrame])) {
		CAEAGLLayer *eaglLayer = (CAEAGLLayer*) self.layer;
		
		eaglLayer.opaque = NO;
		eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
										[NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
		
		context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
		
		if(!context || ![EAGLContext setCurrentContext:context] || ![self createFramebuffer]) {
			[self release];
			return nil;
		}
		
		animating = FALSE;
		displayLinkSupported = FALSE;
		animationFrameInterval = 1;
		displayLink = nil;
		animationTimer = nil;
		
		// A system version of 3.1 or greater is required to use CADisplayLink. The NSTimer
		// class is used as fallback when it isn't available.
		NSString *reqSysVer = @"3.1";
		NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
		if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending)
			displayLinkSupported = TRUE;
		
		[self setupView];
		[self drawView];
        
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        
        CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
        const CGFloat myColor[] = {0.0, 0.0, 0.0, 0.0};
        eaglLayer.backgroundColor = CGColorCreate(rgb, myColor);
        CGColorSpaceRelease(rgb);
        
        
        
        [[BirdCage sharedInstance] setDelegate:self];
        [[BirdCage sharedInstance] addFakeBirdAtBearing:(0) atDistance:7.07];
        //[[BirdCage sharedInstance] addFakeBirdAtBearing:(M_PI_2) atDistance:5.0];
        //[[BirdCage sharedInstance] addFakeBirdAtBearing:0 atDistance:100.0];
        //[[BirdCage sharedInstance] addFakeBirdAtBearing:M_PI +M_PI_4/2.0  atDistance:30.0 withAltitude:3.0];
        //[[BirdCage sharedInstance] addFakeBirdAtBearing:M_PI atDistance:400.0];
        //[[BirdCage sharedInstance] addFakeBirdAtBearing:M_PI +M_PI_4/2.0  atDistance:10.0 withAltitude:3.0];
        //[[BirdCage sharedInstance] addFakeBirdAtBearing:(M_PI_4) atDistance:12.0 withAltitude:3];
        //[[BirdCage sharedInstance] addFakeBirdAtBearing:M_PI_4*3/2 atDistance:2.0 withAltitude:2.0];
        //[[BirdCage sharedInstance] addFakeBirdAtBearing:M_PI_4*7/4  atDistance:30.0 withAltitude:10.0];
    }
	
    return self;
}


- (void)layoutSubviews
{
	[EAGLContext setCurrentContext:context];
	[self destroyFramebuffer];
	[self createFramebuffer];
	[self drawView];
}


- (BOOL)createFramebuffer
{
	glGenFramebuffersOES(1, &viewFramebuffer);
	glGenRenderbuffersOES(1, &viewRenderbuffer);
	
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	[context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(id<EAGLDrawable>)self.layer];
	glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
	
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
	
	if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
		NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
		return NO;
	}
	
	return YES;
}


- (void)destroyFramebuffer
{
	glDeleteFramebuffersOES(1, &viewFramebuffer);
	viewFramebuffer = 0;
	glDeleteRenderbuffersOES(1, &viewRenderbuffer);
	viewRenderbuffer = 0;
	
	if(depthRenderbuffer) {
		glDeleteRenderbuffersOES(1, &depthRenderbuffer);
		depthRenderbuffer = 0;
	}
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSSet* allTouches = [event allTouches];
	if([allTouches count] == 1)
	{
		touched = true;
	}
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	touched = false;
	NSSet* allTouches = [event allTouches];
	UITouch*touch1 = [[allTouches allObjects] objectAtIndex:0];
	CGPoint touch1Point = [touch1 locationInView:self];
	
	
	for(NSNumber* interactiveObjectNum in [[BirdCage sharedInstance] birds])
	{
        InteractiveObject * interactiveObject = [[[BirdCage sharedInstance] birds] objectForKey:interactiveObjectNum];
		
		if([self checkCollission:touch1Point object:interactiveObject])
		{
			[interactiveObject fireAction];
		}
	}
	
}

#define RAY_ITERATIONS 1000
#define COLLISION_RADIUS 0.2f
-(Boolean) checkCollission:(CGPoint)winPos object:(InteractiveObject*) _object
{	
	winPos.y = (float)__viewport[3] - winPos.y;
	
	GLPoint3D nearPoint;
	GLPoint3D farPoint;
	GLPoint3D rayVector;
	
	//Retreiving position projected on near plan
	gluUnProject( winPos.x, winPos.y , 0, __modelview, __projection, __viewport, &nearPoint.x, &nearPoint.y, &nearPoint.z);
    
	//Retreiving position projected on far plan
	gluUnProject( winPos.x, winPos.y,  1, __modelview, __projection, __viewport, &farPoint.x, &farPoint.y, &farPoint.z);
	
	//Processing ray vector
	rayVector.x = farPoint.x - nearPoint.x;
	rayVector.y = farPoint.y - nearPoint.y;
	rayVector.z = farPoint.z - nearPoint.z;
	
	float rayLength = sqrtf(POW2(rayVector.x) + POW2(rayVector.y) + POW2(rayVector.z));
	
	//normalizing ray vector
	rayVector.x /= rayLength;
	rayVector.y /= rayLength;
	rayVector.z /= rayLength;
	
	
	GLPoint3D collisionPoint;
	GLPoint3D objectCenter = {_object.x, _object.y, _object.z};
	
	//Iterating over ray vector to check collisions
	for(int i = 0; i < RAY_ITERATIONS; i++)
	{
		collisionPoint.x = rayVector.x * rayLength/RAY_ITERATIONS*i;
		collisionPoint.y = rayVector.y * rayLength/RAY_ITERATIONS*i;
		collisionPoint.z = rayVector.z * rayLength/RAY_ITERATIONS*i;
		
		//Checking collision 
		if([MathTools pointSphereCollision:collisionPoint center:objectCenter radius:COLLISION_RADIUS])
		{
			return TRUE;
		}
	}
	
	
	return FALSE;	
} 



- (NSInteger) animationFrameInterval
{
	return animationFrameInterval;
}

- (void) setAnimationFrameInterval:(NSInteger)frameInterval
{
	// Frame interval defines how many display frames must pass between each time the
	// display link fires. The display link will only fire 30 times a second when the
	// frame internal is two on a display that refreshes 60 times a second. The default
	// frame interval setting of one will fire 60 times a second when the display refreshes
	// at 60 times a second. A frame interval setting of less than one results in undefined
	// behavior.
	if (frameInterval >= 1)
	{
		animationFrameInterval = frameInterval;
		
		if (animating)
		{
			[self stopAnimation];
			[self startAnimation];
		}
	}
}

- (void) startAnimation
{
	if (!animating)
	{
		if (displayLinkSupported)
		{
			// CADisplayLink is API new to iPhone SDK 3.1. Compiling against earlier versions will result in a warning, but can be dismissed
			// if the system version runtime check for CADisplayLink exists in -initWithCoder:. The runtime check ensures this code will
			// not be called in system versions earlier than 3.1.
			
			displayLink = [NSClassFromString(@"CADisplayLink") displayLinkWithTarget:self selector:@selector(drawView)];
			[displayLink setFrameInterval:animationFrameInterval];
			[displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		}
		else
			animationTimer = [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)((1.0 / 60.0) * animationFrameInterval) target:self selector:@selector(drawView) userInfo:nil repeats:TRUE];
		
		animating = TRUE;
	}
}

- (void)stopAnimation
{
	if (animating)
	{
		if (displayLinkSupported)
		{
			[displayLink invalidate];
			displayLink = nil;
		}
		else
		{
			[animationTimer invalidate];
			animationTimer = nil;
		}
		
		animating = FALSE;
	}
}




/*int createSphere (GLfloat spherePoints[], GLfloat fRadius, GLfloat step)
{
    int points = 0;
    
    GLfloat uStep = DegreeToRadian(step);
    GLfloat vStep = uStep;
    
    for (GLfloat u = 0.0f; u <= (2 * M_PI); u += uStep) {
        for (GLfloat v = -M_PI_2; v <= M_PI_2; v += vStep) {
            
            // Point as per equation
            points++;
            spherePoints[(points - 1) * 3] = fRadius * cosf(v) * cosf(u);                        // x
            spherePoints[((points - 1) * 3) + 1] = fRadius * cosf(v) * sinf(u);                  // y
            spherePoints[((points - 1) * 3) + 2] = fRadius * sinf(v);                            // z
            
            // Next point around 
            points++;
            spherePoints[(points - 1) * 3] = fRadius * cosf(v) * cosf(u + uStep);                // x
            spherePoints[((points - 1) * 3) + 1] = fRadius * cosf(v) * sinf(u + uStep);          // y
            spherePoints[((points - 1) * 3) + 2] = fRadius * sinf(v);                            // z
            
            // Next point up
            points++;
            spherePoints[(points - 1) * 3] = fRadius * cosf(v + vStep) * cosf(u);                // x
            spherePoints[((points - 1) * 3) + 1] = fRadius * cosf(v + vStep) * sinf(u);          // y
            spherePoints[((points - 1) * 3) + 2] = fRadius * sinf(v + vStep);                    // z
            
            // Next point up and around
            points++;
            spherePoints[(points - 1) * 3] = fRadius * cosf(v + vStep) * cosf(u + uStep);        // x
            spherePoints[((points - 1) * 3) + 1] = fRadius * cosf(v + vStep) * sinf(u + uStep);  // y
            spherePoints[((points - 1) * 3) + 2] = fRadius * sinf(v + vStep);                    // z
            
        }
    }
    
    return points;
}*/

- (void)setupFrustumWithFov:(CGFloat)_fov
{	 
	const GLfloat zNear = 0.1, zFar = 100.0, fieldOfView = _fov;
    GLfloat size;
	
	CGRect rect = self.bounds;
	
    size = zNear * tanf(DegreesToRadians(fieldOfView) / 2.0);
	glLoadIdentity();
    glFrustumf(-size, size, -size / (rect.size.width / rect.size.height), size / (rect.size.width / rect.size.height), zNear, zFar);  	
	
}

/*-(void) setupProjection {
	glMatrixMode(GL_PROJECTION);
	
	CGFloat fov = 42.0f;
	[self setupFrustumWithFov:fov];	
	
	
	glRotatef(cameraXRotation, 1.f, 0.f, 0.f);
	glRotatef(cameraYRotation, 0.f, 1.f, 0.f);
	
	glTranslatef(0, 0, 0);
	glGetFloatv( GL_PROJECTION_MATRIX, __projection );
}*/

- (void)setupView
{
	

	
	

	glMatrixMode(GL_PROJECTION);

	glLoadIdentity();
	//glOrthof(-1.0f, 1.0f, -1.5f, 1.5f, -1.0f, 1.0f);
	GLfloat fov = 42.0f, zNear = 0.1f, zFar = 1000.0f, aspect = 1.5f;
	GLfloat ymax = zNear * tanf(fov * M_PI / 360.0f);
	GLfloat ymin = -ymax;
	glFrustumf(ymin / aspect, ymax / aspect, ymin, ymax, zNear, zFar);
    
    // Sets up matrices and transforms for OpenGL ES
	glViewport(0, 0, backingWidth, backingHeight);
    
    glGetIntegerv( GL_VIEWPORT, __viewport );
    //eye[0] = 0; eye[1] = 0; eye[2] = 0;
    //center[0] = 1.0; center[1] = 0; center[2] = 0;
    //up[0] = 0.0; center[1] = 1.0; center[2] = 0.0;
	glMatrixMode(GL_MODELVIEW);
	// Clears the view with transparency
	glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
    
    glEnable(GL_DEPTH_TEST);
	glDepthFunc(GL_LEQUAL);
	glEnable(GL_POLYGON_OFFSET_FILL);
	    
    // Set a blending function to use
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    // Enable blending
    glEnable(GL_BLEND);
    /**/

}


-(void) drawReferenceFrame {
    NSUInteger divs;
	GLUquadric *quadratic;
    
    quadratic = gluNewQuadric();
	divs = 10;
    
    gluQuadricNormals(quadratic, GLU_SMOOTH);
	gluQuadricTexture(quadratic, true);

    glPushMatrix();
    glTranslatef(10.0f, 0.0f, 0.0f);
    glColor4f(1.0f, 0.0f, 0.0f,0.5f); //red for east
    gluSphere(quadratic, 0.3, divs, divs);
    glPopMatrix();
    
    glPushMatrix();
    glTranslatef(0.0f, 10.0f, 0.0f);
    glColor4f(0.0f, 0.0f, 0.0f,0.5f); //black for north
    gluSphere(quadratic, 0.3, divs, divs);
    glPopMatrix();
    /*for (float i =0.0; i<360.0;i+=10.0) {
        glPushMatrix();
        glTranslatef(10*cosf(DegreeToRadian(i)), 10*sinf(DegreeToRadian(i)), 0.0f);
        glColor4f(cosf(DegreeToRadian(i)), sinf(DegreeToRadian(i)), 0.0f,0.5f);
        gluSphere(quadratic, 0.1 +((fmodf(i, 90) == 0.0)?0.2:0.0), divs, divs);
        glPopMatrix();
    }
    
    for (float i =0.0; i<360.0;i+=10.0) {
        glPushMatrix();
        glTranslatef( 0.0,10*cosf(DegreeToRadian(i)),10*sinf(DegreeToRadian(i)));
        glColor4f(0.0f,cosf(DegreeToRadian(i)),sinf(DegreeToRadian(i)),0.5f);
        gluSphere(quadratic, 0.1 +((fmodf(i, 90) == 0.0)?0.2:0.0), divs, divs);
        glPopMatrix();
    }*/
}

-(void) drawModels {
	glMatrixMode(GL_MODELVIEW);	
	//glLoadIdentity();
	
	
	[[BirdCage sharedInstance] drawBirdsWithFrameCount:frame];
    [self drawReferenceFrame];
}

-(void) doPostProcessing {
    NSSet * birds = [[BirdCage sharedInstance] birdsInReticule:RETICULE model:__modelview projection:__projection viewport:__viewport];
    NSSet * farAwayVisibleBirds = [[BirdCage sharedInstance] birdsOutOfVisibleRangeInRect:CGRectMake(0, 0, 320, 480) model:__modelview projection:__projection viewport:__viewport];
    NSSet * closeBirds = [[BirdCage sharedInstance] birdsWithinDistance:500000000.0f fromPosition:CGPointMake(0, 0) height:AVERAGE_USER_HEIGHT];
    [self.delegate birdsAreInReticule:birds];
    [self.delegate birdsAreFarAway:farAwayVisibleBirds];
    [self.delegate setBirdsShowingUpInRadar:closeBirds];
}

// Updates the OpenGL view when the timer fires
- (void)drawView
{
	// Make sure that you are drawing to the current context
	[EAGLContext setCurrentContext:context];
	
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	glClear(GL_COLOR_BUFFER_BIT  | GL_DEPTH_BUFFER_BIT);



    [self drawModels];
    [self doPostProcessing];
    
    
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];
    
    frame++;
    frame%=60;
    

}

// Release resources when they are no longer needed.
- (void)dealloc
{
	if([EAGLContext currentContext] == context) {
		[EAGLContext setCurrentContext:nil];
	}
	
	[context release];
	context = nil;
	
	[super dealloc];
}

-(void)setAttitude:(CMAttitude *)attitude {
    
    //NSLog(@"roll pitch yaw heading {%f %f %f}",attitude.roll,attitude.pitch,attitude.yaw);
    //float roll = attitude.roll;
    //float pitch = attitude.pitch;
    //float yaw = attitude.yaw;
    //GLfloat rotHMatrix[16];
    //rotHMatrix[0]=cosf(yaw)*cosf(pitch);  rotHMatrix[1]=cosf(yaw)*sinf(pitch)*sinf(roll)-sinf(yaw)*cosf(roll); rotHMatrix[2]=cosf(yaw)*sinf(pitch)*cosf(roll)+sinf(yaw)*sinf(roll);  rotHMatrix[3]=0;
    //rotHMatrix[4]=sinf(yaw)*cosf(pitch);  rotHMatrix[5]=sinf(yaw)*sinf(pitch)*sinf(roll)+cosf(yaw)*cosf(roll); rotHMatrix[6]=sinf(yaw)*sinf(pitch)*cosf(roll)-cosf(yaw)*sinf(roll);  rotHMatrix[7]=0;
    //rotHMatrix[8]=-sinf(pitch);           rotHMatrix[9]=cosf(pitch)*sinf(roll);                                rotHMatrix[10]=cosf(pitch)*cosf(roll);                                rotHMatrix[11]=0;
    //rotHMatrix[12]=0;                     rotHMatrix[13]=0;                                                    rotHMatrix[14]=0;                                                     rotHMatrix[15]=1;
    //attitude.yaw = h;
    CMRotationMatrix rot=attitude.rotationMatrix;
    GLfloat rotMatrix[16]; //we need to invert the matrix
    rotMatrix[0]=rot.m11; rotMatrix[1]=rot.m21; rotMatrix[2]=rot.m31;  rotMatrix[3]=0;
    rotMatrix[4]=rot.m12; rotMatrix[5]=rot.m22; rotMatrix[6]=rot.m32;  rotMatrix[7]=0;
    rotMatrix[8]=rot.m13; rotMatrix[9]=rot.m23; rotMatrix[10]=rot.m33; rotMatrix[11]=0;
    rotMatrix[12]=0;      rotMatrix[13]=0;      rotMatrix[14]=0;       rotMatrix[15]=1;
    
    glLoadIdentity();

    glMultMatrixf(rotMatrix);
    glRotatef(-90.0f, 0.0f, 0.0f, 1.0f); //to get to enu coordinates
    //NSLog(@"%f",-(h - (- attitude.yaw + M_PI))*180/M_PI);
    glGetFloatv( GL_MODELVIEW_MATRIX, __modelview );
    glGetFloatv( GL_PROJECTION_MATRIX, __projection );
    
    //Retreiving compass orientation
    GLPoint3D farPoint;
	gluUnProject( self.frame.size.width/2.0, self.frame.size.height /2.0,  1, __modelview, __projection, __viewport, &farPoint.x, &farPoint.y, &farPoint.z);
    CGFloat theta;
    if (farPoint.y < 0) {
        theta = 2*M_PI - acosf(farPoint.x/sqrtf(farPoint.x * farPoint.x + farPoint.y * farPoint.y));
    } else {
        theta = acosf(farPoint.x/sqrtf(farPoint.x * farPoint.x + farPoint.y * farPoint.y));
    }
    
    NSLog(@"heading %f",theta);
    [self.delegate updateRadarDirectionWithHeading:theta];
}

-(void)setHeading:(CLHeading*)newHeading withAttitude:(CMAttitude *)attitude {
    float h = DegreeToRadian(newHeading.trueHeading);
    
    //NSLog(@"roll pitch yaw heading {%f %f %f %f}",attitude.roll,attitude.pitch,- attitude.yaw + M_PI,h - (- attitude.yaw + M_PI));
    float roll = attitude.roll;
    float pitch = attitude.pitch;
    float yaw = attitude.yaw;
    GLfloat rotHMatrix[16];
    rotHMatrix[0]=cosf(yaw)*cosf(pitch);  rotHMatrix[1]=cosf(yaw)*sinf(pitch)*sinf(roll)-sinf(yaw)*cosf(roll); rotHMatrix[2]=cosf(yaw)*sinf(pitch)*cosf(roll)+sinf(yaw)*sinf(roll);  rotHMatrix[3]=0;
    rotHMatrix[4]=sinf(yaw)*cosf(pitch);  rotHMatrix[5]=sinf(yaw)*sinf(pitch)*sinf(roll)+cosf(yaw)*cosf(roll); rotHMatrix[6]=sinf(yaw)*sinf(pitch)*cosf(roll)-cosf(yaw)*sinf(roll);  rotHMatrix[7]=0;
    rotHMatrix[8]=-sinf(pitch);           rotHMatrix[9]=cosf(pitch)*sinf(roll);                                rotHMatrix[10]=cosf(pitch)*cosf(roll);                                rotHMatrix[11]=0;
    rotHMatrix[12]=0;                     rotHMatrix[13]=0;                                                    rotHMatrix[14]=0;                                                     rotHMatrix[15]=1;
//attitude.yaw = h;
    CMRotationMatrix rot=attitude.rotationMatrix;
    GLfloat rotMatrix[16]; //we need to invert the matrix
    /*rotMatrix[0]= rotHMatrix[0]; rotMatrix[1]=rotHMatrix[4]; rotMatrix[2]=rotHMatrix[8];  rotMatrix[3]=0;
    rotMatrix[4]=rotHMatrix[1]; rotMatrix[5]=rotHMatrix[5]; rotMatrix[6]=rotHMatrix[9];  rotMatrix[7]=0;
    rotMatrix[8]=rotHMatrix[2]; rotMatrix[9]=rotHMatrix[6]; rotMatrix[10]=rotHMatrix[10]; rotMatrix[11]=0;
    rotMatrix[12]=0;      rotMatrix[13]=0;      rotMatrix[14]=0;       rotMatrix[15]=1;*/
    rotMatrix[0]=rot.m11; rotMatrix[1]=rot.m21; rotMatrix[2]=rot.m31;  rotMatrix[3]=0;
    rotMatrix[4]=rot.m12; rotMatrix[5]=rot.m22; rotMatrix[6]=rot.m32;  rotMatrix[7]=0;
    rotMatrix[8]=rot.m13; rotMatrix[9]=rot.m23; rotMatrix[10]=rot.m33; rotMatrix[11]=0;
    rotMatrix[12]=0;      rotMatrix[13]=0;      rotMatrix[14]=0;       rotMatrix[15]=1;
    
    GLfloat headingMatrix[16]; //we need to invert the matrix
    headingMatrix[0]=cosf(h); headingMatrix[1]=-sinf(h); headingMatrix[2]=0;  headingMatrix[3]=0;
    headingMatrix[4]=sinf(h); headingMatrix[5]=cosf(h); headingMatrix[6]=0;  headingMatrix[7]=0;
    headingMatrix[8]=0;       headingMatrix[9]=0;       headingMatrix[10]=1; headingMatrix[11]=0;
    headingMatrix[12]=0;      headingMatrix[13]=0;      headingMatrix[14]=0; headingMatrix[15]=1;
    
    
    glLoadIdentity();
    //glRotatef(yaw, 0, 0, 1);glRotatef(pitch, 0, 1, 0);glRotatef(roll, 1, 0, 0);
    //glMultMatrixf(headingMatrix);
    //
    //glRotatef(-(h - (- attitude.yaw + M_PI))*180/M_PI, 0, 0, 1);
    glMultMatrixf(rotMatrix);
    //glRotatef(90.0f, 0.0f, 0.0f, 1.0f);
    //NSLog(@"%f",-(h - (- attitude.yaw + M_PI))*180/M_PI);
   glGetFloatv( GL_MODELVIEW_MATRIX, __modelview );
    glGetFloatv( GL_PROJECTION_MATRIX, __projection );
   
}
/*
    
    CGFloat x = lGravity.x;
    CGFloat y = -lGravity.y;
    CGFloat z = lGravity.z;
    CGFloat lRot = DegreeToRadian(newHeading.magneticHeading);
    if (newHeading != nil) {
        float Ax = lGravity.x;
        float Ay = lGravity.y;
        float Az = lGravity.z;
        float filterFactor = 0.2;
        float Mx = [newHeading x] * filterFactor + (Mx * (1.0 - filterFactor));
        float My = [newHeading y] * filterFactor + (My * (1.0 - filterFactor));
        float Mz = [newHeading z] * filterFactor + (Mz * (1.0 - filterFactor));
        
        float counter = (  -pow(Ax, 2)*Mz + Ax*Az*Mx - pow(Ay, 2)*Mz + Ay*Az*My );
        float denominator = ( sqrt( pow((My*Az-Mz*Ay), 2) + pow((Mz*Ax-Mx*Az), 2) + pow((Mx*Ay-My*Ax), 2) ) * sqrt(pow(Ay, 2)+pow(-Ax, 2)) );
        headingCorrected = (acos(counter/denominator)) * filterFactor + (headingCorrected * (1.0 - filterFactor));
        NSLog(@"%f %f ",headingCorrected, lRot);
    }
        
    
    
    CGFloat theta;
    if (y>=0.0) {
        theta = acosf(x/sqrtf(x*x + y*y));
    } else {
        theta = 2*M_PI - acosf(x/sqrtf(x*x + y*y));
    }
    //NSLog(@"%f",lRot);
    //NSLog(@"x %f y %f z %f rho %f phi %f theta %f",x,y,z,pow(x*x+y*y+z*z,1/3),acosf(z),theta);
    
    CGFloat phi = acosf(z);
    CGFloat xRot = asinf(x);
    
    CGFloat yRot = acosf(y);
    CGFloat zRot = asinf(z);
    //center[1] = cos(rotationRadians) + eye[1];
    //center[0] = sin(rotationRadians) + eye[0];
    //NSLog(@"sinf(phi) %f cosf(theta) %f",sinf(phi),cosf(theta));
    center[0] = sinf(phi)*sinf(lRot);
    center[1] = sinf(phi)*cosf(lRot);
    center[2] = z;
    
    up[0] = -x;
    up[1] = -z;
    up[2] = y;
    
    CGFloat north[] = {0,1,0};
    CGFloat east[]  = {1,0,0};
    CGFloat south[]  = {0,-1,0};
    CGFloat west[]  = {-1,0,0};
    CGFloat dir[] = {sinf(lRot-xRot),cosf(lRot-xRot),0};
    CGFloat right[] = {cosf(lRot-xRot),-sinf(lRot-xRot),0};
    
    up[0] = up[1] = 0.0f;
    up[2] = 1.0f;
    
    //up[0] = x*sinf(phi);
    //up[1] = z;
    //up[2] = y*sinf(phi);
    
    CGFloat fudgeAngle = yRot-fabs(zRot);
    if(xRot > 0) fudgeAngle = -fudgeAngle;
    
    center[0] = sinf(phi)*sinf(lRot+fudgeAngle);
    center[1] = sinf(phi)*cosf(lRot+fudgeAngle);
    center[2] = z;
    
    //[EAGLView rotateVector:center aroundAxis:right byAngle:M_PI_2 result:up];

    CGFloat g[] = {x,y,z};
    
    up[0] = x;
    up[1] = z;
    up[2] = y;*/
    
    /*CGFloat newup[3];
    up[0] = -g[0] / sqrtf(1 - g[2]*g[2]);
    up[1] = -g[1] / sqrtf(1 - g[2]*g[2]);
    up[2] = 0.0f;
    
    up[0] = -up[0];
    up[2] = up[1];
    up[1] = z;
    */
    
    /*
    [EAGLView rotateVector:g aroundAxis:center byAngle:M_PI result:newup];
    
    CGFloat m = center[0]*newup[0]+center[1]*newup[1]+center[2]*newup[2];
    m = sqrtf(m);
     
    newup[0] -= center[0]*m;
    newup[1] -= center[1]*m;
    newup[2] -= center[2]*m;
    
    m = newup[0]*newup[0]+newup[1]*newup[1]+newup[2]*newup[2];
     m = sqrtf(m);
     
    up[0] = newup[0] / m;
    up[1] = newup[1] / m;
    up[2] = newup[2] / m;
*/
    
    //[EAGLView rotateVector:dir aroundAxis:right byAngle:phi result:center];
    //[EAGLView rotateVector:up aroundAxis:right byAngle:phi result:newup];
    //[EAGLView rotateVector:newup aroundAxis:center byAngle:-acosf(x) result:up];
    //NSLog(@"center{%f %f %f} up{%f %f %f}",center[0],center[1],center[2],up[0],up[1],up[2]);
    //up[0] = -x;
    //up[1] = -z;
    //up[2] = y;
    //CGFloat thingy[3];
    //[EAGLView rotateVector:north aroundAxis:east byAngle:M_PI_4 result:thingy];
    
    //NSLog(@"{%f %f %f} %f %f",xRot,yRot,zRot,lRot,lRot+fudgeAngle);
//}

-(UIImage *) eaglViewToUIImage {
    NSInteger myDataLength = 320 * 480 * 4;
    
    // allocate array and read pixels into it.
    GLubyte *buffer = (GLubyte *) malloc(myDataLength);
    glReadPixels(0, 0, 320, 480, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
    
    // gl renders "upside down" so swap top to bottom into new array.
    // there's gotta be a better way, but this works.
    GLubyte *buffer2 = (GLubyte *) malloc(myDataLength);
    for(int y = 0; y < 480; y++)
    {
        for(int x = 0; x < 320 * 4; x++)
        {
            buffer2[(479 - y) * 320 * 4 + x] = buffer[y * 4 * 320 + x];
        }
    }
    
    // make data provider with data.
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer2, myDataLength, NULL);
    
    // prep the ingredients
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * 320;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    // make the cgimage
    CGImageRef imageRef = CGImageCreate(320, 480, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    
    // then make the uiimage from that
    UIImage *myImage = [UIImage imageWithCGImage:imageRef];
    return myImage;
}

@end
