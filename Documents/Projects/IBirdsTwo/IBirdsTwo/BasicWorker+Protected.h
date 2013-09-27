//
//  BasicWorker+Protected.h
//  iBirds
//
//  Created by Samuel Westrich on 10/11/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import "BasicWorker.h"

@interface BasicWorker (Protected)

-(void)connectWithAuthentication;

-(void)connectWithoutAuthentication;

-(void)requestFinished:(ASIHTTPRequest *)request;

-(void)requestFailed:(ASIHTTPRequest *)request;

@end
