//
//  IBConnector.m
//  iBirds
//
//  Created by Samuel Westrich on 10/11/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import "IBConnector.h"
#import "NetworkNotifications.h"
#import "Reachability.h"
#import "UserLocationManager.h"

#import "RegisterWorker.h"
#import "GetBirdsWorker.h"
#import "UserInfoWorker.h"
#import "CreateBirdWorker.h"
#import "ClosestBirdsWorker.h"

static IBConnector *sharedInstance = nil;

@implementation IBConnector


-(id)init {
    
    if( (self = [super init]) != nil) {
        
        //[[NSNotificationCenter defaultCenter] addObserver:self
        //                                         selector:@selector(userConnected:)
        //                                             name:n_UserConnected object:nil];
        
    }
    
    return self;
    
}

-(BOOL)isOnline {
	
	//Check the connection
	Reachability *reachability = [Reachability reachabilityForInternetConnection];
	return     ([reachability currentReachabilityStatus] == ReachableViaWWAN) 
	|| ([reachability currentReachabilityStatus] == ReachableViaWiFi);    
}

#pragma mark --
#pragma mark Registering

-(void)registerUser:(User*)user {
	if ([self isOnline]) {
		RegisterWorker *worker = [[RegisterWorker alloc] init];
		[worker setUser:user];
		[worker connect];
		[worker release];
	} else {
		[[NSNotificationCenter defaultCenter] postNotificationName:n_UserDisconnected 
															object:self 
														  userInfo:nil];
	}
}

-(void)completeUserInfo:(User*)user {
    if ([self isOnline]) {
		UserInfoWorker *worker = [[UserInfoWorker alloc] init];
		[worker setUser:user];
		[worker connect];
		[worker release];
	} else {
		[[NSNotificationCenter defaultCenter] postNotificationName:n_UserDisconnected 
															object:self 
														  userInfo:nil];
	}
}


#pragma mark --
#pragma mark Birds

-(void)getBirdsForUser:(User*)user {
    if ([self isOnline]) {
        if (user.userId == nil) {
            [self completeUserInfo:user];
             
        } else {
            GetBirdsWorker *worker = [[GetBirdsWorker alloc] init];
            NSLog(@"%@ %@",user.email,user.cloudPassword);
            [worker setUser:user];
            [worker connect];
            [worker release];
        }

	} else {
		[[NSNotificationCenter defaultCenter] postNotificationName:n_UserDisconnected 
															object:self 
														  userInfo:nil];
	}
}

-(void)createBird:(Bird*)bird forUser:(User*)user {
    if ([self isOnline]) {
        
            CreateBirdWorker *worker = [[CreateBirdWorker alloc] init];
            [worker setUser:user];
            [worker setBird:bird];
            [worker connect];
            [worker release];
	} else {
		[[NSNotificationCenter defaultCenter] postNotificationName:n_UserDisconnected 
															object:self 
														  userInfo:nil];
	}
}

-(void)refreshBird:(Bird*)bird forUser:(User*)user {
    if ([self isOnline]) {
        if (user.userId == nil) {
            [self completeUserInfo:user];
            
        } else {
        GetBirdsWorker *worker = [[GetBirdsWorker alloc] init];
        [worker setBird:bird];
        [worker setUser:user];
        [worker connect];
        [worker release];
        }
	} else {
		[[NSNotificationCenter defaultCenter] postNotificationName:n_UserDisconnected 
															object:self 
														  userInfo:nil];
	}
}

-(void)closestBirdsForUser:(User*)user {
    if ([self isOnline]) {
        if (user.userId == nil) {
            [self completeUserInfo:user];
            
        } else {
            ClosestBirdsWorker *worker = [[ClosestBirdsWorker alloc] init];
            [worker setUser:user];
            [worker setPlace:[[[UserLocationManager sharedInstance] currentLocation] coordinate]];
            [worker connect];
            [worker release];
        }
	} else {
		[[NSNotificationCenter defaultCenter] postNotificationName:n_UserDisconnected 
															object:self 
														  userInfo:nil];
	}
}


#pragma mark -
#pragma mark Singleton methods

+ (IBConnector*)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
			sharedInstance = [[IBConnector alloc] init];
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (oneway void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}



@end
