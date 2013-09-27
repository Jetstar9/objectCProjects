//
//  UserInfoWorker.m
//  iBirds
//
//  Created by Samuel Westrich on 10/13/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import "UserInfoWorker.h"
#import "BasicWorker+Protected.h"
#import "NetworkNotifications.h"
#import "ASIFormDataRequest.h"
#import "CJSONDeserializer.h"
#import "CJSONSerializer.h"
#import "UserInfoParser.h"
#import "AppDelegate.h"
#import "User.h"


@implementation UserInfoWorker


-(void)connect {
	[self connectWithAuthentication];
}


-(NSString*)getUrl {
	
	return @"users/login.json";
}

-(NSString*)getMethod {
	return @"GET";
}

-(void)addDataToRequest:(ASIHTTPRequest *)req {

    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
	NSError *error = nil;
    [super requestFinished:request];
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
		UserInfoParser *parser = [[UserInfoParser alloc] initWithJSONData:[request responseData]];
		[parser setUser:user];
        [parser parseWithoutSaving];
        NSLog(@"user refreshed:%@",[user userId]);
		[[NSNotificationCenter defaultCenter] postNotificationName:n_UserConnected
															object:self 
														  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:user,@"user",nil]];
		[parser release];
		
	} else if ([request responseStatusCode] == 403) { //Auth failure
		[[NSNotificationCenter defaultCenter] postNotificationName:n_WrongCredentials
															object:self 
														  userInfo:nil];
		
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
