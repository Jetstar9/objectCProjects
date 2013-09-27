//
//  Utils.m
//  iBirds
//
//  Created by Samuel Westrich on 10/12/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import "Utils.h"
#import <CommonCrypto/CommonDigest.h>

@implementation Utils

+ (float)iOSVersion {
    
    
    NSString* versionNumber = [[UIDevice currentDevice] systemVersion];
    
    return [versionNumber floatValue];
    
}

+ (NSString*)md5HexDigest:(NSString*)input {
    
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    
    return ret;
    
}

+ (NSString*)SHA512HexDigest:(NSString*)input {
    
    const char* str = [input UTF8String];
    unsigned char result[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(str, strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_SHA512_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    
    return ret;
    
}


+ (NSString*)createId {
    
    CFUUIDRef   uuid;
    CFStringRef uuidStr;
    
    uuid = CFUUIDCreate(NULL);
    uuidStr = CFUUIDCreateString(NULL, uuid);
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yMMddHHmmssSS"];
    NSString *datePart = [df stringFromDate:[NSDate date]];
    [df release];
    NSString * rString = [NSString stringWithFormat:@"%@%@",uuidStr,datePart];
    CFRelease(uuidStr);
    CFRelease(uuid);
    
    return rString;
    
    
}

@end
