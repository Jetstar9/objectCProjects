//
//  Bird.m
//  OverlayTechDemo
//
//  Created by Samuel Westrich on 7/28/11.
//  Copyright 2011 ADYLITICA. All rights reserved.
//

#import "BirdObject.h"
#import <OpenGLES/ES1/gl.h>
#import "glues.h"
#import "MathTools.h"
#import "CLLocation+Addons.h"
#import "UserLocationManager.h"

#define DegreeToRadian(x) ((x) * M_PI / 180.0f)
#define EarthRadius 6377200.0
#define BirdCatchingDistance 2.1f

@implementation BirdObject

@synthesize identifier;
@synthesize location;
@synthesize name;
@synthesize distance;
@synthesize speed;
@synthesize delegate;
@synthesize screenX;
@synthesize screenY;


- (id)initWithIdentifier:(NSNumber*)lIdentifier location:(CLLocation*)lLocation
{
    self = [super init];
    if (self) {

        self.identifier = lIdentifier;
        self.location = lLocation;
        // Initialization code here.
        scaleValue = 1.f;
        alpha = 1;
        mass = 1;
        lastUpdate = [[NSDate date] retain];
        maxspeed = 10.0f;
        CLLocation * currentLocation = [[UserLocationManager sharedInstance] currentLocation];
        NSLog(@"Current location is %@",currentLocation);
        Point3D p = [currentLocation cartesianDistanceToLocation:lLocation];
        x = p.x; //e
        y = p.y; //n
        z = p.z; //u
        NSLog(@"Placing bird at east %f north %f  up %f",p.x,p.y,p.z);
    }
    
    return self;
}

- (id)initWithIdentifier:(NSNumber*)lIdentifier location:(CLLocation*)lLocation name:(NSString*)lName {
    self = [self initWithIdentifier:lIdentifier location:lLocation];
    if (self) {
        self.name = lName;
    }
    return self;
}

// Texture dimensions must be a power of 2.
-(void)setupForViewingWithTextures:(NSArray*)textures {
    color[0] = 1.0f;
    color[1] = 1.0f;
    color[2] = 1.0f;
    offset=arc4random()%30;
    CGContextRef spriteContext;
    spriteTexture = calloc(textures.count, sizeof(GLuint));
    frames = textures.count;
    int i = 0;
    // Use OpenGL ES to generate a name for the 2 textures.
    glGenTextures(textures.count, spriteTexture);
    for(NSString * textureName in textures) {
        CGImageRef spriteImage = [UIImage imageNamed:textureName].CGImage;
        GLubyte *spriteData;
        float width = CGImageGetWidth(spriteImage);
        float height = CGImageGetHeight(spriteImage);
        if(spriteImage) {
            // Allocated memory needed for the bitmap context
            spriteData = (GLubyte *) calloc(width * height * 4, sizeof(GLubyte));
            // Uses the bitmap creation function provided by the Core Graphics framework. 
            spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width * 4, CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
            // After you create the context, you can draw the sprite image to the context.
            CGContextDrawImage(spriteContext, CGRectMake(0.0, 0.0, (CGFloat)width, (CGFloat)height), spriteImage);
            // You don't need the context at this point, so you need to release it to avoid memory leaks.
            CGContextRelease(spriteContext);
            
            // Bind the texture name. 
            glBindTexture(GL_TEXTURE_2D, spriteTexture[i]);
            // Set the texture parameters to use a minifying filter and a linear filer (weighted average)
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
            // Specify a 2D texture image, providing the a pointer to the image data in memory
            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
            // Release the image data
            free(spriteData);
            
            // Enable use of the texture
            glEnable(GL_TEXTURE_2D);
            
        }
        i++;
        
    }
    
}

-(void) processTransformation
{
    
	/*CGFloat distanceCoeff = INTERACTIVE_OBJECT_DISTANCE;
	
	self.x = cos(DegreeToRadian(self.pan)) * distanceCoeff;
	self.y = sin(DegreeToRadian(self.tilt)) * distanceCoeff;
	self.z = -sin(DegreeToRadian(self.pan)) * distanceCoeff;*/
}

// Sets up an array of values to use as the sprite vertices.
#define NORTH
#ifdef NORTH 

const GLfloat spriteVertices[] = {
    -0.5f,0.0, -0.25f,
    0.5f,0.0, -0.25f,
    -0.5f,0.0, 0.25f,
    0.5f,0.0, 0.25f,
};

/*const GLfloat spriteVertices[] = {
    0.0,-0.5f, -0.25f,
    0.0,0.5f, -0.25f,
    0.0,-0.5f, 0.25f,
    0.0,0.5f, 0.25f,
};*/
#else
const GLfloat spriteVertices[] = {
    -0.5f,-0.25f,0.0, 
    0.5f,-0.25f,0.0, 
    -0.5f,0.25f,0.0, 
    0.5f,0.25f,0.0, 
};
#endif

// Sets up an array of values for the texture coordinates.
const GLshort spriteTexcoords[] = {
    1, 1,
    0, 1,
    1, 0,
    0, 0,
};

-(void) drawWithFrameCount:(NSInteger)frame
{
	[self processTransformation];
    
    // Sets up pointers and enables states needed for using vertex arrays and textures
    glColor4f(color[0], color[1], color[2],1.0f);
	glVertexPointer(3, GL_FLOAT, 0, spriteVertices);
	glEnableClientState(GL_VERTEX_ARRAY);
	glTexCoordPointer(2, GL_SHORT, 0, spriteTexcoords);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glEnable(GL_TEXTURE_2D);
    int pos = ((frame+offset) % 30) / (30 / frames);

    // Bind the texture name. 
    glBindTexture(GL_TEXTURE_2D, spriteTexture[pos]);
    
    float lookAt[3],objToCamProj[3], objToCam[3], upAux[3];
	float angleCosine;
    float camX = 0; float camY = 0; float camZ = 0;
	glPushMatrix();
    glTranslatef(self.x, self.y, self.z);
    
    // objToCamProj is the vector in world coordinates from the 
    // local origin to the camera projected in the XY plane
	objToCamProj[0] = camX - self.x ;
	objToCamProj[1] = camY - self.y ;
	objToCamProj[2] = 0;
    
    // This is the original lookAt vector for the object 
    // in world coordinates
	lookAt[0] = 0;
	lookAt[1] = 1;
	lookAt[2] = 0;
    
    
    // normalize both vectors to get the cosine directly afterwards
	[MathTools normalize:objToCamProj];
    
    // easy fix to determine wether the angle is negative or positive
    // for positive angles upAux will be a vector pointing in the 
    // positive y direction, otherwise upAux will point downwards
    // effectively reversing the rotation.
    
	mathsCrossProduct(upAux,lookAt,objToCamProj);
    // compute the angle
	angleCosine = mathsInnerProduct(lookAt,objToCamProj);
    //NSLog(@"{%f %f %f %f}",upAux[0],upAux[1],upAux[2],angleCosine);
    // perform the rotation. The if statement is used for stability reasons
    // if the lookAt and objToCamProj vectors are too close together then 
    // |angleCosine| could be bigger than 1 due to lack of precision
    if ((angleCosine < 0.99990) && (angleCosine > -0.9999))
        glRotatef(acos(angleCosine)*180/3.14,upAux[0], upAux[1], upAux[2]);	
    
    // so far it is just like the cylindrical billboard. The code for the 
    // second rotation comes now
    // The second part tilts the object so that it faces the camera
    
    // objToCam is the vector in world coordinates from 
    // the local origin to the camera
	objToCam[0] = camX - self.x;
	objToCam[1] = camY - self.y;
	objToCam[2] = camZ - self.z;
    
    // Normalize to get the cosine afterwards
	[MathTools normalize:objToCam];
    
    // Compute the angle between objToCamProj and objToCam, 
    //i.e. compute the required angle for the lookup vector
    
	angleCosine = mathsInnerProduct(objToCamProj,objToCam);
    
    
    // Tilt the object. The test is done to prevent instability 
    // when objToCam and objToCamProj have a very small
    // angle between them
    
	if ((angleCosine < 0.99990) && (angleCosine > -0.9999))
		if (objToCam[1] < 0)
			glRotatef(acos(angleCosine)*180/3.14,1,0,0);	
		else
			glRotatef(acos(angleCosine)*180/3.14,-1,0,0);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glPopMatrix();
    /*glPushMatrix();
    glTranslatef(self.x, self.y, self.z);
    GLfloat modelViewMatrix[16];
    glGetFloatv(GL_MODELVIEW_MATRIX, modelViewMatrix);
    GLfloat look[3], right[3], up[3];
    GLfloat m[4][4];
    
    look[0] = -self.x;
    look[1] = -self.y;
    look[2] = -self.z;
    
    up[0] = modelViewMatrix[1];
    up[1] = modelViewMatrix[5];
    up[2] = modelViewMatrix[9];
    
    normalize1(look);
    

    cross1(look, up, right);
    normalize1(right);
    

    cross1(right, look, up);

    m[0][0] = right[0];
    m[1][0] = right[1];
    m[2][0] = right[2];
    m[3][0] = 0.0f;
    m[0][1] = up[0];
    m[1][1] = up[1];
    m[2][1] = up[2];
    m[3][1] = modelViewMatrix[13];
    m[0][2] = -look[0];
    m[1][2] = -look[1];
    m[2][2] = -look[2];
    m[3][2] = modelViewMatrix[14];
    m[0][3] = modelViewMatrix[3];
    m[1][3] = modelViewMatrix[7];
    m[2][3] = modelViewMatrix[11];
    m[3][3] = modelViewMatrix[15];

    glLoadMatrixf(&(m[0][0]));
    //glRotatef((M_PI_2 - yaw)*180/M_PI, 0.0f, 0.0f, 1.0f);
    //glScalef(scaleValue , scaleValue , scaleValue);
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glPopMatrix();*/
    /*glPushMatrix();
    glTranslatef(self.x, self.y, self.z);
    GLfloat modelViewMatrix[16];
    glGetFloatv(GL_MODELVIEW_MATRIX, modelViewMatrix);
    NSLog(@"camera view up {%f %f %f}",modelViewMatrix[1],modelViewMatrix[5],modelViewMatrix[9]);
    //float yaw = atan2f(-modelViewMatrix[8], sqrtf(modelViewMatrix[9]*modelViewMatrix[9]+modelViewMatrix[10]*modelViewMatrix[10]));
    //NSLog(@"%f",yaw);
    // undo all rotations
    // beware all scaling is lost as well 
    modelViewMatrix[0]=1.0;
    modelViewMatrix[1]=0.0;
    modelViewMatrix[2]=0.0;
    
    modelViewMatrix[4]=0.0;
    modelViewMatrix[5]=1.0;
    modelViewMatrix[6]=0.0;
    
    modelViewMatrix[8]=0.0;
    modelViewMatrix[9]=0.0;
    modelViewMatrix[10]=1.0;

    // set the modelview with no rotations and scaling
    glLoadMatrixf(modelViewMatrix);
    //glRotatef((M_PI_2 - yaw)*180/M_PI, 0.0f, 0.0f, 1.0f);
    //glScalef(scaleValue , scaleValue , scaleValue);
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glPopMatrix();*/
    
    glDisableClientState(GL_VERTEX_ARRAY);	
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    glDisable(GL_TEXTURE_2D);
    
}

-(void) update
{
	//self.rotation = ((int)(self.rotation + 2 )) % 360;
}





-(void) fireAction
{
	NSLog(@"Fired");
	//self.alpha = 0.5f;
    //color[0] = 1.0f;
    //color[1] = 0.0f;
    //color[2] = 0.0f;
    [lastUpdate release];
    lastUpdate = [[NSDate date] retain];
    movement = [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)(1.0 / 20.0) target:self selector:@selector(updatePVA) userInfo:nil repeats:TRUE];
}

-(void)setIsTargeted:(Boolean)wellIsItQuestionMark {
    
    if (!targeted && wellIsItQuestionMark) {
        [self fireAction];
    }
    if (!wellIsItQuestionMark && targeted) {
        NSLog(@"Invalidated");
        [movement invalidate];
    }
    targeted = wellIsItQuestionMark;
}


-(void) updatePositionWithInterval:(float)dTime {
    if (targeted & (distance <BirdCatchingDistance)) {
        [self.delegate birdIsCatchable:self];
        return;
    }
    x += v[0]*(dTime);
    y += v[1]*(dTime);
    z += v[2]*(dTime);
}

-(void) updateVelocityWithInterval:(float)dTime {
    if (distance <BirdCatchingDistance) {
        v[0] = 0.0f;
        v[1] = 0.0f;
        v[2] = 0.0f;
        return;
    }
    v[0] += a[0]*(dTime);
    v[1] += a[1]*(dTime);
    v[2] += a[2]*(dTime);
    /*
    if (distance < 5.0) {
        v[0] = (v[0] + 1)/v[0];
        v[1] = (v[1] + 1)/v[1];
        v[2] = (v[2] + 1)/v[2];
    }*/
}

-(CGFloat)getDistanceFromX:(CGFloat)lx Y:(CGFloat)ly Z:(CGFloat)lz {
    float xdif = lx - x;
    float ydif = ly - y;
    float zdif = lz - z;
    return sqrtf(xdif*xdif + ydif*ydif + zdif*zdif);
}

-(void)updateAcceleration {
    //Sum forces = mass * acceleration
    //acceleration = forces/mass
    //as forces we have pull towards user
    float userPosX = 0;
    float userPosY = 0;
    float userPosZ = 0;
    float baitForce = 10.0;
    a[0] = userPosX - x;
    a[1] = userPosY - y;
    a[2] = userPosZ - z;
    
    [MathTools normalize:a];
    //NSLog(@"{%f %f %f}",a[0],a[1],a[2]);
    float attraction = baitForce;//distance;
    //NSLog(@"%f %f %f %f",attraction,speedDiff,baitForce,distance);
    a[0] *= ((-maxspeed*a[0]+v[0])/maxspeed)*attraction;
    a[1] *= ((-maxspeed*a[1]+v[1])/maxspeed)*attraction;
    a[2] *= ((-maxspeed*a[2]+v[2])/maxspeed)*attraction;
    //NSLog(@"{%f %f %f}",a[0],a[1],a[2]);
    if (distance < 1.0) {
        a[0] -= a[0]/sqrtf(distance);
        a[1] -= a[1]/sqrtf(distance);
        a[2] -= a[2]/sqrtf(distance);
    }
}

-(void)updatePVA {
    distance = [self getDistanceFromX:0.0f Y:0.0f Z:0.0f];
    //NSLog(@"distance %f",distance);
    speed = sqrtf(v[0]*v[0] + v[1]*v[1] + v[2]*v[2]); //in m/s
    [self updateAcceleration];
    float interval = [lastUpdate timeIntervalSinceNow];
    [lastUpdate release];
    lastUpdate = [[NSDate date] retain];
    //NSLog(@"%f",interval);
    [self updateVelocityWithInterval:-interval];
    [self updatePositionWithInterval:-interval];
    //NSLog(@"{%f %f %f}",x,y,z);
}


-(CGFloat)getXDistanceFromLocation:(CLLocation*)lLocation {
    CGFloat degrees = fabs(self.location.coordinate.latitude - lLocation.coordinate.latitude);
    NSLog(@"y %f",degrees * 111300);
    return degrees * 111300;
}
-(CGFloat)getYDistanceFromLocation:(CLLocation*)lLocation {
    CGFloat degrees = fabs(self.location.coordinate.longitude - lLocation.coordinate.longitude);
    NSLog(@"x %f",degrees * 111300);
    return degrees * 111300;
}

-(void)dealloc {
    free(spriteTexture);
    [super dealloc];
}

@end
