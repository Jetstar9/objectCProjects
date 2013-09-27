//
//  BasicWorker.m
//  Adylitica
//
//  Created by Samuel Westrich on 10/11/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//


#import "BasicWorker+Protected.h"
#import "NetworkNotifications.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

#define showSendingMessages


static NSOperationQueue* sharedOperationQueue;


@implementation BasicWorker

@synthesize user;

int encode(unsigned s_len, char *src, unsigned d_len, char *dst);

+(NSOperationQueue*)sharedOperationQueue {
	@synchronized(self)
    {
        if (sharedOperationQueue == nil)
			sharedOperationQueue = [[NSOperationQueue alloc] init];
    }
    return sharedOperationQueue;
}


static char base64[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
"abcdefghijklmnopqrstuvwxyz"
"0123456789"
"+/";

int encode(unsigned s_len, char *src, unsigned d_len, char *dst)
{
    unsigned triad;
	
    for (triad = 0; triad < s_len; triad += 3)
    {
		unsigned long int sr = 0;
		unsigned byte;
		
		for (byte = 0; (byte<3)&&(triad+byte<s_len); ++byte)
		{
			sr <<= 8;
			sr |= (*(src+triad+byte) & 0xff);
		}
		
		sr <<= (6-((8*byte)%6))%6; /*shift left to next 6bit alignment*/
		
		if (d_len < 4) return 1; /* error - dest too short */
		
		*(dst+0) = *(dst+1) = *(dst+2) = *(dst+3) = '=';
		switch(byte)
		{
			case 3:
				*(dst+3) = base64[sr&0x3f];
				sr >>= 6;
			case 2:
				*(dst+2) = base64[sr&0x3f];
				sr >>= 6;
			case 1:
				*(dst+1) = base64[sr&0x3f];
				sr >>= 6;
				*(dst+0) = base64[sr&0x3f];
		}
		dst += 4; d_len -= 4;
    }
	
    return 0;
	
}


-(id)initWithUser:(User*)lUser {
    self = [super init];
    if (self) {
        self.user = lUser;
    }
    return self;
    
}

-(void)dealloc {
    [user release];
    [super dealloc];
    
}


-(void)connect {
	
}

-(void)connectWithAuthentication {
  	if (![BasicWorker sharedOperationQueue]) {
		sharedOperationQueue = [[NSOperationQueue alloc] init];
	}
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASEURL,[self getUrl]]];
#ifdef showSendingMessages
	NSLog(@"WE ARE SENDING HERE ==>>>> %@",url);
#endif
	ASIHTTPRequest *request;
	if (([[self getMethod] isEqualToString:@"POST"]) || ([[self getMethod] isEqualToString:@"PUT"])) {
		request = [ASIFormDataRequest requestWithURL:url];
	} else {
	    request= [ASIHTTPRequest requestWithURL:url]; 
	}
	[request setUseKeychainPersistence:YES];
	[request addRequestHeader:@"Accept" value:@"application/json"];
	[request addRequestHeader:@"Content-Type" value:[self getContentType]];
	[request setRequestMethod:[self getMethod]];
	
	[request setValidatesSecureCertificate:NO];
	[request setDelegate:self];
    [request setPassword:user.cloudPassword];
	[request setUsername:user.email];
	[request setShouldPresentCredentialsBeforeChallenge:TRUE];
  	[self addDataToRequest:request];
	[sharedOperationQueue addOperation:request]; //queue is an NSOperationQueue
	[self retain];
    
}

-(void)connectWithoutAuthentication {
  	if (![BasicWorker sharedOperationQueue]) {
		sharedOperationQueue = [[NSOperationQueue alloc] init];
	}
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASEURL,[self getUrl]]];
#ifdef showSendingMessages
	NSLog(@"WE ARE SENDING HERE ==>>>> %@",url);
#endif
	ASIHTTPRequest *request;
	if (([[self getMethod] isEqualToString:@"POST"]) || ([[self getMethod] isEqualToString:@"PUT"])) {
		request = [ASIFormDataRequest requestWithURL:url];
	} else {
	    request= [ASIHTTPRequest requestWithURL:url]; 
	}
	[request setUseKeychainPersistence:YES];
	[request addRequestHeader:@"Accept" value:@"application/json"];
	[request addRequestHeader:@"Content-Type" value:[self getContentType]];
	[request setRequestMethod:[self getMethod]];
	[request setValidatesSecureCertificate:NO];
	[request setDelegate:self];
  	[self addDataToRequest:request];
	[sharedOperationQueue addOperation:request]; //queue is an NSOperationQueue
	[self retain];
    NSLog(@"%@",[[NSString alloc] initWithData:[request postBody] encoding:NSUTF8StringEncoding]);
	
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
	// Use when fetching text data
	NSString *responseString = [request responseString];
	NSLog(@"%@",responseString);
    NSLog(@"response code %d",[request responseStatusCode]);
	// Use when fetching binary data
	//NSData *responseData = [request responseData];
	//[self release];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
	NSLog(@"%@",error);
	NSString *responseString = [request responseString];
	NSLog(@"%@",responseString);
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" 
													message:@"The iBirds Service is not accessible, please try again later." 
												   delegate:nil 
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
	[self release];
}


//Hook methods

-(NSString*)getUrl {
    
    return @"";
    
}

-(NSString*)getMethod {
    
    return @"POST";
}

-(NSString*)getContentType {
	
	return @"application/json";
}


-(void)addDataToRequest:(ASIHTTPRequest*)req {
    
}


-(void)retryConnection {
	if (tryCount == maxConnectionAttempts || [[self getMethod] isEqualToString:@"POST"] || [[self getMethod] isEqualToString:@"PUT"]) {
		[[NSNotificationCenter defaultCenter] postNotificationName:n_RequestTimedOut
															object:self 
														  userInfo:nil];	
	} else {
		tryCount++;
		[self connect];
	}
	
}

@end
