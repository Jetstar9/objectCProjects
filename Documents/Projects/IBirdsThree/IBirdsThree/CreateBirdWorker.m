//
//  CreateBirdWorker.m
//  iBirds
//
//  Created by Samuel Westrich on 10/14/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import "CreateBirdWorker.h"
#import "BasicWorker+Protected.h"
#import "NetworkNotifications.h"
#import "ASIFormDataRequest.h"
#import "CJSONDeserializer.h"
#import "CJSONSerializer.h"
#import "BirdParser.h"
#import "AppDelegate.h"
#import "User.h"
#import <CoreLocation/CoreLocation.h>


@implementation CreateBirdWorker

@synthesize bird;


-(void)connect {
	[self connectWithAuthentication];
}


-(NSString*)getUrl {
	
	return @"birds.json";
}

-(NSString*)getMethod {
	return @"PUT";
}

-(void)addDataToRequest:(ASIHTTPRequest *)req {
	ASIFormDataRequest * request = (ASIFormDataRequest *)req;
    CLLocationCoordinate2D coordinate = ((CLLocation*)bird.location).coordinate;
	NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:bird.name,@"bird_name",[NSNumber numberWithDouble:coordinate.latitude],@"location_lat",[NSNumber numberWithDouble:coordinate.longitude],@"location_lon",nil];
	CJSONSerializer * serializer = [[CJSONSerializer alloc] init];
	NSData * string = [serializer serializeDictionary:dict error:nil];
	[serializer release];
	[request appendPostData:string];
    
}

-(User*)getUser {
	NSManagedObjectContext *context = [((AppDelegate*)[UIApplication sharedApplication].delegate) managedObjectContext];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" 
											  inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	[fetchRequest setFetchLimit:1];
	[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"cloudPassword == %@", user.cloudPassword]];
	
	NSError *error = nil;
	
	NSArray *users = [context executeFetchRequest:fetchRequest error:&error];
	
	if(error!= nil){
		NSLog(@"bad request: getUser in RegisterWorker");
	}
	
	[fetchRequest release];
	if ([users count] < 1) {
		NSLog(@"%@",@"No Sessions found");
		return nil;
	} else  {
		return [users objectAtIndex:0];
	}
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
		BirdParser *parser = [[BirdParser alloc] initWithJSONData:[request responseData]];
        [parser setBird:bird];
		[parser setUser:user];
        NSArray * array = [parser parse];
        [[NSNotificationCenter defaultCenter] postNotificationName:n_BirdRegistered
															object:self 
														  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[array objectAtIndex:0],@"bird",nil]];
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
