//
//  ClosestBirdsWorker.m
//  iBirds
//
//  Created by Samuel Westrich on 10/18/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import "ClosestBirdsWorker.h"
#import "BasicWorker+Protected.h"
#import "NetworkNotifications.h"
#import "ASIFormDataRequest.h"
#import "CJSONDeserializer.h"
#import "CJSONSerializer.h"
#import "AppDelegate.h"
#import "User.h"
#import "BirdParser.h"


@implementation ClosestBirdsWorker

@synthesize place;

-(void)dealloc {
    [super dealloc];
}

-(void)connect {
	[self connectWithAuthentication];
}


-(NSString*)getUrl {
	return [NSString stringWithFormat:@"birds.json?for_area=%f,%f",place.latitude,place.longitude];
}

-(NSString*)getMethod {
	return @"GET";
}

-(void)addDataToRequest:(ASIHTTPRequest *)req {
    
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
	NSError *error = nil;
	NSDictionary *structureDictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:[request responseData] error:&error];
	if ((error) || [structureDictionary isKindOfClass:[NSNull class]]) 
	{
		NSString * jsonString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
		if ([jsonString isEqualToString:@"null"]) {
			[jsonString release];
			return ;
		}
		else if (error) NSLog(@"%@",error);
	}
	
	if ([request responseStatusCode] == 200) { //Authenticated
		BirdParser *parser = [[BirdParser alloc] initWithJSONData:[request responseData]];
		[parser setUser:user];
        [parser setMultiple:TRUE];
        NSArray * closeBirds = [parser parse];
        [[NSNotificationCenter defaultCenter] postNotificationName:n_ClosestBirdsReceived
															object:self 
														  userInfo:[NSDictionary dictionaryWithObject:closeBirds forKey:@"closeBirds"]];
		[parser release];
		
	} else {
		[self retryConnection];
	}
	[self release];
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
	NSLog(@"%@",error);
	//NSString *responseString = [request responseStatusCode];
	NSLog(@"%d",[request responseStatusCode]);
	if ([request responseStatusCode] == 401) {
		[[NSNotificationCenter defaultCenter] postNotificationName:n_WrongCredentials 
                                                            object:self 
                                                          userInfo:nil];
	} else {
		[self retryConnection];
        
	}
	[self release];
}

-(void)retryConnection {
	if (tryCount == maxConnectionAttempts || [[self getMethod] isEqualToString:@"POST"]) {
		[[NSNotificationCenter defaultCenter] postNotificationName:n_UserDisconnected
															object:self 
														  userInfo:nil];	
	} else {
		tryCount++;
		[self connect];
	}
	
}

@end