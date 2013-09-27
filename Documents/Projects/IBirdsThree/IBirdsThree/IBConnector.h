//
//  IBConnector.h
//  iBirds
//
//  Created by Samuel Westrich on 10/11/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

typedef enum {
	
	unconnected = 0,
	connected = 1,
	connecting = 2
	
} ConnectionStatus;

@interface IBConnector : NSObject {
    NSMutableData *receivedData;
    ConnectionStatus state;
}


+(IBConnector*)sharedInstance;

-(void)registerUser:(User*)user;
-(void)getBirdsForUser:(User*)user;
-(void)createBird:(Bird*)bird forUser:(User*)user;
-(void)refreshBird:(Bird*)bird forUser:(User*)user;

-(void)closestBirdsForUser:(User*)user;

@end
