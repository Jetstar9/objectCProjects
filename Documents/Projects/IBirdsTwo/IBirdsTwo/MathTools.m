//
//  MathTools.m
//  OverlayTechDemo
//
//  Created by Samuel Westrich on 8/6/11.
//  Copyright 2011 ADYLITICA. All rights reserved.
//

#import "MathTools.h"

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@implementation MathTools

+(void) loadTexture:(NSString*)_path id:(GLuint*) _id
{
    [self loadTextureWithImage:[UIImage imageNamed:_path] id:_id];
}

+(void) loadTextureWithImage:(UIImage*)_image id:(GLuint*) _id
{
    CGImageRef textureImage = _image.CGImage;
    if (textureImage == nil) {
        NSLog(@"Image could not be loaded.");
        return;   
    }
	
    NSInteger textureWidth = CGImageGetWidth(textureImage);
    NSInteger textureHeight = CGImageGetHeight(textureImage);
    
  	GLubyte *textureData = (GLubyte *)malloc(textureWidth * textureHeight * 4); // 4 car RVBA
	
	CGContextRef textureContext = CGBitmapContextCreate(
														textureData,
														textureWidth,
														textureHeight,
														8, textureWidth * 4,
														CGImageGetColorSpace(textureImage),
														kCGImageAlphaPremultipliedLast);
	
	CGContextDrawImage(textureContext,
					   CGRectMake(0.0, 0.0, (float)textureWidth, (float)textureHeight),
					   textureImage);
	
	CGContextRelease(textureContext);
	
	glGenTextures(1, _id);
	glBindTexture(GL_TEXTURE_2D, *_id);
	
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, textureWidth, textureHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, textureData);
	
	free(textureData);
	
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T
					, GL_CLAMP_TO_EDGE);
	glEnable(GL_TEXTURE_2D);	
}


+(Boolean) pointSphereCollision:(GLPoint3D) _point center:(GLPoint3D) _center radius:(GLfloat)_radius
{
	return (POW2(_point.x - _center.x) + POW2(_point.y - _center.y) + POW2(_point.z - _center.z) < POW2(_radius)); 
}

/**
 * Invert this 4x4 matrix.
 */
+(void)invertMatrix:(CGFloat*)m_ result:(CGFloat*)result
{
    float tmp[12];
    float src[16];
    float dst[16];  
    
    // Transpose matrix
    for (int i = 0; i < 4; i++) {
        src[i +  0] = m_[i*4 + 0];
        src[i +  4] = m_[i*4 + 1];
        src[i +  8] = m_[i*4 + 2];
        src[i + 12] = m_[i*4 + 3];
    }
    
    // Calculate pairs for first 8 elements (cofactors) 
    tmp[0] = src[10] * src[15];
    tmp[1] = src[11] * src[14];
    tmp[2] = src[9]  * src[15];
    tmp[3] = src[11] * src[13];
    tmp[4] = src[9]  * src[14];
    tmp[5] = src[10] * src[13];
    tmp[6] = src[8]  * src[15];
    tmp[7] = src[11] * src[12];
    tmp[8] = src[8]  * src[14];
    tmp[9] = src[10] * src[12];
    tmp[10] = src[8] * src[13];
    tmp[11] = src[9] * src[12];
    
    // Calculate first 8 elements (cofactors)
    dst[0]  = tmp[0]*src[5] + tmp[3]*src[6] + tmp[4]*src[7];
    dst[0] -= tmp[1]*src[5] + tmp[2]*src[6] + tmp[5]*src[7];
    dst[1]  = tmp[1]*src[4] + tmp[6]*src[6] + tmp[9]*src[7];
    dst[1] -= tmp[0]*src[4] + tmp[7]*src[6] + tmp[8]*src[7];
    dst[2]  = tmp[2]*src[4] + tmp[7]*src[5] + tmp[10]*src[7];
    dst[2] -= tmp[3]*src[4] + tmp[6]*src[5] + tmp[11]*src[7];
    dst[3]  = tmp[5]*src[4] + tmp[8]*src[5] + tmp[11]*src[6];
    dst[3] -= tmp[4]*src[4] + tmp[9]*src[5] + tmp[10]*src[6];
    dst[4]  = tmp[1]*src[1] + tmp[2]*src[2] + tmp[5]*src[3];
    dst[4] -= tmp[0]*src[1] + tmp[3]*src[2] + tmp[4]*src[3];
    dst[5]  = tmp[0]*src[0] + tmp[7]*src[2] + tmp[8]*src[3];
    dst[5] -= tmp[1]*src[0] + tmp[6]*src[2] + tmp[9]*src[3];
    dst[6]  = tmp[3]*src[0] + tmp[6]*src[1] + tmp[11]*src[3];
    dst[6] -= tmp[2]*src[0] + tmp[7]*src[1] + tmp[10]*src[3];
    dst[7]  = tmp[4]*src[0] + tmp[9]*src[1] + tmp[10]*src[2];
    dst[7] -= tmp[5]*src[0] + tmp[8]*src[1] + tmp[11]*src[2];
    
    // Calculate pairs for second 8 elements (cofactors)
    tmp[0]  = src[2]*src[7];
    tmp[1]  = src[3]*src[6];
    tmp[2]  = src[1]*src[7];
    tmp[3]  = src[3]*src[5];
    tmp[4]  = src[1]*src[6];
    tmp[5]  = src[2]*src[5];
    tmp[6]  = src[0]*src[7];
    tmp[7]  = src[3]*src[4];
    tmp[8]  = src[0]*src[6];
    tmp[9]  = src[2]*src[4];
    tmp[10] = src[0]*src[5];
    tmp[11] = src[1]*src[4];
    
    // Calculate second 8 elements (cofactors)
    dst[8]   = tmp[0] * src[13]  + tmp[3] * src[14]  + tmp[4] * src[15];
    dst[8]  -= tmp[1] * src[13]  + tmp[2] * src[14]  + tmp[5] * src[15];
    dst[9]   = tmp[1] * src[12]  + tmp[6] * src[14]  + tmp[9] * src[15];
    dst[9]  -= tmp[0] * src[12]  + tmp[7] * src[14]  + tmp[8] * src[15];
    dst[10]  = tmp[2] * src[12]  + tmp[7] * src[13]  + tmp[10]* src[15];
    dst[10] -= tmp[3] * src[12]  + tmp[6] * src[13]  + tmp[11]* src[15];
    dst[11]  = tmp[5] * src[12]  + tmp[8] * src[13]  + tmp[11]* src[14];
    dst[11] -= tmp[4] * src[12]  + tmp[9] * src[13]  + tmp[10]* src[14];
    dst[12]  = tmp[2] * src[10]  + tmp[5] * src[11]  + tmp[1] * src[9];
    dst[12] -= tmp[4] * src[11]  + tmp[0] * src[9]   + tmp[3] * src[10];
    dst[13]  = tmp[8] * src[11]  + tmp[0] * src[8]   + tmp[7] * src[10];
    dst[13] -= tmp[6] * src[10]  + tmp[9] * src[11]  + tmp[1] * src[8];
    dst[14]  = tmp[6] * src[9]   + tmp[11]* src[11]  + tmp[3] * src[8];
    dst[14] -= tmp[10]* src[11 ] + tmp[2] * src[8]   + tmp[7] * src[9];
    dst[15]  = tmp[10]* src[10]  + tmp[4] * src[8]   + tmp[9] * src[9];
    dst[15] -= tmp[8] * src[9]   + tmp[11]* src[10]  + tmp[5] * src[8];
    
    // Calculate determinant
    double det = src[0]*dst[0] + src[1]*dst[1] + src[2]*dst[2] + src[3]*dst[3];
    
    // Calculate matrix inverse
    det = 1.0 / det;
    for (int i = 0; i < 16; i++)
        result[i] = dst[i] * det;
}


+(void)rotateVector:(CGFloat*)v aroundAxis:(CGFloat*)u byAngle:(CGFloat)a result:(CGFloat*)r {
    
    CGFloat matrix[3][3];
    
    matrix[0][0] = cosf(a) + u[0]*u[0]*(1-cosf(a));
    matrix[0][1] = u[0]*u[1]*(1-cosf(a))-u[2]*sinf(a);
    matrix[0][2] = u[0]*u[2]*(1-cosf(a))+u[1]*sinf(a);
    
    matrix[1][0] = u[1]*u[0]*(1-cosf(a))+u[2]*sinf(a);
    matrix[1][1] = cosf(a)+u[1]*u[1]*(1-cosf(a));
    matrix[1][2] = u[1]*u[2]*(1-cosf(a))-u[0]*sinf(a);
    
    matrix[2][0] = u[2]*u[0]*(1-cosf(a))-u[1]*sinf(a);
    matrix[2][1] = u[2]*u[1]*(1-cosf(a))+u[0]*sinf(a);
    matrix[2][2] = cosf(a)+u[2]*u[2]*(1-cosf(a));
    
    r[0] = matrix[0][0]*v[0] + matrix[0][1]*v[1] + matrix[0][2]*v[2];
    r[1] = matrix[1][0]*v[0] + matrix[1][1]*v[1] + matrix[1][2]*v[2];
    r[2] = matrix[2][0]*v[0] + matrix[2][1]*v[1] + matrix[2][2]*v[2];    
}

+(void) matrixWillMultiplyMatrix:(const float*)M1 withMatrix:(const float*)M2 result:(float*)Mout
{
	float res[16];
	res[0]  = M1[0]*M2[0]  + M1[4]*M2[1]  + M1[8]*M2[2]  + M1[12]*M2[3];
	res[4]  = M1[0]*M2[4]  + M1[4]*M2[5]  + M1[8]*M2[6]  + M1[12]*M2[7];
	res[8]  = M1[0]*M2[8]  + M1[4]*M2[9]  + M1[8]*M2[10] + M1[12]*M2[11];
	res[12] = M1[0]*M2[12] + M1[4]*M2[13] + M1[8]*M2[14] + M1[12]*M2[15];
	
	res[1]  = M1[1]*M2[0]  + M1[5]*M2[1]  + M1[9]*M2[2]  + M1[13]*M2[3];
	res[5]  = M1[1]*M2[4]  + M1[5]*M2[5]  + M1[9]*M2[6]  + M1[13]*M2[7];
	res[9]  = M1[1]*M2[8]  + M1[5]*M2[9]  + M1[9]*M2[10] + M1[13]*M2[11];
	res[13] = M1[1]*M2[12] + M1[5]*M2[13] + M1[9]*M2[14] + M1[13]*M2[15];
	
	res[2]  = M1[2]*M2[0]  + M1[6]*M2[1]  + M1[10]*M2[2]  + M1[14]*M2[3];
	res[6]  = M1[2]*M2[4]  + M1[6]*M2[5]  + M1[10]*M2[6]  + M1[14]*M2[7];
	res[10] = M1[2]*M2[8]  + M1[6]*M2[9]  + M1[10]*M2[10] + M1[14]*M2[11];
	res[14] = M1[2]*M2[12] + M1[6]*M2[13] + M1[10]*M2[14] + M1[14]*M2[15];
	
	res[3]  = M1[3]*M2[0]  + M1[7]*M2[1]  + M1[11]*M2[2]  + M1[15]*M2[3];
	res[7]  = M1[3]*M2[4]  + M1[7]*M2[5]  + M1[11]*M2[6]  + M1[15]*M2[7];
	res[11] = M1[3]*M2[8]  + M1[7]*M2[9]  + M1[11]*M2[10] + M1[15]*M2[11];
	res[15] = M1[3]*M2[12] + M1[7]*M2[13] + M1[11]*M2[14] + M1[15]*M2[15];
	
	int i;
	for (i=0; i<16; i++)
		Mout[i] = res[i];
}	

+(void) matrixWillMultiplyMatrix:(const float*)M withVector:(const float*)v is4D:(int)voutIs4D result:(float*) vout 
{
	float res[4];
	res[0] = M[0]*v[0] + M[4]*v[1] + M[ 8]*v[2] + M[12]*v[3];
	res[1] = M[1]*v[0] + M[5]*v[1] + M[ 9]*v[2] + M[13]*v[3];
	res[2] = M[2]*v[0] + M[6]*v[1] + M[10]*v[2] + M[14]*v[3];
	res[3] = M[3]*v[0] + M[7]*v[1] + M[11]*v[2] + M[15]*v[3];
	
	if (voutIs4D) {
		vout[0] = res[0];
		vout[1] = res[1];
		vout[2] = res[2];
		vout[3] = res[3];
	}
	else {
		vout[0] = res[0] / res[3];
		vout[1] = res[1] / res[3];
		vout[2] = res[2] / res[3];
	}	
}

+(void) normalize:(float *)v {
	float d = (sqrt((v[0]*v[0]) + (v[1]*v[1]) + (v[2]*v[2])));
    if (d==0.0f)
    {
        return;
    }
	v[0] = v[0] / d;
	v[1] = v[1] / d;
	v[2] = v[2] / d;
}

+(GLPoint3DP)cartesianToPolar:(GLPoint3D)point {
    GLPoint3DP rPoint;
    CGFloat temp = point.x * point.x + point.y * point.y;
    rPoint.rho = sqrtf(temp + point.z * point.z );
    rPoint.phi = acosf(point.z/rPoint.rho);
    if (point.y < 0) {
        rPoint.theta = 2*M_PI - acosf(point.x/sqrtf(temp));
    } else {
        rPoint.theta = acosf(point.x/sqrtf(temp));
    }
    return rPoint;
}

+(CGPoint)lemniscateBernoulliWithRadius:(float)radius parameter:(float)t {
    CGPoint point;
    float sinft = sinf(t);
    float cosft = cosf(t);
    point.x = radius*M_SQRT2*cosft/(sinft*sinft + 1);
    point.y = radius*M_SQRT2*cosft*sinft/(sinft*sinft + 1);
    return point;
}


+(CGPoint)lemniscateBernoulliDerivativeWithRadius:(float)radius parameter:(float)t {
    float sinft = sinf(t);
    float cosft = cosf(t);
    float sinft2 = sinft*sinft;
    float cosft2 = cosft*cosft;
    CGPoint derivative;
    derivative.x = -(M_SQRT2*radius*sinft*sinft2+(2*M_SQRT2*radius*cosft2+M_SQRT2*radius)*sin(t))/(sinft2*sinft2+2*sinft2+1);
    derivative.y = -(M_SQRT2*radius*sinft2*sinft2+(M_SQRT2*radius*cosft2+M_SQRT2*radius)*sinft2-M_SQRT2*radius*cosft2)/(sinft2*sinft2+2*sinft2+1);
    return derivative;
}





@end
