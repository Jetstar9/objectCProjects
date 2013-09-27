//
//  Utils.h
//  iBirds
//
//  Created by Samuel Westrich on 10/12/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (float)iOSVersion;

+ (NSString*)md5HexDigest:(NSString*)input;
+ (NSString*)SHA512HexDigest:(NSString*)input;

+ (NSString*)createId;

@end
