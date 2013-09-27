//
//  Environment.h
//  iBirds
//
//  Created by Samuel Westrich on 9/29/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Bird.h"

@interface Environment : NSObject {

User * currentUser;
Bird * currentBird;
    
}


+(Environment*)sharedInstance;

@property(nonatomic,retain) User * currentUser;
@property(nonatomic,retain) Bird * currentBird;

@end
