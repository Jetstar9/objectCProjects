//
//  BasicWorker.h
//  Adylitica
//
//  Created by Samuel Westrich on 10/11/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "User.h"


#define BASEURL @"http://192.168.1.191:8080/v1/"

#define maxConnectionAttempts 3

@interface BasicWorker : NSObject {
	
    User * user;
	NSInteger tryCount;
    
}

@property (nonatomic,retain) User * user;

+(NSOperationQueue*)sharedOperationQueue;

-(id)initWithUser:(User*)user;
-(void)connect;
-(NSString*)getUrl;
-(NSString*)getMethod;
-(NSString*)getContentType;
-(void)addDataToRequest:(ASIHTTPRequest*)req;
-(void)retryConnection;
@end