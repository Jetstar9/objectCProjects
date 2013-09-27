//
//  BirdViewControllerProtocol.h
//  iBirds
//
//  Created by Samuel Westrich on 10/11/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BirdViewControllerProtocol <NSObject>

-(BOOL)needsNetworkValidation;

-(void)hasBeenValidatedByButtonWithIdentifier:(NSString*)identifier;

@end
